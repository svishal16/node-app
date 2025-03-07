# Use the latest official Node.js image
FROM node:latest

# Set the working directory
WORKDIR /app

# Copy the package.json and install dependencies
COPY package.json package-lock.json ./

RUN npm install

# Copy the rest of the application
COPY . .

# Copy the PEM certificate and key into the container
RUN mkdir -p /app/certs
COPY ./certs/pem_cert/test01Keystore.pem /app/certs/test01Keystore.pem
COPY ./certs/pem_cert/vishal-dev.com_1.pem /app/certs/vishal-dev.com_1.pem

# Expose port 3000
EXPOSE 3000

# Run the Node.js app
CMD ["npm", "start"]
