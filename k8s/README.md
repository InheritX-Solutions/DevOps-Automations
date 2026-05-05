# Kubernetes Orchestration Showcase

This directory contains Kubernetes manifests demonstrating how to deploy, manage, and scale the multi-tier application (built in the `docker` section) on a Kubernetes cluster.

## Architecture Highlights

The manifests define the following resources:
- **Deployments:** Manages the stateless API web application, ensuring a specified number of replicas are running (high availability).
- **Services:** Provides stable networking (ClusterIP) to connect the web app with its database and cache.
- **ConfigMaps & Secrets:** Decouples configuration and sensitive credentials from the application code.
- **Ingress:** Manages external access to the services in a cluster, typically HTTP.

## Key DevOps Practices Highlighted
- **Liveness & Readiness Probes:** Kubernetes checks if the application is ready to receive traffic and if it's healthy, restarting it if necessary.
- **Resource Requests & Limits:** Ensures the application gets enough resources (CPU/RAM) without starving other applications on the cluster.
- **Decoupled Configuration:** Uses ConfigMaps and Secrets to inject environment variables, allowing the same container image to be promoted across environments (Dev -> Staging -> Prod).

## Deployment Instructions

Assuming you have `kubectl` configured to communicate with a local cluster (like Minikube, Docker Desktop, or kind):

1. **Apply Configuration and Secrets:**
   ```bash
   kubectl apply -f configmap.yaml
   kubectl apply -f secret.yaml
   ```

2. **Deploy the Database and Cache (Simulated):**
   *Note: In a real production environment, you might use managed services (like RDS/ElastiCache) or StatefulSets. For this showcase, we'll assume the app connects to the services we defined in docker-compose, or you can deploy simple pods for them.*

3. **Deploy the Application:**
   ```bash
   kubectl apply -f deployment.yaml
   ```

4. **Expose the Application:**
   ```bash
   kubectl apply -f service.yaml
   kubectl apply -f ingress.yaml
   ```

5. **Verify the Deployment:**
   ```bash
   kubectl get pods
   kubectl get services
   kubectl get ingress
   ```

6. **Scaling the Application:**
   To demonstrate scalability, you can scale the API service to 3 replicas:
   ```bash
   kubectl scale deployment showcase-api --replicas=3
   ```
