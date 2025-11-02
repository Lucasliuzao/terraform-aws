# Grupos de segurança
# SG para instâncias web públicas 
resource "aws_security_group" "web" { 
    name        = "web-sg" 
    description = "Permitir tráfego HTTP/HTTPS e SSH" 
    vpc_id      = aws_vpc.main.id
    
ingress { 
    from_port   = 80 
    to_port     = 80 
    protocol    = "tcp" 
    cidr_blocks = ["0.0.0.0/0"] 
    description = "Permitir HTTP"
}

ingress { 
    from_port   = 443 
    to_port     = 443 
    protocol    = "tcp" 
    cidr_blocks = ["0.0.0.0/0"] 
    description = "Permitir HTTPS"
}
ingress { 
    from_port   = 22 
    to_port     = 22 
    protocol    = "tcp" 
    cidr_blocks = ["0.0.0.0/0"] 
    description = "Permitir SSH" 
}
egress { 
    from_port   = 0 
    to_port     = 0 
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"] 
    description = "Permitir todo tráfego de saída" 
}
tags = { Name = "web-sg" } 
}
# SG para banco de dados 
resource "aws_security_group" "db" { 
    name        = "db-sg" 
    description = "Permitir tráfego do banco de dados apenas das instâncias web" 
    vpc_id      = aws_vpc.main.id
ingress { 
    from_port       = 3306 
    to_port         = 3306 
    protocol        = "tcp" 
    security_groups = [aws_security_group.web.id] 
    description     = "Permitir MySQL das instâncias web"
}
egress { 
from_port   = 0 
to_port     = 0 
protocol    = "-1" 
cidr_blocks = ["0.0.0.0/0"] 
description = "Permitir todo tráfego de saída"
}
tags = { Name = "db-sg" } 
} 