# Use an official lightweight Python image (secure & minimal)
FROM python:3.12-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Set working directory inside container
WORKDIR /app

# Install system dependencies (if needed, e.g. for psycopg2 or other packages)
# RUN apt-get update && apt-get install -y gcc

# Install Python dependencies first (optimal for Docker caching)
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy your application code
COPY src/ ./src/
COPY config/ ./config/

# Expose the application port
EXPOSE 5000

# Set environment variable default (can override at runtime)
ENV FLASK_ENV=PROD

# Run the application with Gunicorn (production best practice)
RUN pip install gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "src.app:main()"]
