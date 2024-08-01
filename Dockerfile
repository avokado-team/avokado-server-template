# Build Container Image Stage
FROM python:3.11.9 as build

WORKDIR /usr/src/app

# hadolint ignore=DL3013
COPY Pipfile Pipfile.lock ./
ENV PIPENV_VENV_IN_PROJECT=1
RUN python -m pip install --no-cache-dir --upgrade pip && \
    python -m pip install --no-cache-dir pipenv && \
    python -m pipenv install

# Runtime Container Image Stage
FROM python:3.11.9-slim as runtime

RUN apt-get update && \
    apt-get install -y libpq-dev && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/.venv ./.venv
COPY ./ ./

ENV PATH="/usr/src/app/.venv/bin:$PATH"

# port 설정
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
EXPOSE 8000
RUN ls /usr/src/app
RUN chmod 777 /usr/src/app/server.sh

# run command 설정
ENTRYPOINT ["/bin/bash", "-c", "/usr/src/app/server.sh"]
