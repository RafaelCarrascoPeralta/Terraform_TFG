terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "aws_vpc_balanceo_1" {
  cidr_block = "100.100.0.0/16"
  tags = {
    Name = "Vpc balanceo principal"
  }
}

# Subnets
resource "aws_subnet" "Servidor_Web_A" {
  vpc_id     = aws_vpc.aws_vpc_balanceo_1.id
  cidr_block = "100.100.11.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Subred Servidor_Web_A"
  }
}

resource "aws_subnet" "Servidor_Web_B" {
  vpc_id     = aws_vpc.aws_vpc_balanceo_1.id
  cidr_block = "100.100.21.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "Subred Servidor_Web_B"
  }
}

resource "aws_subnet" "Servidor_SQL" {
  vpc_id     = aws_vpc.aws_vpc_balanceo_1.id
  cidr_block = "100.100.31.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "Subred Servidor_SQL"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw_1" {
  vpc_id = aws_vpc.aws_vpc_balanceo_1.id
  tags = {
    Name = "Gateway VPC principal"
  }
}

# Elastic IPs
resource "aws_eip" "elastica_1" {}
resource "aws_eip" "elastica_2" {}
resource "aws_eip" "elastica_3" {}


# Route Tables
resource "aws_route_table" "tab_ruteo_http_1" {
  vpc_id = aws_vpc.aws_vpc_balanceo_1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_1.id
  }

  tags = {
    Name = "Tabla ruteo Servidor_Web_A"
  }
}

resource "aws_route_table" "tab_ruteo_http_2" {
  vpc_id = aws_vpc.aws_vpc_balanceo_1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_1.id
  }

  tags = {
    Name = "Tabla ruteo Servidor_Web_B"
  }
}

resource "aws_route_table" "tab_ruteo_http_3" {
  vpc_id = aws_vpc.aws_vpc_balanceo_1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_1.id
  }

  tags = {
    Name = "Tabla ruteo Servidor_SQL"
  }
}

# Route Table Associations
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.Servidor_Web_A.id
  route_table_id = aws_route_table.tab_ruteo_http_1.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.Servidor_Web_B.id
  route_table_id = aws_route_table.tab_ruteo_http_2.id
}

resource "aws_route_table_association" "e" {
  subnet_id      = aws_subnet.Servidor_SQL.id
  route_table_id = aws_route_table.tab_ruteo_http_3.id
}

# Security Groups
resource "aws_security_group" "GS_Servidor_Web_A" {
  name        = "GS_Servidor_Web_A"
  description = "Grupo de seguridad para permitir el acceso al puerto 80, Servidor_Web_A"
  vpc_id      = aws_vpc.aws_vpc_balanceo_1.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow ICMP (ping) traffic from within the VPC
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Grupo seguridad Servidor_Web_A"
  }
}

# Par de claves
resource "aws_key_pair" "administrador" {
  key_name   = "clave_administrador"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDprflZ78PAFDay9ef+/BQSoQsSVQjle5NdtBBmh2ev7EEr4/QMfjny9Mo857H7VRKbwS7nyY6GowdIogRnrl2J67N5DKdnzxxs4tOCxo3Ae8W5mcAXo+kS7QwxP1lM5I+0ZsSyfHWdsHilmen2J5u4Cswij5QbKXtXPWPuf1Mze410TB/RmKPX/ZcpRrx+4w+ds1CoSD8hRSd2RD5I7O+RXZnFObsnc/Egs2DZ4mE2t8q1TWHcgmN8TGB8ZRuuwCyP9G1oHyN0Z2bAAICBO4pAWs5M+Uy/nl9nGQZoElTCIHYOjC25FzaIqo2uYjBOwF7nC7OTJjvIo+x3L5CDv/TvUNAXBbuuIxsti+3tJonAfOsN8193wozCfLiUyVE+29XD5BX3OEvYdUhhn1Vys1iRzn/0SpmQP9jh1tZHCf+bkjtnKJOPg8H2VtG9WFR7TC32gZY0j2GTM8UPBpvi9siBYQZCgiRfh4mnTsM/rvloLKQzDacGUSWfekdEI+DYq6E= carrascop333@gmail.com"
}

  # Instancias
  resource "aws_instance" "Servidor_Web_A" {
    ami           = "ami-058bd2d568351da34"
    instance_type = "t2.medium"
    key_name = "clave_administrador"
    subnet_id = aws_subnet.Servidor_Web_A.id
    associate_public_ip_address = true
    private_ip = "100.100.11.10"
    vpc_security_group_ids = [aws_security_group.GS_Servidor_Web_A.id]
    tags = {
      Name = "Servidor_Web_A"
    }

    connection {
      type        = "ssh"
      user        = "admin" 
      private_key = file("C:\\Users\\rafac\\.ssh\\id_rsa")
      host        = self.public_ip
    }

    provisioner "file" {
      source      = "C:\\terraform\\TFG\\install_docker.sh"
      destination = "/home/admin/install_docker.sh"
    }

    provisioner "file" {
      source      = "C:\\terraform\\TFG\\install_microk8s.sh"
      destination = "/home/admin/install_microk8s.sh"
    }


    provisioner "file" {
      source      = "C:\\terraform\\TFG\\containers_web.sh"
      destination = "/home/admin/containers_web.sh"
    }

    provisioner "file" {
      source      = "C:\\terraform\\TFG\\tls.crt"
      destination = "/home/admin/tls.crt"
    }


    provisioner "file" {
      source      = "C:\\terraform\\TFG\\granadabaloncestofab.work.gd.key"
      destination = "/home/admin/granadabaloncestofab.work.gd.key"
    }

    provisioner "remote-exec" {
      inline = [
        "sudo apt-get update -y",
        "sudo apt-get install bash -y",
        "sudo apt-get install dos2unix",
	"sudo apt install mariadb-server -y",
	"sudo systemctl start mariadb",
	"sudo systemctl enable mariadb",
        "sudo dos2unix /home/admin/install_docker.sh",
        "sudo dos2unix /home/admin/install_microk8s.sh",
        "sudo dos2unix /home/admin/containers_web.sh",
        "sudo dos2unix /home/admin/tls.crt",
        "sudo dos2unix /home/admin/granadabaloncestofab.work.gd.key",
        "ls -l /home/admin/install_docker.sh",
        "ls -l /home/admin/install_microk8s.sh",
        "ls -l /home/admin/containers_web.sh",
        "file /home/admin/install_docker.sh",
        "file /home/admin/install_microk8s.sh",
        "file /home/admin/containers_web.sh",
        "sudo chmod +x /home/admin/install_docker.sh",
        "sudo chmod +x /home/admin/install_microk8s.sh",
        "sudo chmod +x /home/admin/containers_web.sh",
        "sudo chmod +x /home/admin/tls.crt",
        "sudo chmod +x /home/admin/granadabaloncestofab.work.gd.key",
      ]
    }
  }

  resource "aws_instance" "Servidor_Web_B" {
    ami           = "ami-058bd2d568351da34"
    instance_type = "t2.medium"
    key_name = "clave_administrador"
    subnet_id = aws_subnet.Servidor_Web_B.id
    associate_public_ip_address = true
    private_ip = "100.100.21.10"
    vpc_security_group_ids = [aws_security_group.GS_Servidor_Web_A.id]
    tags = {
      Name = "Servidor_Web_B"
    }

    connection {
      type        = "ssh"
      user        = "admin" 
      private_key = file("C:\\Users\\rafac\\.ssh\\id_rsa")
      host        = self.public_ip
    }

    provisioner "file" {
      source      = "C:\\terraform\\TFG\\install_microk8s.sh"
      destination = "/home/admin/install_microk8s.sh"
    }


    provisioner "file" {
      source      = "C:\\terraform\\TFG\\containers_web.sh"
      destination = "/home/admin/containers_web.sh"
    }

    provisioner "file" {
      source      = "C:\\terraform\\TFG\\tls.crt"
      destination = "/home/admin/tls.crt"
    }


    provisioner "file" {
      source      = "C:\\terraform\\TFG\\granadabaloncestofab.work.gd.key"
      destination = "/home/admin/granadabaloncestofab.work.gd.key"
    }

    provisioner "remote-exec" {
      inline = [
        "sudo apt-get update -y",
        "sudo apt-get install bash -y",
        "sudo apt-get install dos2unix",
	"sudo apt install mariadb-server -y",
	"sudo systemctl start mariadb",
	"sudo systemctl enable mariadb",
        "sudo dos2unix /home/admin/install_microk8s.sh",
        "sudo dos2unix /home/admin/containers_web.sh",
        "sudo dos2unix /home/admin/tls.crt",
        "sudo dos2unix /home/admin/granadabaloncestofab.work.gd.key",
        "ls -l /home/admin/install_microk8s.sh",
        "ls -l /home/admin/containers_web.sh",
        "file /home/admin/install_microk8s.sh",
        "file /home/admin/containers_web.sh",
        "sudo chmod +x /home/admin/install_microk8s.sh",
        "sudo chmod +x /home/admin/containers_web.sh",
        "sudo chmod +x /home/admin/tls.crt",
        "sudo chmod +x /home/admin/granadabaloncestofab.work.gd.key",
      ]
    }
  }


  resource "aws_instance" "Servidor_SQL" {
    ami           = "ami-058bd2d568351da34"
    instance_type = "t2.medium"
    key_name = "clave_administrador"
    subnet_id = aws_subnet.Servidor_SQL.id
    associate_public_ip_address = true
    private_ip = "100.100.31.10"
    vpc_security_group_ids = [aws_security_group.GS_Servidor_Web_A.id]
    tags = {
      Name = "Servidor_SQL"
    }

    connection {
      type        = "ssh"
      user        = "admin" 
      private_key = file("C:\\Users\\rafac\\.ssh\\id_rsa")
      host        = self.public_ip
    }


    provisioner "file" {
      source      = "C:\\terraform\\TFG\\init-db.sql"
      destination = "/home/admin/init-db.sql"
    }

    provisioner "file" {
      source      = "C:\\terraform\\TFG\\init-db2.sql"
      destination = "/home/admin/init-db2.sql"
    }


    provisioner "remote-exec" {
      inline = [
        "sudo apt-get update -y",
        "sudo apt-get install bash -y",
        "sudo apt-get install dos2unix",
	"sudo apt install mariadb-server mariadb-client -y",
	"sudo systemctl start mariadb",
	"sudo systemctl enable mariadb",
        "sudo dos2unix /home/admin/init-db.sql",
        "sudo dos2unix /home/admin/init-db2.sql",
        "sudo chmod +x /home/admin/init-db.sql",
        "sudo chmod +x /home/admin/init-db2.sql",
      ]
    }
  }