# Use Node.js image to build the app
FROM node:24-slim

# Set working directory
WORKDIR /frontend-app

# Copy package.json and install dependencies
COPY package*.json ./

# Remove node_modules and package-lock.json if they exist
RUN rm -rf node_modules package-lock.json

# Install dependencies
RUN npm install

# Expose the port Vite uses
EXPOSE 5173

# Start the Vite development server
CMD ["npm", "run", "dev","--","--host","0.0.0.0"]