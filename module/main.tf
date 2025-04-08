resource "aws_instance" "dev" {
  instance_type = var.instance_type #inserting value from variables
  key_name      = var.key_name
  ami           = var.ami

  tags = {
    Name = "my-server"
  }

}
