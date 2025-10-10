Instruções mínimas para build e push da imagem da API e deploy no App Runner

Requisitos:
- AWS CLI configurado (perfil com permissões para ECR, IAM e App Runner)
- Docker instalado e em execução
- Powershell (Windows)

1) Build da imagem (na raiz da API):

PS> cd ..\fonte\api
PS> docker build -t achados-api:latest .

2) Criar repositório ECR (se ainda não existir)

PS> aws ecr create-repository --repository-name achados-e-perdidos-api --region us-east-1

3) Fazer login no ECR e enviar a imagem

PS> $account = (aws sts get-caller-identity --query Account --output text)
PS> $region = "us-east-1"
PS> $repo = "${account}.dkr.ecr.${region}.amazonaws.com/${env:BASE_NAME:-achados-e-perdidos}-api"
PS> aws ecr get-login-password --region $region | docker login --username AWS --password-stdin ${account}.dkr.ecr.${region}.amazonaws.com
PS> docker tag achados-api:latest ${repo}:latest
PS> docker push ${repo}:latest

Observação: se o repositório foi criado pelo Terraform, o nome será `${var.base_name}-api`. Ajuste a variável BASE_NAME acima conforme seu ambiente.

4) Forçar novo deploy no App Runner

Você pode forçar um novo deploy reenviando a mesma tag `latest` (push) — App Runner fará o deploy automático se `auto_deployments_enabled = true`.

Alternativamente, iniciar deploy via AWS CLI:

PS> aws apprunner start-deployment --service-arn <ARN_DO_SERVIÇO> --region us-east-1

Para recuperar o ARN do serviço:

PS> aws apprunner list-services --region us-east-1 --query "ServiceSummaryList[?starts_with(ServiceName, 'achados')].{Name:ServiceName,ARN:ServiceArn}"

Fim.
