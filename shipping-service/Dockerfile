# Use the official Node.js 14 Alpine image as the base image
FROM node:14-alpine as base

# Set the working directory within the container
WORKDIR /src

# Copy the contents of the current directory to the working directory in the container
COPY . .

# Install Node.js dependencies
RUN npm install

# Set environment variable for the application port
ENV PORT=3001

# Expose the specified port to the outside world
EXPOSE $PORT

# Install required packages (curl and bash) for the wait-for-it.sh script
RUN apk --no-cache add curl=8.4.0-r0 bash=5.2.15-r0 && \
    # Download the wait-for-it.sh script from GitHub
    curl -L https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -o ./wait-for-it.sh && \
    # Make the wait-for-it.sh script executable
    chmod +x ./wait-for-it.sh

# Define the default command to run when the container starts
CMD ["bash", "./wait-for-it.sh", "my-rabbitmq:5672", "--", "node", "index.js"]