resource "aws_key_pair" "citadel-key" {
    key_name = "citadel"
    public_key = file("/root/terraform-challenges/project-citadel/.ssh/ec2-connect-key.pub")
}

resource "aws_instance" "citadel" {
    depends_on = [aws_key_pair.citadel-key]
    ami = var.ami
    instance_type = var.instance_type
    key_name = aws_key_pair.citadel-key.key_name
    user_data = file("install-nginx.sh")
    tags = {
        Name = "citadel"
    }
}

resource "aws_eip_association" "eip_assoc" {
    depends_on = [aws_eip.eip, aws_instance.citadel]
    instance_id   = aws_instance.citadel.id
    allocation_id = aws_eip.eip.id
}

resource "aws_eip" "eip" {
    vpc = true
    depends_on = [aws_instance.citadel]
    instance = aws_instance.citadel.id
    provisioner "local-exec" {
        command = "echo ${self.public_dns} > /root/citadel_public_dns.txt"
    }
}