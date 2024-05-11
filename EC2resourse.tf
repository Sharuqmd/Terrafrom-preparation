resource "aws_instance" "testec2" {
  ami                    = "ami-05e00961530ae1b55"
  instance_type          = "t2.micro"
  key_name               = "terraformkey"
  subnet_id              = aws_subnet.publicsubnet.id
  vpc_security_group_ids = [ aws_security_group.testvpc_aws_security_group.id ]
  user_data              = <<-EOF
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

