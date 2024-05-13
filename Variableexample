
resource "aws_instance" "testec2" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = "terraformkey"
  vpc_security_group_ids = [ aws_security_group.testvpc_aws_security_group.id ]
  count = var.count_instance
  user_data = <<-EOF
  #!/bin/bash

  # Update package lists
  sudo apt update

  # Install httpd package
  sudo apt install -y apache2

  # Start the httpd service
  sudo systemctl start apache2

  # Enable httpd to start on boot
  sudo systemctl enable apache2

  echo "httpd installation complete!"
  EOF
}
