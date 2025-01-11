# Utiliser une image NGINX légère
FROM nginx:stable-alpine

# Copier les fichiers construits dans le répertoire NGINX par défaut
COPY dist/ /usr/share/nginx/html/todo-ui/

# Expose le port 80 (hérité de l'image NGINX)
EXPOSE 80
