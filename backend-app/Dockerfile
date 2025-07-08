FROM python:3.11-slim

WORKDIR /backend-app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

CMD ["flask", "--app", "./src/app.py", "--debug", "run","--host=0.0.0.0"]