FROM python:3.11-slim

WORKDIR /app

# Install system dependencies for C++ compilation
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the Django project
COPY . .

# Build the C++ extension
RUN cd cpp_modules && \
    mkdir -p build && \
    cd build && \
    cmake .. && \
    make

# Expose the port the app runs on
EXPOSE 8000

# Command to run the application
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
