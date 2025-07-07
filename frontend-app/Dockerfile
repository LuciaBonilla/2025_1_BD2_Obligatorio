# Use Node.js image to build the app
FROM node:24-slim

# Set working directory
WORKDIR /frontend-app

# Copy package.json and package-lock.json (if it exists)
COPY package*.json ./

RUN npm install || (rm -rf node_modules package-lock.json && npm install)

# Comprobamos que vite se instaló
RUN npx vite --version

# Copy the rest of the application
COPY . .

# Expose the port Vite uses
EXPOSE 5173

# Start the Vite development server
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]