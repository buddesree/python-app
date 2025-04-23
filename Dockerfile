# Stage 1: build dependencies
FROM python:3.13-alpine AS builder

# Install Alpine build tools for C extensions
RUN apk add --no-cache \
      build-base    \
      libffi-dev    \
      openssl-dev   \
      musl-dev      \
      python3-dev

WORKDIR /build

# Copy requirements and install into /install (so this layer caches well)
COPY requirements.txt .
RUN pip install --upgrade pip \
 && pip install --no-cache-dir --prefix=/install -r requirements.txt

# Stage 2: runtime image
FROM python:3.13-alpine

WORKDIR /app

# Bring in the pre-installed packages
COPY --from=builder /install /usr/local

# Copy application code
COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]
