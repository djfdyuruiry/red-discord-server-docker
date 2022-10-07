FROM ubuntu:focal

ENV USER_ID=1111
ENV GROUP_ID=1111
ENV TZ=UTC
ENV LANG=en_US
ENV PREFIX=-

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

RUN apt update \
  && apt -y dist-upgrade \
  && apt -y install \
    build-essential \
    expect \
    git \
    openjdk-11-jre-headless \
    python3.9 \
    python3.9-dev \
    python3-pip \
    sudo \
  && pip install -U pip setuptools wheel \
  && pip install pipenv

RUN addgroup --gid ${GROUP_ID} red \
  && adduser --system --uid ${USER_ID} --ingroup red red

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

RUN apt-get remove -y \
    build-essential \
    python3.8-dev \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/log/* /tmp/* /var/tmp/*

WORKDIR ${RED_PATH}

ENTRYPOINT /usr/bin/bash ${RED_PATH}/bin/entrypoint
