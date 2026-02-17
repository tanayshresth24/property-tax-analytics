from airflow import DAG
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from datetime import datetime, timedelta


# =========================================================
# RETRY CONFIGURATION
# =========================================================

default_args = {
    "owner": "data_engineer",

    # Retry behavior
    "retries": 3,
    "retry_delay": timedelta(minutes=5),

    # Advanced retry strategy
    "retry_exponential_backoff": True,
    "max_retry_delay": timedelta(minutes=30),
}


# =========================================================
# DAG DEFINITION
# =========================================================

with DAG(
    dag_id="property_tax_pipeline",
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,   # Manual trigger for assignment
    catchup=False,
    default_args=default_args,
    description="Property Tax Analytics ETL Pipeline",
    tags=["etl", "analytics", "property-tax"],
) as dag:


    # =====================================================
    # STEP 1 — Create Analytics Schema & Tables
    # =====================================================

    create_schema = SQLExecuteQueryOperator(
        task_id="create_analytics_schema",
        conn_id="postgres_default",
        sql="sql/ddl_analytics.sql",
    )


    # =====================================================
    # STEP 2 — Load Property Dimension
    # =====================================================

    load_dim_property = SQLExecuteQueryOperator(
        task_id="load_dim_property",
        conn_id="postgres_default",
        sql="sql/load_dim_property.sql",
    )


    # =====================================================
    # STEP 3 — Load Time Dimension
    # =====================================================

    load_dim_time = SQLExecuteQueryOperator(
        task_id="load_dim_time",
        conn_id="postgres_default",
        sql="sql/load_dim_time.sql",
    )


    # =====================================================
    # STEP 4 — Load Fact Table
    # =====================================================

    load_fact = SQLExecuteQueryOperator(
        task_id="load_fact_property_tax",
        conn_id="postgres_default",
        sql="sql/load_fact_property_tax.sql",

        # Optional: extra retries for critical fact load
        retries=5,
        retry_delay=timedelta(minutes=2),
    )


    # =====================================================
    # TASK DEPENDENCIES
    # =====================================================

    create_schema >> load_dim_property >> load_dim_time >> load_fact
