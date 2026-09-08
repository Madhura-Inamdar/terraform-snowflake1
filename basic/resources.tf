# Resources
resource "snowflake_database" "tf_db1" {
  name         = "TF_DB"
  is_transient = false
}

resource "snowflake_warehouse" "tf_warehouse1" {
  name                      = "TF_WH"
  warehouse_type            = "STANDARD"
  warehouse_size            = "XSMALL"
  max_cluster_count         = 1
  min_cluster_count         = 1
  auto_suspend              = 60
  auto_resume               = true
  enable_query_acceleration = false
  initially_suspended       = true
}

resource "snowflake_schema" "tf_db_tf_schema" {
  name                = "TF_DEMO_SC"
  database            = snowflake_database.tf_db1.name
  with_managed_access = false
}