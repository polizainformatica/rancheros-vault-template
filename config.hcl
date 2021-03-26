exit_after_auth = true
pid_file = "/vault-template/config/pidfile"
auto_auth {
  method "approle" {
    config = {
      role_id_file_path = "/vault-template/config/roleid"
      secret_id_file_path = "/vault-template/config/secretid"
      remove_secret_id_file_after_reading = "false"
    }
  }
}
template {
  source      = "/vault-template/templates/template.tpl"
  destination = "/vault-template/secrets/output.json"
}