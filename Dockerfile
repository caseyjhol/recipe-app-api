FROM python:3.7-alpine
MAINTAINER Casey Holzer

ENV PYTHONUNBUFFERED 1

RUN apk update

ENV VIRTUAL_ENV=/py
RUN python3 -m venv $VIRTUAL_ENV && /py/bin/pip install --upgrade pip
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY ./requirements.txt /requirements.txt
RUN apk add --update --no-cache postgresql-client jpeg-dev && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        gcc build-base linux-headers postgresql-dev musl-dev zlib zlib-dev && \
    /py/bin/pip install -r /requirements.txt
RUN apk del .tmp-build-deps

RUN mkdir /app
WORKDIR /app
COPY ./app /app

RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static
RUN adduser -D user
RUN chown -R user:user /vol
RUN chmod -R 755 /vol/web
USER user
