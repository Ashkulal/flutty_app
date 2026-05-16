# Stage 1: Serve the app using Nginx
FROM nginx:alpine

# Copy the built web files to the Nginx html directory
# We assume 'flutter build web' has already been run
COPY build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
