from airflow import DAG
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from datetime import datetime, timedelta


# ==============================
# RETRY CONFIGURATION
# ==============================

default_args = {
    "owner": "data_engineer",
    "retries": 3,
    "retry_delay": timedelta(minutes=5),
    "retry_exponential_backoff": True,
    "max_retry_delay": timedelta(minutes=30),
}


# ==============================
# DAG DEFINITION
# ==============================

with DAG(
    dag_id="property_tax_pipeline_advanced",
    start_date=datetime(2024, 1, 1),
    schedule_interval=None,
    catchup=False,
    default_args=default_args,
    description="Property Tax Analytics Pipeline with SCD Type-2",
) as dag:

    create_schema = SQLExecuteQueryOperator(
        task_id="create_schema",
        conn_id="postgres_default",
        sql="sql/ddl_analytics.sql",
    )

    load_dim_property = SQLExecuteQueryOperator(
        task_id="load_dim_property_scd2",
        conn_id="postgres_default",
        sql="sql/load_dim_property_scd2.sql",
    )

    load_dim_time = SQLExecuteQueryOperator(
        task_id="load_dim_time",
        conn_id="postgres_default",
        sql="sql/load_dim_time.sql",
    )

    load_fact = SQLExecuteQueryOperator(
        task_id="load_fact_incremental",
        conn_id="postgres_default",
        sql="sql/load_fact_incremental.sql",
        retries=5,
        retry_delay=timedelta(minutes=2),
    )

    create_schema >> load_dim_property >> load_dim_time >> load_fact
