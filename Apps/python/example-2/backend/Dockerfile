# Dockerfile for backend
# Use an official Python base image
FROM python:3.9-slim-buster

# Set the working directory inside the container
WORKDIR /app

# Copy the dependencies file and install them
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code to the working directory
COPY app.py .

# Command to run the application when the container starts
CMD ["python", "app.py"]