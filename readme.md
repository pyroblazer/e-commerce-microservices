# E-Commerce Microservices

Repository by Ignatius Timothy Manullang

## Overview

This repository contains microservices for an E-Commerce application, orchestrated using Kubernetes and Istio. Follow the instructions below to set up and test the services.

### Clone the Repository

```bash
git clone https://github.com/pyroblazer/e-commerce-microservices.git
cd e-commerce-microservices
```

### Build and Push Project Images

```bash
cd ./shipping-service
./build_push_image.sh
cd ..
cd ./order-service
./build_push_image.sh
cd ..
```

### Install Helm

Follow the Helm installation guide [here](https://helm.sh/docs/intro/install/).

### Install Istio

Download and install Istio (last tested with version 1.19.3):

```bash
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.19.3 sh -
cd istio-1.19.3
export PATH=$PWD/bin:$PATH
istioctl install --set profile=demo -y
cd ..
```

### Create Kubernetes Namespace

```bash
kubectl apply -f kubernetes/dicoding-namespace.yaml
kubectl label namespace dicoding istio-injection=enabled
```

### Deploy RabbitMQ using Helm

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install my-rabbitmq bitnami/rabbitmq -n dicoding
```

Print RabbitMQ credentials:

```bash
echo "Username      : user"
echo "Password      : $(kubectl get secret --namespace dicoding my-rabbitmq -o jsonpath="{.data.rabbitmq-password}" | base64 -d)"
echo "Erlang Cookie : $(kubectl get secret --namespace dicoding my-rabbitmq -o jsonpath="{.data.rabbitmq-erlang-cookie}" | base64 -d)"
```

### Port Forwarding for RabbitMQ

```bash
kubectl port-forward --namespace dicoding svc/my-rabbitmq 5672:5672
kubectl port-forward --namespace dicoding svc/my-rabbitmq 15672:15672
```

### Verify RabbitMQ Installation

```bash
kubectl get pods -n dicoding -l app.kubernetes.io/instance=my-rabbitmq
```

### Deploy Shipping Service

```bash
kubectl apply -f kubernetes/shipping/
```

### Verify Shipping Service

```bash
kubectl logs -n dicoding $(kubectl get pods -n dicoding -l app=e-commerce | grep ^shipping | awk '{print $1}' | head -n 1)
```

### Deploy Order Service

```bash
kubectl apply -f kubernetes/order/
```

### Verify Order Service

```bash
kubectl logs -n dicoding $(kubectl get pods -n dicoding -l app=e-commerce | grep ^order | awk '{print $1}' | head -n 1)
```

### Port Forward Istio Ingress Gateway

```bash
sudo kubectl port-forward service/istio-ingressgateway -n istio-system 80:80
```

### Test Services

Send a test request to ensure that the services are working correctly:

```bash
curl -X POST -H "Content-Type: application/json" -d '{
    "order": {
        "book_name": "Lipsum",
        "author": "Dolor Sit Amet",
        "user": "Ignatius Timothy Manullang",
        "shipping_address": "Lorem Ipsum, Dolor Sit Amet, 99999"
    }
}' http://127.0.0.1:80/order
```

### Verify Responses

Verify the responses in the shipping service:

```bash
kubectl logs -n dicoding $(kubectl get pods -n dicoding -l app=e-commerce | grep ^shipping | awk '{print $1}' | head -n 1)
```

Verify the responses in the order service:

```bash
kubectl logs -n dicoding $(kubectl get pods -n dicoding -l app=e-commerce | grep ^order | awk '{print $1}' | head -n 1)
```
