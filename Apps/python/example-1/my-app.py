# app.py
import os
import psycopg2
import logging
import time

# Logging configuration
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def get_db_connection():
    """
    Establishes a connection to the PostgreSQL database using environment variables.
    Returns the connection object.
    """
    db_host = os.getenv('DB_HOST', 'db')  # 'db' is the service name in docker-compose
    db_name = os.getenv('DB_NAME', 'mydatabase')
    db_user = os.getenv('DB_USER', 'myuser')
    db_password = os.getenv('DB_PASSWORD', 'mypassword')

    # Log the read environment variables for demonstration purposes
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
            logging.info("Connection to PostgreSQL database established successfully!")
            return conn
        except psycopg2.OperationalError as e:
            logging.error(f"Database connection error: {e}")
            if i < max_retries - 1:
                logging.info(f"Retrying in {retry_delay} seconds...")
                time.sleep(retry_delay)
            else:
                logging.critical("Unable to connect to the database after several attempts. Exiting.")
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
            logging.info("Table 'messages' created or already exists.")
    except Exception as e:
        logging.error(f"Error creating table: {e}")
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
        logging.error(f"Error inserting data: {e}")
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
        logging.error(f"Error retrieving data: {e}")
        return []

if __name__ == "__main__":
    conn = None
    try:
        conn = get_db_connection()
        setup_database(conn)

        # Infinite loop to keep the application running
        message_counter = 0
        while True:
            message_counter += 1
            test_message = f"Automatic message from Docker app to DB - {message_counter} - {time.time()}"
            insert_data(conn, test_message)

            logging.info("Verifying data in the database...")
            fetch_data(conn)

            logging.info("Application running. Next insertion in 30 seconds...")
            time.sleep(30) # Wait 30 seconds before the next cycle

    except Exception as e:
        logging.critical(f"The application encountered a critical error: {e}")
    finally:
        # This part will only be reached if the While True loop is interrupted
        # (e.g., by an unhandled exception or termination signal)
        if conn:
            conn.close()
            logging.info("Database connection closed.")