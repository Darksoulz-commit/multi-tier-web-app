# End-to-End CI/CD Pipeline for Multi-Tier Python Web Application

An enterprise-grade, automated CI/CD pipeline built using **Jenkins, Docker, and AWS EC2** to build, test, version, and deploy a containerized Python Flask web application across multiple environments (`TEST`, `DEV`, `PROD`).

## 🚀 Architecture & Workflow

1. **Code Commit:** Developer pushes code & `Jenkinsfile` to **GitHub**.
2. **Webhook Trigger:** GitHub Webhook automatically triggers the **Jenkins** pipeline on AWS EC2.
3. **Docker Build & Dynamic Tagging:** Jenkins builds the Docker image and tags it dynamically using `v${BUILD_NUMBER}` (preventing `:latest` tag overwrites).
4. **Automated Unit Testing (PyTest):** Spins up an ephemeral (`--rm`) test container to validate application logic before pushing to the registry.
5. **Artifact Registry:** Pushes the verified image to **Docker Hub** (`navi561/multi-tier-app`) using secured Jenkins Credentials.
6. **Parameterized Deployment:** Deploys the container to the target environment (`TEST`, `DEV`, or `PROD`) on isolated ports.
7. **Alerting:** Sends automated **SMTP Email Notifications** on build success or failure.

## 🛠️ Tech Stack

* **Cloud & OS:** AWS EC2 (`t3.micro`), Ubuntu Linux (2GB Swap Configured)
* **CI/CD Tool:** Jenkins (Declarative Pipeline, GitHub Webhook, Credentials Binding)
* **Containerization:** Docker, Docker Hub
* **Application & Testing:** Python 3.12, Flask, PyTest
* **Version Control:** Git & GitHub

## 🌐 Environment Port Mapping

| Environment | Container Name | Host Port | Container Port |
| :--- | :--- | :--- | :--- |
| **PROD** | `my-app-prod` | `8000` | `8000` |
| **DEV** | `my-app-dev` | `8001` | `8000` |
| **TEST** | `my-app-test` | `8002` | `8000` |

## ✨ Key DevOps Best Practices Implemented

* **Zero Overwrite Versioning:** Uses `IMAGE_TAG = "v${env.BUILD_NUMBER}"` so every build artifact is immutable and ready for instant rollback.
* **Shift-Left Testing:** Runs `docker run --rm <image> pytest test_app.py` inside the pipeline; if tests fail, Docker Hub push and deployment stages are automatically aborted.
* **Idempotent Container Deployment:** Uses `docker stop <name> || true` and `docker rm <name> || true` to ensure clean container replacement without pipeline failures on fresh runs.
* **Server Stability & Memory Management:** Tuned AWS `t3.micro` (1GB RAM) with persistent `/swapfile` allocation and `docker system prune` routines to prevent Jenkins JVM OOM crashes.

## 💻 Run Locally with Docker

```bash
# Pull the latest versioned image from Docker Hub
docker pull navi561/multi-tier-app:v24

# Run the container locally
docker run -d -p 8000:8000 --name local-app navi561/multi-tier-app:v24