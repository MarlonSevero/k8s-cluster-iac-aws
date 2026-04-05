# Projeto: Kubernetes na AWS com Terraform, Balanceamento Nginx, Java App & Headlamp

Este repositório provê infraestrutura e automação para provisionamento de um cluster Kubernetes na AWS, utilizando **Terraform** para orquestrar recursos, **Ansible** para configuração dos nós, e pipelines CI/CD para entrega contínua de aplicações (Java) com gerenciamento via Headlamp.

## Visão Geral

- **Provisionamento Infraestrutura**: Utiliza Terraform para criar 3 instâncias EC2 (1 master/control-plane + 2 workers).
- **Cluster Kubernetes**: Configurado com Ansible.
- **Aplicação Java**: Será implementada nos workers, utilizando o mesmo projeto em https://github.com/MarlonSevero/Pipeline-CI-CD-With-ECS.
- **Balanceador de Carga**: Nginx atuará roteando para os pods da aplicação.
- **Gerenciamento Visual**: Deploy do Headlamp para observabilidade e administração dos containers.
- **Pipeline CI/CD**: GitHub Actions automatiza a atualização da aplicação via tags de versão no container registry.
- **Segurança e Acesso**: SSH descomplicado via Ansible, grupos de segurança definidos no Terraform.

---

## Estrutura do Projeto

```
.
├── ansible/
│   ├── inventory               # Inventário dos hosts (control-plane, workers)
│   ├── roles/
│   │   ├── docker/             # Scripts configuração Docker/containerd
│   │   ├── kubernetes/         # Scripts instalação/configuração Kubernetes
│   │   └── nginx/              # Setup de balanceador nginx
├── terraform/
│   └── ec2.tf                  # Script para provisionamento das EC2 na AWS
├── .github/
│   └── workflows/              # Pipeline do GitHub Actions para CI/CD
├── README.md
```

## Passos de Deploy

### 1. Provisionamento da Infraestrutura

1. Configure suas credenciais AWS (variáveis de ambiente ou profile `~/.aws/credentials`).
2. Edite os parâmetros necessários em `terraform/ec2.tf` (AMIs válidas, nomes de subnets/SG etc).
3. Execute:

   ```bash
   cd terraform
   terraform init
   terraform apply
   ```

Isso criará 1 nó control-plane (`k8smaster`) e 2 workers (`k8sworker1`, `k8sworker2`).

### 2. Configuração do Cluster Kubernetes

Após o provisionamento:

```bash
cd ansible
ansible-playbook -i inventory roles/docker/docker.yml
ansible-playbook -i inventory roles/kubernetes/k8s.yml
ansible-playbook -i inventory roles/nginx/nginx.yml
```

- Instala e configura Docker/containerd, inicializa o cluster, aplica rede, e instala nginx.

### 3. Deploy da Aplicação Java (Em desenvolvimento)

- Utilize os manifests do projeto [Pipeline-CI-CD-With-ECS](https://github.com/MarlonSevero/Pipeline-CI-CD-With-ECS) como base.
- O deployment pode ser aplicado diretamente com:

   ```bash
   kubectl apply -f k8s/app-deployment.yaml
   kubectl apply -f k8s/service.yaml
   ```

- Ajuste as imagens/tag conforme pipeline. (Em desenvolvimento)

### 4. Headlamp para Gestão Kubernetes

Instale rapidamente com:

```bash
kubectl apply -f https://raw.githubusercontent.com/kinvolk/headlamp/v0.22.0/deploy/headlamp.yaml
```
Acesse com port-forward ou serviço LoadBalancer conforme sua configuração dos manifests.

---

## Pipeline CI/CD (Em desenvolvimento)

- **Automação via GitHub Actions**: O workflow observa o branch principal/merges ou tags de release.
- **Build & Push Docker Image**: Nova imagem Java será buildada e enviada ao container registry escolhido (ex: ECR, DockerHub).
- **Atualização de imagem no cluster**: Workflow pode rodar um `kubectl set image ...` ou atualizar o manifest com nova tag + aplicar.
- **Nota**: Configure os secrets (AWS, DockerHub, etc.) nos GitHub Actions secrets.

**Exemplo de etapas sugeridas no workflow:**
- Build e push (docker/build-push-action)
- Atualizar o manifest (k8s) de deployment (yq, sed ou kubectl set image)
- Fazer rollout `kubectl apply` ou `kubectl rollout restart deployment`

**Incrementos para pipeline perfeita:**
- Testes automatizados após build da app antes do deploy.
- Health-check pós-deploy com rollback automático (Ex: `kubectl rollout status`).
- Notificações (Slack/Teams/email).
- Versionamento de manifest e lock de deployment.
- Monitoramento integrado (Prometheus/Grafana).

---

## Notas Finais

- Certifique-se de destruir os recursos no final usando `terraform destroy` para evitar cobranças AWS.
- Customize as AMIs, grupos de segurança e usuários conforme necessidade.
- Siga as melhores práticas de segurança/registros de secrets em ambiente seguro.

**Dúvidas, contribuições? Fique à vontade para me chamar no linkdin!**