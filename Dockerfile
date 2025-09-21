FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Install Python dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Copy the project
COPY . .

# Django settings
ENV DJANGO_SETTINGS_MODULE=test_cicd.settings \
    PORT=8123

EXPOSE 8123

# Run DB migrations and start Gunicorn
CMD sh -lc "python manage.py migrate --noinput && python test.py"
