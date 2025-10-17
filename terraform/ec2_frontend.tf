// EC2 para hospedar o front-end (Flutter Web)

// Security Group para a instância EC2 do front-end
resource "aws_security_group" "ec2_frontend" {
  name        = "${var.base_name != "" ? var.base_name : "achados-frontend"}-frontend-sg-${var.env}"
  description = "Security Group para Frontend (nginx)"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // Em produção, restrinja a IPs específicos
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

// IAM Role para EC2 acessar S3 e SSM (sync do build e gerenciamento)
resource "aws_iam_role" "ec2_frontend_role" {
  name = "${var.base_name != "" ? var.base_name : "achados-frontend"}-ec2-frontend-${var.env}"

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

// Política para permitir leitura do bucket S3 que contém o build web
resource "aws_iam_policy" "frontend_s3_read" {
  name        = "${var.base_name != "" ? var.base_name : "achados-frontend"}-frontend-s3-read-${var.env}"
  description = "Permite EC2 sincronizar os arquivos do frontend a partir do S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:GetObjectVersion"
        ]
        Resource = [
          "arn:aws:s3:::${var.base_name}-${var.env}-frontend",
          "arn:aws:s3:::${var.base_name}-${var.env}-frontend/*"
        ]
      }
    ]
  })
}

// Anexar políticas à role
resource "aws_iam_role_policy_attachment" "ec2_frontend_s3" {
  role       = aws_iam_role.ec2_frontend_role.name
  policy_arn = aws_iam_policy.frontend_s3_read.arn
}

resource "aws_iam_role_policy_attachment" "ec2_frontend_ssm" {
  role       = aws_iam_role.ec2_frontend_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

// Instance profile
resource "aws_iam_instance_profile" "ec2_frontend_profile" {
  name = "${var.base_name != "" ? var.base_name : "achados-frontend"}-ec2-frontend-profile-${var.env}"
  role = aws_iam_role.ec2_frontend_role.name
}

// Instância EC2 que serve o build do Flutter via nginx
resource "aws_instance" "frontend_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t4g.micro"
  vpc_security_group_ids = [aws_security_group.ec2_frontend.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_frontend_profile.name

  user_data = <<-EOF
    #!/bin/bash
    set -e

    # Atualizar e instalar utilitários
    yum update -y
    yum install -y unzip || true

    # Instalar nginx (Amazon Linux 2)
    amazon-linux-extras enable nginx1
    yum clean metadata
    yum install -y nginx
    systemctl enable nginx
    systemctl start nginx

    # Instalar AWS CLI (ARM64)
    curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    ./aws/install || true

    # Script de sincronização do frontend a partir do S3
    cat > /home/ec2-user/sync-frontend.sh <<EOL
    #!/bin/bash
    set -e
    aws s3 sync s3://${var.base_name}-${var.env}-frontend /usr/share/nginx/html --acl public-read --delete --region ${var.region}
    chown -R nginx:nginx /usr/share/nginx/html
    systemctl reload nginx || true
    EOL

    chmod +x /home/ec2-user/sync-frontend.sh

    # Agendar sincronização a cada 15 minutos
    (crontab -l 2>/dev/null; echo "*/15 * * * * /home/ec2-user/sync-frontend.sh") | crontab -

    # Sincronização inicial
    /home/ec2-user/sync-frontend.sh
  EOF

  tags = merge(
    var.tags,
    {
      Name = "${var.base_name != "" ? var.base_name : "achados-frontend"}-ec2-${var.env}"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

// Elastic IP para o frontend
resource "aws_eip" "frontend_eip" {
  instance = aws_instance.frontend_server.id
  tags     = var.tags
}

output "frontend_public_ip" {
  description = "IP público da instância EC2 do frontend"
  value       = aws_eip.frontend_eip.public_ip
}

output "frontend_url" {
  description = "URL do frontend (HTTP)"
  value       = "http://${aws_eip.frontend_eip.public_ip}"
}

// Nota: este recurso assume que existe um bucket S3 chamado ${var.base_name}-${var.env}-frontend contendo os arquivos gerados pelo `flutter build web`.
