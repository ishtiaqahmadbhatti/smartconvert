# Stage 1: Build the Angular app
FROM node:18-alpine as build

WORKDIR /app

# Copy package files first for better caching
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy all files
COPY . .

# Build the app
RUN npm run build -- --configuration production

# Stage 2: Serve the app using Nginx
FROM nginx:alpine

# Copy built assets from build stage
COPY --from=build /app/dist/your-project-name /usr/share/nginx/html

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]