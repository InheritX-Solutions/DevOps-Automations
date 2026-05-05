# Docker Containerization Showcase

This directory demonstrates modern containerization practices using Docker and Docker Compose. It features a multi-tier web application architecture designed with production readiness in mind.

## Architecture

The setup includes the following services orchestrated via Docker Compose:
1. **Node.js Web App:** A simple API server running in a container, built using a multi-stage Dockerfile.
2. **Redis:** An in-memory data structure store, used as a cache.
3. **PostgreSQL:** A robust relational database system.

## Key DevOps Practices Highlighted

- **Multi-stage Builds:** The `Dockerfile` uses multiple stages to keep the final image size minimal and secure by discarding build dependencies.
- **Non-Root User:** The application runs as a dedicated non-root user (`node`) to mitigate security risks.
- **Dependency Caching:** `package.json` is copied before source code to leverage Docker's layer caching, speeding up subsequent builds.
- **Healthchecks:** The `docker-compose.yml` defines health checks to ensure services are ready before depending on them (e.g., app waits for DB).

## Running the Showcase

1. Ensure Docker and Docker Compose are installed and running.
2. Navigate to this directory (`docker/`).
3. Run the following command to build the images and start the services in the background:

   ```bash
   docker-compose up -d --build
   ```

4. You can check the status of the containers:
   
   ```bash
   docker-compose ps
   ```

5. The API will be accessible on `http://localhost:3000`. (You can simulate a request using `curl http://localhost:3000/health`)

6. To stop the services and remove the containers, run:

   ```bash
   docker-compose down
   ```
