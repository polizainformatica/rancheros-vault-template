exit_after_auth = true
pid_file = "/vault/config/pidfile"
auto_auth {
  method "approle" {
    config = {
      role_id_file_path = "/vault/config/roleid"
      secret_id_file_path = "/vault/config/secretid"
      remove_secret_id_file_after_reading = "false"
    }
  }
}
template {
  source      = "/vault/templates/template.tpl"
  destination = "/vault/secrets/output.json"
}