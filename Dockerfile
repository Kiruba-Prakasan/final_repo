# Use the official NGINX image as the base image
FROM nginx:alpine

# Copy the static website files to the default NGINX HTML directory
COPY . /usr/share/nginx/html

# Expose port 80 for serving the website
EXPOSE 80

# Start NGINX when the container runs
CMD ["nginx", "-g", "daemon off;"]

