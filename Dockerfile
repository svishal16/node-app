# Use the latest official Node.js image
FROM node:latest

# Set the working directory
WORKDIR /app

# Copy the package.json and install dependencies
COPY package.json package-lock.json ./

RUN npm install

# Copy the rest of the application
COPY . .

# Copy the PEM certificate into the container
COPY ./certs/dec_cert/test01Keystore.pem /app/certs/dec_cert/test01Keystore.pem

# Expose port 3000
EXPOSE 3000

# Run the Node.js app
CMD ["npm", "start"]
