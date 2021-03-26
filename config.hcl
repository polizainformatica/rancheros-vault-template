exit_after_auth = true
pid_file = "/${APP_PATH}/config/pidfile"
auto_auth {
  method "approle" {
    config = {
      role_id_file_path = "/${APP_PATH}/config/roleid"
      secret_id_file_path = "/${APP_PATH}/config/secretid"
      remove_secret_id_file_after_reading = "false"
    }
  }
}
template {
  source      = "/${APP_PATH}/templates/template.tpl"
  destination = "/${APP_PATH}/secrets/output.json"
}