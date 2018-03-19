FROM ubuntu:latest

#env http_proxy http://10.35.255.65:8080
#env https_proxy http://10.35.255.65:10443

ENV \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    LANGUAGE=C.UTF-8

# install python env
# install deps + google assistant
RUN apt-get update \
    && apt-get install -y  python3-pip python3 python3-dev python3-venv \ 
	&& python3 -m venv env \
    && env/bin/python3 -m pip install --upgrade pip setuptools wheel \
    && /bin/bash -c "source env/bin/activate" \
	&& apt-get install -y portaudio19-dev libffi-dev libssl-dev \
	&& env/bin/python3 -m pip install --upgrade google-assistant-library \
	&& env/bin/python3 -m pip install --upgrade google-assistant-sdk[samples] \
	&& env/bin/python3 -m pip install --upgrade google-auth-oauthlib[tool]

#clean env
RUN apt-get remove -y --purge python3-pip python3-dev \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /google-assistant

VOLUME /google-assistant
#
#CMD cp /google-assistant/asoundrc.config /root/.asoundrc | true && \
CMD . /env/bin/activate && google-oauthlib-tool \
--client-secrets /google-assistant/clientid.json \
--scope https://www.googleapis.com/auth/assistant-sdk-prototype \
--save \
--headless \
&& googlesamples-assistant-hotword
