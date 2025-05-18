docker build -t landingpage/curso-ia:latest .

docker run -d -p 80:80 landingpage/curso-ia:latest

az login

az group create --name RG-containerappslab03 --location canadacentral

# Create Container Registry
az acr create --resource-group RG-containerappslab03 --name acrhcarvalholab02 --sku Basic

#login to ACR
az acr login --name acrhcarvalholab02

# tag the image
docker tag landingpage/curso-ia:latest acrhcarvalholab02.azurecr.io/landingpage/curso-ia:latest

# Push image to ACR
docker push acrhcarvalholab02.azurecr.io/landingpage/curso-ia:latest 

#container ID acrhcarvalholab02.azurecr.io/landingpage/curso-ia:latest
# user = acrhcarvalholab02
# password = P########################################################



# Create environment
az containerapp env create --name env-containerappslab03 --resource-group RG-containerappslab03 --location canadacentral


# Create container app
az containerapp create --name curso-ia-containerapp --resource-group RG-containerappslab03 --environment env-containerappslab03 --image acrhcarvalholab02.azurecr.io/landingpage/curso-ia:latest --cpu 1 --memory 1.0Gi --target-port 80 --ingress external --registry-server-url acrhcarvalholab02.azurecr.io --registry-server-username acrhcarvalholab02 --registry-server-password P