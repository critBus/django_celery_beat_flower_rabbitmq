# Base image
FROM python:3.10-bullseye

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 

# SHELL ["/usr/bin/bash", "-c"]

RUN apt update && apt-get install -y unixodbc \
    unixodbc-dev \
    curl \
    apt-transport-https \
    gnupg \
    gcc \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install Microsoft ODBC Driver 17 for SQL Server
RUN curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc
RUN curl https://packages.microsoft.com/config/debian/11/prod.list | tee /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17 unixodbc-dev mssql-tools


# Create a directory for the Django app
WORKDIR /app

# Copy application requirements and install them
COPY requirements.txt /app/
RUN pip install -r requirements.txt

# Copy the Django application code
COPY . /app/

# Expose the application port
EXPOSE 8000

# Run the Gunicorn server
# CMD ["gunicorn", "--config", "gunicorn_config.py", "djangocelery.wsgi:application"]
# CMD ["python3", "manage.py", "runserver", "0.0.0.0:8000"]
# ENTRYPOINT python3 manage.py migrate && gunicorn --config gunicorn_config.py djangocelery.wsgi:application