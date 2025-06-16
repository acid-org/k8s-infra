resource "null_resource" "port_forward" {
  provisioner "local-exec" {
    command     = "nohup kubectl -n cattle-system port-forward svc/rancher 8443:443 >/tmp/rancher-port-forward.log 2>&1 & echo $! > /tmp/rancher-port-forward.pid"
    interpreter = ["bash", "-c"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "if [ -f /tmp/rancher-port-forward.pid ]; then kill $(cat /tmp/rancher-port-forward.pid); rm /tmp/rancher-port-forward.pid; fi"
    interpreter = ["bash", "-c"]
  }
}
