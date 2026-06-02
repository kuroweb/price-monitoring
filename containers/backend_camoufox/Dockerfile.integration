FROM python:3.12-slim-bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
  libgtk-3-0 \
  libdbus-glib-1-2 \
  libasound2 \
  libx11-xcb1 \
  libxcomposite1 \
  libxdamage1 \
  libxrandr2 \
  libgbm1 \
  libxss1 \
  libnss3 \
  && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir "camoufox[geoip]==0.4.11" "playwright==1.53.0" \
  && python -m playwright install \
  && python -m camoufox fetch

WORKDIR /app
COPY containers/backend_camoufox/scripts/server.py /app/server.py

ENV CAMOUFOX_HOST=0.0.0.0
ENV CAMOUFOX_PORT=8890
ENV CAMOUFOX_WS_PATH=ws

EXPOSE 8890

CMD ["python", "/app/server.py"]
