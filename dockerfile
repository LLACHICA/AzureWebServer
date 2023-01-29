FROM nginx:latest

ARG IP_ADDRESS
ENV IP_ADDRESS ${IP_ADDRESS}

# Expose port 80 for incoming connections
EXPOSE 80

# Start Nginx as the default command when the container is run
CMD ["nginx", "-g", "daemon off;"]