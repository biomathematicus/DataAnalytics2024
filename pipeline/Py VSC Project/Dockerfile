FROM python:3.9-slim
WORKDIR /app
COPY . /app

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    python3-dev \
    && apt-get clean

RUN mkdir data

RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 80
ENV NAME World
# CMD ["python", "app.py"]
