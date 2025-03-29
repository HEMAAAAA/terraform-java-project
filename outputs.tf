output "jenkins_server" {
  value = module.jenkins.public_ip
}

output "nexus_server" {
  value = module.nexus.public_ip
}

