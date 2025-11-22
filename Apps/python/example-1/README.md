# Python App with PostgreSQL - Docker Compose & Environment Variables Example

## Project Purpose

This project is designed as a practical example for developers who want to learn **how to manage environment variables** in a Dockerized application.

Hardcoding configuration values (like database passwords or API keys) in your code is a bad practice. Instead, you should use **environment variables**. This project demonstrates:

1.  How to define environment variables in `docker-compose.yml`.
2.  How to read those variables in a Python application using `os.getenv()`.
3.  How to connect a Python app to a PostgreSQL database using these variables.

## How it Works

### 1. Defining Variables in Docker Compose

In `docker-compose.yml`, we define the environment variables for the `app` service:

```yaml
environment:
  DB_HOST: db
  DB_NAME: mydatabase
  DB_USER: myuser
  DB_PASSWORD: mypassword
```

### 2. Reading Variables in Python

In `my-app.py`, we read these values dynamically. If the variable is not found, we can provide a default value (though for sensitive data, you might want to fail if it's missing).

```python
import os

db_host = os.getenv('DB_HOST', 'localhost')
db_user = os.getenv('DB_USER', 'admin')
```

This allows you to change the configuration without changing a single line of code!

## Getting Started

### Prerequisites

- Docker and Docker Compose installed on your machine.

### Running the Application

1.  **Open your terminal.**
2.  **Navigate to the project folder.**
3.  **Run the command:**

    ```bash
    docker compose up --build
    ```

    - `docker compose up`: Starts the services defined in `docker-compose.yml`.
    - `--build`: Rebuilds the application image if there are changes in the Dockerfile or source code.

## Checking Logs

While the containers are running, you will see logs from both services (`db` and `app`) in the terminal.

To see only the application logs, open a new terminal and type:

```bash
docker compose logs -f app
```

You will see the application logs, including messages indicating the database connection and data insertion.

## Accessing the Application Container

To explore the running container:

```bash
docker exec -it python_app sh

# Check environment variables inside the container
env

# To exit the container
exit
```

## Testing Database Connection

### Automatic Test (After Startup)

Once started, the application automatically inserts a message and then retrieves all messages, printing them to the logs. This is the primary way to test the insertion.

### Manual External Verification (Optional)

You can connect to the PostgreSQL database directly from your host (since port 5432 is mapped) using a client like `psql` or DBeaver.

1.  **Connect with psql:**

    ```bash
    psql -h localhost -p 5432 -U myuser -d mydatabase
    ```

2.  **Enter the password when prompted:** `mypassword`

3.  **Run the query to see inserted data:**

    ```sql
    SELECT * FROM messages;
    ```

## Key Concepts Explained

### Robust Connection

The `get_db_connection` function in `my-app.py` includes a retry mechanism with a delay to handle the fact that the database might not be immediately available when the application starts.

### depends_on and service_healthy

In `docker-compose.yml`, `app` depends on `db` with the condition `service_healthy`. This ensures that the application does not attempt to connect to the database until PostgreSQL is fully started and ready to accept connections.

### Data Persistence

The `db_data` volume in `docker-compose.yml` ensures that PostgreSQL data persists even if the `db` container is removed and recreated.
