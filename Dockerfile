FROM python:3.11.0a7-alpine3.15

WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip3 install --no-cache-dir -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 80

COPY . .

CMD ["python3", "main.py"]
