#!/bin/bash
docker run -it --net=host --device /dev/snd --name=gohome -v "${PWD}/google-assistant:/google-assistant" docker-google-home