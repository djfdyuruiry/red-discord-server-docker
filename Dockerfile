FROM alpine:3.15

ENV USER_ID=1111
ENV GROUP_ID=1111
ENV TZ=UTC
ENV LANG=en_US
ENV PREFIX=-

RUN apk update \
  && apk add --no-cache \
    bash \
    build-base \
    expect \
    git \
    libffi \
    libffi-dev \
    openjdk11 \
    py3-pip \
    python3 \
    python3-dev \
    shadow \
    sudo \
    tzdata \
  && pip3 install --upgrade pip setuptools wheel \
  && pip3 install --ignore-installed distlib pipenv

RUN addgroup "red" \
  && adduser -D -G "red" "red"

USER red

ENV RED_PATH=/home/red/.red
ENV RED_DATA_PATH=/home/red/.local/share/Red-DiscordBot

RUN mkdir -p "${RED_PATH}/bin" \
  && mkdir -p "${RED_DATA_PATH}" \
  && cd "${RED_PATH}" \
  && pipenv --three install Red-DiscordBot

COPY --chown=red:red entrypoint start-red setup ${RED_PATH}/bin/

RUN chmod 700 "${RED_PATH}/bin/entrypoint" "${RED_PATH}/bin/start-red" "${RED_PATH}/bin/setup"

USER root

RUN apk del --no-cache \
    build-base \
    libffi-dev \
    python3-dev \
  && rm -rf /var/log/* /tmp/* /var/tmp/*

WORKDIR ${RED_PATH}

ENTRYPOINT /bin/bash ${RED_PATH}/bin/entrypoint
