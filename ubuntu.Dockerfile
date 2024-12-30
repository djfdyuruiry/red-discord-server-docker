FROM ubuntu:noble

ENV USER_ID=1111
ENV GROUP_ID=1111
ENV TZ=UTC
ENV LANG=en_US
ENV PREFIX=-

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

RUN apt update \
  && apt -y dist-upgrade

RUN apt -y install software-properties-common \
  && apt update \
  && add-apt-repository -y ppa:deadsnakes/ppa

RUN apt -y install \
    build-essential \
    expect \
    git \
    openjdk-17-jre-headless \
    python3.11 \
    python3.11-dev \
    wget

RUN wget https://bootstrap.pypa.io/get-pip.py \
  && python3.11 get-pip.py \
  && rm -f get-pip.py \
  && python3.11 -m pip install --break-system-packages pipenv

RUN addgroup --gid ${GROUP_ID} red && \
  adduser --system --uid ${USER_ID} --home /home/red --ingroup red red

USER red

ENV RED_PATH=/home/red/.red
ENV RED_DATA_PATH=/home/red/.local/share/Red-DiscordBot

RUN mkdir -p "${RED_PATH}/bin" \
  && mkdir -p "${RED_DATA_PATH}" \
  && cd "${RED_PATH}" \
  && pipenv install \
  && pipenv install pip wheel \
  && pipenv install Red-DiscordBot

COPY --chown=red:red --chmod=700 entrypoint start-red setup ${RED_PATH}/bin/

USER root

RUN apt-get remove -y \
    build-essential \
    python3-dev \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/log/* /tmp/* /var/tmp/*

WORKDIR ${RED_PATH}

ENTRYPOINT /usr/bin/bash ${RED_PATH}/bin/entrypoint
