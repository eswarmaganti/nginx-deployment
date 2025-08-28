FROM nginx:latest

# Info
LABEL maintainer="Eswar Krishna Maganti"
LABEL email="maganti.ek@gmail.com"


# Create the required dirs
RUN mkdir -p /usr/share/nginx/html /etc/nginx  /var/cache/nginx /var/run 

# update the ownership to nginx user
RUN chown -R nginx:nginx /usr/share/nginx/html /etc/nginx  /var/cache/nginx /var/run 

# Copy the application files
COPY app/index.html ./

# Copy the Nginx Configuration for https
COPY app/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443/tcp 8443/tcp

USER nginx

# Run the nginx in foreground
CMD ["nginx", "-g", "daemon off;"]