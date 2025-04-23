# Stage 1: build dependencies
FROM python:3.13-alpine AS builder

# install build tools (if you have any C extensions)
RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# only copy requirements (so this layer is cached until requirements.txt changes)
COPY requirements.txt .

# install into an isolated prefix
RUN pip install --upgrade pip \
    && pip install --no-cache-dir --prefix=/install -r requirements.txt

# Stage 2: assemble final image
FROM python:3.13-alpine

WORKDIR /app

# Copy installed libs from builder
COPY --from=builder /install /usr/local

# Copy your application code
COPY app.py .

EXPOSE 5000

# Default command
CMD ["python", "app.py"]
