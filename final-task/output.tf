output "master_public_ip" {
  value = aws_instance.master.public_ip
}

output "worker_public_ip" {
  value = aws_instance.worker.public_ip
}

output "private_key_path" {
  value = "${path.module}/k8s-key.pem"
}

output "kubectl_command" {
  value = "scp -i ${path.module}/k8s-key.pem ubuntu@${aws_instance.master.public_ip}:/home/ubuntu/.kube/config ./config && export KUBECONFIG=./config"
}
