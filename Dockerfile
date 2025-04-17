# Stage 1: Build the Angular application
FROM node:20 as build-stage

WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy source files
COPY . .

# Build both client and server bundles
RUN npm run build -- --configuration=production

# Stage 2: Serve the application with SSR
FROM node:20-alpine

WORKDIR /app

# Copy built files from build-stage
COPY --from=build-stage /app/dist/smartconvert /app/dist/smartconvert
COPY --from=build-stage /app/dist/smartconvert/server /app/dist/server
COPY --from=build-stage /app/package.json /app/

# Install production dependencies only
RUN npm install --omit=dev

# Expose port 4000 (or your preferred port)
EXPOSE 4000

# Start the SSR server
CMD ["node", "dist/server/main.js"]
