# Instâncias EC2
# Chave SSH para acesso às instâncias 
resource "aws_key_pair" "deployer" { 
    key_name   = "deployer-key" 
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 exemplo@exemplo.com" 
}

# Instância EC2 para web 
resource "aws_instance" "web" { 
    ami                    = "ami-0c55b159cbfafe1f0" 
    instance_type          = "t2.micro" 
    key_name               = aws_key_pair.deployer.key_name 
    vpc_security_group_ids = [aws_security_group.web.id] 
    subnet_id              = aws_subnet.public_a.id

    user_data = <<-EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Olá do Terraform!</h1>" > /var/www/html/index.html
EOF

    tags = { 
        Name = "web-server" 
    }
}

# Endereço IP elástico para instância web 
resource "aws_eip" "web" { 
    instance = aws_instance.web.id
    domain   = "vpc"
    
    tags = { 
        Name = "web-eip" 
    }
}