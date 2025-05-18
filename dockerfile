# Utiliza a imagem oficial do Nginx
FROM nginx:alpine

# Copia os arquivos estáticos para o diretório padrão do Nginx
COPY Blog/html/index.html /usr/share/nginx/html/index.html
COPY Blog/html/create-post.html /usr/share/nginx/html/create-post.html
COPY Blog/html/post-detail.html /usr/share/nginx/html/post-detail.html
