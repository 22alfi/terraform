resource "null_resource" "demo_local" {
  provisioner "local-exec" {
    command = "echo Hello from local-exec!"
  }
}
