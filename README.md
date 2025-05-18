# Projeto: Publicação Blog com Azure Container Apps

## Objetivo
Publicar uma aplicação estática (landing page em HTML) em um container no Azure, usando:
- Docker
- Azure Container Registry (ACR)
- Azure Container Apps

---

## Estrutura de Arquivos
```
002-BlogContainerApps/
├── Blog/
│   └── html/
│       ├── index.html
│       ├── create-post.html
│       └── post-detail.html
├── dockerfile
```

---

## Dockerfile usado
```Dockerfile
# Utiliza a imagem oficial do Nginx
FROM nginx:alpine

# Copia os arquivos estáticos para o diretório padrão do Nginx
COPY Blog/html/index.html /usr/share/nginx/html/index.html
COPY Blog/html/create-post.html /usr/share/nginx/html/create-post.html
COPY Blog/html/post-detail.html /usr/share/nginx/html/post-detail.html
```

---

## Etapas

### 1. Build local da imagem Docker
```powershell
docker build -t landingpage/curso-ia:latest .
docker run -d -p 80:80 landingpage/curso-ia:latest
```

### 2. Login no Azure
```powershell
az login
az account set --subscription "Visual Studio Enterprise Subscription - MPN"
```

### 3. Criar o Resource Group
```powershell
az group create --name RG-containerappslab03 --location canadacentral
```

### 4. Criar o Azure Container Registry (ACR)
```powershell
az acr create --resource-group RG-containerappslab03 --name acrhcarvalholab02 --sku Basic
az acr login --name acrhcarvalholab02
```

### 5. Tag e push da imagem para o ACR
```powershell
docker tag landingpage/curso-ia:latest acrhcarvalholab02.azurecr.io/landingpage/curso-ia:latest
docker push acrhcarvalholab02.azurecr.io/landingpage/curso-ia:latest
```

### 6. Criar o ambiente do Container App
```powershell
az provider register -n Microsoft.OperationalInsights --wait
az containerapp env create --name env-containerappslab03 --resource-group RG-containerappslab03 --location canadacentral
```

### 7. Criar o Container App (com CPU/Memória corretos)
```powershell
az containerapp create --name curso-ia-containerapp --resource-group RG-containerappslab03 --environment env-containerappslab03 --image acrhcarvalholab02.azurecr.io/landingpage/curso-ia:latest --cpu 1.0 --memory 2.0Gi --target-port 80 --ingress external --registry-server acrhcarvalholab02.azurecr.io
```

> A primeira tentativa com `--memory 1.0Gi` falhou, pois o mínimo para `--cpu 1.0` é `--memory 2.0Gi`.

---

## Validação final

### Obter URL do app:
```powershell
az containerapp show --name curso-ia-containerapp --resource-group RG-containerappslab03 --query properties.configuration.ingress.fqdn -o tsv
```

### Testar resposta:
```powershell
curl https://curso-ia-containerapp.blacksea-02791e96.canadacentral.azurecontainerapps.io
```

---

## Resultado Final
Landing Page publicada com sucesso:
https://curso-ia-containerapp.blacksea-02791e96.canadacentral.azurecontainerapps.io
