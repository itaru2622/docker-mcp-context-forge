ARG base=python:3.13-trixie
FROM ${base}
ARG base=python:3.13-trixie

RUN apt update; \
    apt install -y git make bash bash-completion gpg curl

# for dind
RUN curl -L https://get.docker.com | bash -

ARG ver_node=22
RUN curl -L https://deb.nodesource.com/setup_${ver_node}.x | bash -

# install dependencies, for mcp-contextforge-gateway
RUN apt install -y nodejs libgcc-s1 libc6 ; \
    pip install cpex-retry-with-backoff    uv

#---------------------------------------------------------------------
# https://github.com/IBM/mcp-context-forge/blob/main/DEVELOPING.md
# https://ibm.github.io/mcp-context-forge/development/building/#manual-python-setup
#
# install mcp-contextforge-gateway from source, via git clone
#---------------------------------------------------------------------
#
WORKDIR /opt/mcp-context-forge
RUN git clone https://github.com/IBM/mcp-context-forge.git .

# below is the same as: make install-db install-dev  but no venv
RUN uv pip install --system --group dev ".[redis,postgres,plugins]"
# build Web-UI
RUN make js-build
