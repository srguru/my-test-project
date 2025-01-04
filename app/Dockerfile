FROM nginx:alpine

# Copy the static HTML file
COPY index.html /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]