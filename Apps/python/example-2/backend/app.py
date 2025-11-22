# app.py
import os
import psycopg2
import logging
import time
from flask import Flask, request, jsonify, Response
from flask_cors import CORS
from datetime import datetime

# Logging configuration
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

app = Flask(__name__)
CORS(app)  # Enable CORS for frontend requests

def get_db_connection():
    """
    Establishes a connection to the PostgreSQL database using environment variables.
    Returns the connection object.
    """
    db_host = os.getenv('DB_HOST', 'db')  # 'db' is the service name in docker-compose
    db_name = os.getenv('DB_NAME', 'mydatabase')
    db_user = os.getenv('DB_USER', 'myuser')
    db_password = os.getenv('DB_PASSWORD', 'mypassword')

    # Log the read environment variables for demonstration
    logging.info(f"Environment variables read: DB_HOST={db_host}, DB_NAME={db_name}, DB_USER={db_user}")

    conn = None
    max_retries = 10
    retry_delay = 5  # seconds

    for i in range(max_retries):
        try:
            logging.info(f"Attempting to connect to database {db_name} on {db_host} (attempt {i+1}/{max_retries})...")
            conn = psycopg2.connect(
                host=db_host,
                database=db_name,
                user=db_user,
                password=db_password
            )
            logging.info("PostgreSQL database connection established successfully!")
            return conn
        except psycopg2.OperationalError as e:
            logging.error(f"Database connection error: {e}")
            if i < max_retries - 1:
                logging.info(f"Retrying in {retry_delay} seconds...")
                time.sleep(retry_delay)
            else:
                logging.critical("Unable to connect to database after several attempts. Exiting.")
                raise
    return conn

def setup_database(conn):
    """
    Creates the 'messages' table if it does not exist.
    """
    try:
        with conn.cursor() as cur:
            cur.execute("""
                CREATE TABLE IF NOT EXISTS messages (
                    id SERIAL PRIMARY KEY,
                    content VARCHAR(255) NOT NULL,
                    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                );
            """)
            conn.commit()
            logging.info("'messages' table created or already exists.")
    except Exception as e:
        logging.error(f"Error during table creation: {e}")
        conn.rollback()

def insert_data(conn, message):
    """
    Inserts a message into the 'messages' table.
    """
    try:
        with conn.cursor() as cur:
            cur.execute("INSERT INTO messages (content) VALUES (%s);", (message,))
            conn.commit()
            logging.info(f"Data inserted successfully: '{message}'")
    except Exception as e:
        logging.error(f"Error during data insertion: {e}")
        conn.rollback()

def fetch_data(conn):
    """
    Retrieves all messages from the 'messages' table.
    """
    try:
        with conn.cursor() as cur:
            cur.execute("SELECT id, content, timestamp FROM messages ORDER BY timestamp DESC;")
            rows = cur.fetchall()
            if rows:
                logging.info("Data retrieved from database:")
                for row in rows:
                    logging.info(f"  ID: {row[0]}, Content: '{row[1]}', Timestamp: {row[2]}")
            else:
                logging.info("No data found in 'messages' table.")
            return rows
    except Exception as e:
        logging.error(f"Error during data retrieval: {e}")
        return []

@app.route('/messages', methods=['GET'])
def get_messages():
    """
    API endpoint to get all messages.
    """
    conn = None
    try:
        conn = get_db_connection()
        setup_database(conn)
        messages = fetch_data(conn)
        # Convert to list of dicts for JSON
        messages_list = [{'id': row[0], 'content': row[1], 'timestamp': str(row[2])} for row in messages]
        return jsonify(messages_list)
    except Exception as e:
        logging.error(f"Error in get_messages: {e}")
        return jsonify({'error': 'Internal server error'}), 500
    finally:
        if conn:
            conn.close()

@app.route('/messages', methods=['POST'])
def add_message():
    """
    API endpoint to add a new message.
    Expects JSON with 'content' field.
    """
    data = request.get_json()
    if not data or 'content' not in data:
        return jsonify({'error': 'Missing content field'}), 400
    message = data['content']
    conn = None
    try:
        conn = get_db_connection()
        setup_database(conn)
        insert_data(conn, message)
        return jsonify({'status': 'success'})
    except Exception as e:
        logging.error(f"Error in add_message: {e}")
        return jsonify({'error': 'Internal server error'}), 500
    finally:
        if conn:
            conn.close()

@app.route('/health')
def health():
    """
    Health check endpoint for monitoring.
    """
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.now().isoformat(),
        'version': '1.0.0'
    })

@app.route('/metrics')
def metrics():
    """
    Prometheus metrics endpoint.
    """
    # Basic metrics for demonstration
    return Response(
        "# HELP app_requests_total Total number of requests\n"
        "# TYPE app_requests_total counter\n"
        f"app_requests_total {{method=\"GET\",endpoint=\"/messages\"}} {getattr(app, '_request_count', 0)}\n"
        "# HELP app_health_status Application health status\n"
        "# TYPE app_health_status gauge\n"
        "app_health_status 1\n",
        mimetype='text/plain'
    )

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)