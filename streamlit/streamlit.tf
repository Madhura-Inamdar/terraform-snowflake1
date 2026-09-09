resource "snowflake_stage_internal" "streamlit_stage_tf" {
  name     = "streamlit_stage_tf"
  database = snowflake_database.tf_db_streamlit.name
  schema   = snowflake_schema.tf_db_tf_schema_streamlit.name
}

resource "null_resource" "upload_app_files" {
  triggers = {
    app_hash = md5(file("${path.module}/app/streamlit_main.py"))
    env_hash = md5(file("${path.module}/app/environment.yml"))
    stage_id = snowflake_stage_internal.streamlit_stage_tf.id
  }

  provisioner "local-exec" {
    command = "snow stage copy ${path.module}/app @${snowflake_stage_internal.streamlit_stage_tf.fully_qualified_name} --overwrite --temporary-connection"

    environment = {
      SNOWFLAKE_ACCOUNT          = "${local.organization_name}-${local.account_name}"
      SNOWFLAKE_USER             = "TERRAFORM_SVC"
      SNOWFLAKE_ROLE             = "SYSADMIN"
      SNOWFLAKE_AUTHENTICATOR    = "SNOWFLAKE_JWT"
      SNOWFLAKE_PRIVATE_KEY_PATH = local.private_key_path
    }
  }
}

resource "snowflake_streamlit" "streamlit_app_tf" {
  database        = snowflake_database.tf_db_streamlit.name
  schema          = snowflake_schema.tf_db_tf_schema_streamlit.name
  name            = "streamlit_app_tf"
  stage           = snowflake_stage_internal.streamlit_stage_tf.fully_qualified_name
  query_warehouse = snowflake_warehouse.tf_warehouse_streamlit.fully_qualified_name
  main_file       = "streamlit_main.py"
}