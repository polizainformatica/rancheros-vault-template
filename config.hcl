exit_after_auth = true
pid_file = "/home/rancher/pidfile"
auto_auth {
  method "approle" {
    config = {
      role_id_file_path = "/home/rancher/roleid"
      secret_id_file_path = "/home/rancher/secretid"
      remove_secret_id_file_after_reading = "false"
    }
  }
}
template {
  source      = "/home/rancher/template.in"
  destination = "/home/rancher/secret.out"
}