FROM ubuntu:latest
LABEL authors="vitinho"

ENTRYPOINT ["top", "-b"]