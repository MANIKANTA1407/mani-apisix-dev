# 🚀 Mani APISIX Local Development Environment

This repository contains a complete local development setup for Apache APISIX 3.14 using Docker.

It includes monitoring, dashboard access, and custom plugin support — structured in a production-style layout similar to real-world API Gateway deployments.

---

## 📦 Components Included

- Apache APISIX (Traditional Mode)
- etcd (Configuration Store)
- Prometheus (Metrics Collection)
- Grafana (Visualization)
- APISIX Dashboard
- Custom Plugins:
  - header-injector
  - custom-file-logger

---

## 🏗 Architecture Overview

                +------------------+
                |    Grafana       |  http://localhost:3000
                +------------------+
                         ▲
                         |
                +------------------+
                |   Prometheus     |  http://localhost:9090
                +------------------+
                         ▲
                         |
+------------+     +------------------+
|  Client    | --> |   APISIX         |  9080 (Proxy)
|            |     |                  |  9180 (Admin API)
+------------+     +------------------+
                         |
                         ▼
                   +-------------+
                   |    etcd     |  2379
                   +-------------+

---

## 📁 Project Structure

mani-apisix-dev/
├── Dockerfile
├── docker-compose.yml
├── conf/
│   └── config.yaml
├── custom-plugins/
│   ├── header-injector.lua
│   └── custom-file-logger.lua
├── prometheus.yml
├── dashboard_conf.yaml
└── README.md

---

## 🚀 How To Run

1️⃣ Clone Repository

git clone https://github.com/<your-username>/mani-apisix-dev.git  
cd mani-apisix-dev  

2️⃣ Build and Start

docker compose build --no-cache  
docker compose up  

---

## 🔐 Admin API Access

Admin API URL:

http://localhost:9180/apisix/admin

Use header:

X-API-KEY: supersecret

Example:

curl http://localhost:9180/apisix/admin/services \
  -H "X-API-KEY: supersecret"

---

## 🌐 Proxy Endpoint

http://localhost:9080

---

## 📊 Monitoring & Observability

Prometheus: http://localhost:9090  
Grafana: http://localhost:3000  
APISIX Dashboard: http://localhost:9000  

---

## 🛠 Custom Plugin Development

Custom plugins are stored in:

custom-plugins/

They are copied into the APISIX image during Docker build.

To modify plugins:

1. Update plugin file
2. Rebuild:

docker compose build --no-cache  
docker compose up  

---

## ⚙ Deployment Mode

This setup runs APISIX in Traditional Mode (etcd-based configuration).

Configuration is stored in etcd.

---

## 🔒 Security Configuration

- Admin API protected via X-API-KEY
- allow_admin configured for development
- etcd communication internal via Docker network

---

## 📌 Notes

- config.yaml is rewritten internally by APISIX at startup.
- File permissions are managed in Dockerfile.
- Designed for local development and experimentation.

---

## 🎯 Purpose

This repository demonstrates:

- API Gateway setup using Apache APISIX
- Docker-based environment design
- Custom plugin integration
- Monitoring integration
- Production-style repository structure

---

## 👨‍💻 Author

Mani  
API Gateway Engineer  
Specializing in Kong, APISIX, and Cloud-based API Management
