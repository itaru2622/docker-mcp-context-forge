ARG base=python:3.13-trixie
FROM ${base}
ARG base=python:3.13-trixie

RUN apt update; \
    apt install -y git make bash bash-completion gpg curl

# for dind
RUN curl -L https://get.docker.com | bash -

# install mcp-contextforge-gateway via git clone
WORKDIR /opt/mcp-context-forge
RUN git clone https://github.com/IBM/mcp-context-forge.git .

# https://github.com/IBM/mcp-context-forge/blob/main/DEVELOPING.md
# https://ibm.github.io/mcp-context-forge/development/building/#manual-python-setup
# RUN pip install -e ".[dev]"
RUN pip install -e ".[dev,test,docs,otel,redis]"
