# airflow-install-script
A simple Linux installer for development environments that sets up **Apache Airflow** using **Docker Compose**.  

## 🚀 What the Script Does
- Checks for required dependencies (`curl`, `awk`, and `Docker Compose`).
- Downloads the latest stable official `docker-compose.yaml` from the Apache Airflow project.
- Creates or updates the `.env` file setting `AIRFLOW_UID` as the `current user` id.
- Initializes Airflow’s configuration and database.
- Prepares the environment so services can be launched.

## 📦 Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/lucasromulosr/airflow-installer-script.git
   cd airflow-installer-script
   ```
   
2. Make the script executable:
   ```bash
   chmod +x install.sh
   ```

 3. Install:
    ```bash
    ./install.sh
    ```

## ▶️ Running Airflow after installation
* Start Airflow environment:
  ```bash
  docker compose up
  ```
* 🌼 [Optional]
  If you want to start Airflow withFlower enabled (for monitoring Celery):
  ```bash
  docker compose --profile flower up
  ```

## 📚 Official Documentation
For more details on running Airflow with Docker Compose, visit:
https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/index.html
