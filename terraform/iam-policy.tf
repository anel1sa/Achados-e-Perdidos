# IAM Policy para permitir criação de repositório ECR
resource "aws_iam_policy" "ecr_policy" {
  name        = "ECRRepositoryPolicy"
  description = "Política que permite criar e gerenciar repositórios ECR"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:CreateRepository",
          "ecr:DescribeRepositories",
          "ecr:TagResource",
          "ecr:UntagResource",
          "ecr:GetRepositoryPolicy",
          "ecr:SetRepositoryPolicy",
          "ecr:DeleteRepositoryPolicy",
          "ecr:DeleteRepository",
          "ecr:PutImage",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer"
        ],
        Resource = "arn:aws:ecr:us-east-1:*:repository/${var.base_name}-api"
      }
    ]
  })
}

# Anexar a política ao usuário "pipeline-github"
resource "aws_iam_user_policy_attachment" "pipeline_ecr_access" {
  user       = "pipeline-github"
  policy_arn = aws_iam_policy.ecr_policy.arn
}
