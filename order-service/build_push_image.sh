GITHUB_USER=pyroblazer
GITHUB_REGISTRY=ghcr.io  # GitHub Container Registry URL
GITHUB_IMAGE="$GITHUB_USER/order-service:latest"
GITHUB_IMAGE_PATH="$GITHUB_REGISTRY/$GITHUB_IMAGE"
echo $GITHUB_IMAGE

# Build the image
docker build -t $GITHUB_IMAGE_PATH . -f ./Dockerfile

# # Login to GitHub Container Registry
echo $GITHUB_TOKEN | docker login $GITHUB_REGISTRY -u $GITHUB_USER --password-stdin

# # Push to GitHub Container Registry
docker push $GITHUB_IMAGE_PATH

# Cleanup: remove the local image
docker rmi $GITHUB_IMAGE_PATH