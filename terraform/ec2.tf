// EC2 para a API Achados-e-Perdidos

// Mantemos o repositório ECR existente para armazenar a imagem Docker
resource "aws_ecr_repository" "achados_api" {
  name = "${var.base_name != "" ? var.base_name : "achados-e-perdidos"}-api"
  tags = var.tags
}

// Security Group para a instância EC2
resource "aws_security_group" "ec2_api" {
  name        = "${var.base_name != "" ? var.base_name : "achados-e-perdidos"}-api-sg-${var.env}"
  description = "Security Group para API Achados e Perdidos"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Application port"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  // Em produção, restringir para IPs específicos
    description = "SSH"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = var.tags
}

// IAM Role para o EC2 acessar o ECR
resource "aws_iam_role" "ec2_role" {
  name = "${var.base_name != "" ? var.base_name : "achados-e-perdidos"}-ec2-api-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

// Política para acessar o ECR
resource "aws_iam_policy" "ecr_access" {
  name        = "${var.base_name != "" ? var.base_name : "achados-e-perdidos"}-ecr-access-api-${var.env}"
  description = "Permite EC2 acessar o ECR"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.base_name}-${var.env}-backend",
          "arn:aws:s3:::${var.base_name}-${var.env}-backend/*"
        ]
      }
    ]
  })
}

// Anexar políticas à role
resource "aws_iam_role_policy_attachment" "ec2_ecr" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ecr_access.arn
}

// Adicionar política SSM para permitir gerenciamento remoto via SSM
resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

// Profile de instância para EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.base_name != "" ? var.base_name : "achados-e-perdidos"}-ec2-api-profile-${var.env}"
  role = aws_iam_role.ec2_role.name
}

// Obtém a AMI mais recente do Amazon Linux 2
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-arm64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "api_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t4g.micro" # compatível com Free Tier em muitas regiões
  vpc_security_group_ids = [aws_security_group.ec2_api.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
    #!/bin/bash
    set -e
    
    # Instalar Docker
    amazon-linux-extras install docker -y
    systemctl start docker
    systemctl enable docker

    # Instalar AWS CLI para interagir com ECR (versão ARM64)
    curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    ./aws/install
    
    # Login no ECR
    aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${aws_ecr_repository.achados_api.repository_url}

    # Criar script de inicialização
    cat > /home/ec2-user/start-app.sh <<EOL
    #!/bin/bash
    
    # Verificar por atualizações e reiniciar o container se necessário
    aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${aws_ecr_repository.achados_api.repository_url}
    docker pull ${aws_ecr_repository.achados_api.repository_url}:latest
    docker stop api-container || true
    docker rm api-container || true
    docker run -d --name api-container \\
      -p 8080:8080 \\
      -e SPRING_DATASOURCE_URL="" \\
      -e SPRING_DATASOURCE_USERNAME="" \\
      -e SPRING_DATASOURCE_PASSWORD="" \\
      -e MONGODB_URI="" \\
      -e AWS_REGION=${var.region} \\
      -e STORAGE_BUCKET="${var.base_name}-${var.env}-backend" \\
      ${aws_ecr_repository.achados_api.repository_url}:latest
    EOL

    chmod +x /home/ec2-user/start-app.sh
    
    # Executar na inicialização
    echo "*/30 * * * * /home/ec2-user/start-app.sh" | crontab -

    # Iniciar aplicação
    /home/ec2-user/start-app.sh
  EOF

  tags = merge(
    var.tags,
    {
      Name = "achados-api-${var.env}"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

// Elastic IP para garantir endereço fixo
resource "aws_eip" "api_eip" {
  instance = aws_instance.api_server.id
  tags = var.tags
}

output "ec2_public_ip" {
  description = "IP público da instância EC2"
  value       = aws_eip.api_eip.public_ip
}

output "ec2_public_dns" {
  description = "DNS público da instância EC2"
  value       = aws_instance.api_server.public_dns
}

output "api_url" {
  description = "URL da API"
  value       = "http://${aws_eip.api_eip.public_ip}:8080"
}
