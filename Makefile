SHELL=/bin/bash

wDir ?=${PWD}
base ?=python:3.13-trixie
img  ?=itaru2622/mcp-context-forge:trixie

cName ?=mcp-context-forge
PORT  ?=4444

#envs refer to  https://github.com/IBM/mcp-context-forge/blob/main/DEVELOPING.md and https://github.com/IBM/mcp-context-forge/blob/main/.env.example
# account info
admin_pass ?=admin
admin_email ?=admin@example.com
BASIC_AUTH_USER ?=admin
BASIC_AUTH_PASSWORD ?=${admin_pass}
PLATFORM_ADMIN_PASSWORD ?=${admin_pass}
PLATFORM_ADMIN_EMAIL ?=${admin_email}

# password policy
PASSWORD_CHANGE_ENFORCEMENT_ENABLED ?=false
PASSWORD_PREVENT_REUSE ?=false
ADMIN_REQUIRE_PASSWORD_CHANGE_ON_BOOTSTRAP ?=false
DETECT_DEFAULT_PASSWORD_ON_LOGIN ?=false
REQUIRE_PASSWORD_CHANGE_FOR_DEFAULT_PASSWORD ?=false
PASSWORD_POLICY_ENABLED ?=false

AUTH_REQUIRED ?=false                # no auth
SECURE_COOKIES ?=false               # cookie mode (insecure)
MCPGATEWAY_UI_ENABLED ?=true         # Enable Admin UI
MCPGATEWAY_ADMIN_API_ENABLED ?=true  # Enable Admin API
PLUGINS_ENABLED ?=true               # Enable plugins
DEV_MODE ?=true                      # Additional development helpers
DEBUG ?=true                         # Verbose error messages
RELOAD ?=true                        # Auto-reload on code changes
LOG_LEVEL ?=DEBUG                    # Maximum logging verbosity
ENVIRONMENT ?=development            # Enables debug features

# command to run in docker.
cmd   ?=uvicorn mcpgateway.main:app --host 0.0.0.0 --port ${PORT} --reload

build:
	docker build -t ${img} .

bash:
	docker run --name ${cName} -it --rm -p ${PORT}:${PORT}          \
	-v ${wDir}/Makefile:/opt/mcp-context-forge/Makefile.mine        \
	-e BASIC_AUTH_USER=${BASIC_AUTH_USER} -e BASIC_AUTH_PASSWORD=${BASIC_AUTH_PASSWORD}  -e PLATFORM_ADMIN_PASSWORD=${PLATFORM_ADMIN_PASSWORD} -e PLATFORM_ADMIN_EMAIL=${PLATFORM_ADMIN_EMAIL} \
	-e PASSWORD_PREVENT_REUSE=${PASSWORD_PREVENT_REUSE} -e ADMIN_REQUIRE_PASSWORD_CHANGE_ON_BOOTSTRAP=${ADMIN_REQUIRE_PASSWORD_CHANGE_ON_BOOTSTRAP} -e DETECT_DEFAULT_PASSWORD_ON_LOGIN=${DETECT_DEFAULT_PASSWORD_ON_LOGIN} -e REQUIRE_PASSWORD_CHANGE_FOR_DEFAULT_PASSWORD=${REQUIRE_PASSWORD_CHANGE_FOR_DEFAULT_PASSWORD} -e PASSWORD_POLICY_ENABLED=${PASSWORD_POLICY_ENABLED} \
	-e AUTH_REQUIRED=${AUTH_REQUIRED}                               \
	-e SECURE_COOKIES=${SECURE_COOKIES}                             \
	-e MCPGATEWAY_UI_ENABLED=${MCPGATEWAY_UI_ENABLED}               \
	-e MCPGATEWAY_ADMIN_API_ENABLED=${MCPGATEWAY_ADMIN_API_ENABLED} \
	-e PLUGINS_ENABLED=${PLUGINS_ENABLED}                           \
	-e DEV_MODE=${DEV_MODE}                                         \
	-e DEBUG=${DEBUG}                                               \
	-e LOG_LEVEL=${LOG_LEVEL}                                       \
	-e ENVIRONMENT=${ENVIRONMENT}                                   \
	-e RELOAD=${RELOAD}                                             \
	${img} /bin/bash

run:
	${cmd}
