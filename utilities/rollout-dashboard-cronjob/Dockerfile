FROM python:3.9.0a3-alpine3.10
WORKDIR /app/cron/
COPY requirements.txt .
RUN apt-get update && apt-get -y install libpq-dev gcc && pip install psycopg2
RUN pip3 install -r requirements.txt
COPY app.py app.py
