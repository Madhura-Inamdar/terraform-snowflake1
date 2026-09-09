# Resources
resource "snowflake_database" "tf_db_streamlit" {
  name         = "TF_DB_STREAMLIT"
  is_transient = false
}

resource "snowflake_warehouse" "tf_warehouse_streamlit" {
  name                      = "TF_WH_STREAMLIT"
  warehouse_type            = "STANDARD"
  warehouse_size            = "XSMALL"
  max_cluster_count         = 1
  min_cluster_count         = 1
  auto_suspend              = 60
  auto_resume               = true
  enable_query_acceleration = false
  initially_suspended       = true
}

resource "snowflake_schema" "tf_db_tf_schema_streamlit" {
  name                = "TF_SCHEMA_STREAMLIT"
  database            = snowflake_database.tf_db_streamlit.name
  with_managed_access = false
}