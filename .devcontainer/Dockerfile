FROM hexpm/elixir:1.14.4-erlang-25.3-ubuntu-focal-20230126

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y && \
  apt-get install -y curl && \
  apt-get install -y git && \
  apt-get install -y apt-utils && \
  apt-get install -y build-essential && \
  apt-get install -y inotify-tools && \
  apt-get autoremove -y && \
  apt-get clean -y && \
  rm -rf /var/lib/apt/lists/* && \
  mix local.rebar --force && \
  mix local.hex --force

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
