FROM python:3.12-slim

# Set environment variables

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app

# Install system dependencies

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first (better caching)

COPY requirements.txt .

# Install Python dependencies

RUN pip install --no-cache-dir -r requirements.txt

# Copy project files

COPY . .

# Collect static files

RUN python manage.py collectstatic --noinput || true

# Expose port

EXPOSE 8000

# Use a wrapper script to run migrations and start the server

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
