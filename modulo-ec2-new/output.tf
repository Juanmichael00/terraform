output "instance_id" {
  value = module.ec2_instance.id
}

output "public_ip" {
  value = aws_eip.eip_instance-tf.public_ip
}

output "public_dns" {
  value = module.ec2_instance.public_dns
}
