// Anexa a policy AmazonSSMFullAccess ao usuário do pipeline para permitir ssm:SendCommand
// Observação: O usuário IAM deve existir (ex: pipeline-github). Se não existir, o apply falhará.

resource "aws_iam_user_policy_attachment" "pipeline_ssm" {
  user       = var.pipeline_user
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

// Alternativa segura: conceder apenas as ações SSM necessárias em recursos específicos via policy customizada.
// Exemplo (não aplicado automaticamente): criar uma policy com ssm:SendCommand e anexar ao usuário.
