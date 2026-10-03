# Production image for the GridWatch QA app (system under test)
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
WORKDIR /srv

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app ./app
RUN useradd --create-home appuser && chown -R appuser /srv
USER appuser

ENV PORT=8000
EXPOSE 8000
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=5 \
  CMD python -c "import urllib.request,os;urllib.request.urlopen(f'http://127.0.0.1:{os.environ.get(\"PORT\",\"8000\")}/api/health')" || exit 1

# Shell form so $PORT (set by hosts like Render/Fly) is honoured
CMD uvicorn app.main:app --host 0.0.0.0 --port ${PORT}
