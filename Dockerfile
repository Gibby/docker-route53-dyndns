FROM debian:stretch-slim
LABEL maintainer="git@twoitguys.com"

RUN mkdir /app
WORKDIR /app

RUN apt-get update && \
	apt-get install -y curl && \
	rm -rf /var/lib/apt/lists/*

RUN	curl -L https://glare.now.sh/jwilder/docker-gen/docker-gen-linux-amd64 -o docker-gen-linux-amd64.tar.gz && \
		tar xvzf docker-gen-linux-amd64.tar.gz -C /usr/local/bin && \
		rm docker-gen-linux-amd64.tar.gz

RUN	curl -L https://glare.now.sh/barnybug/cli53/cli53-linux-amd64 -o /usr/local/bin/cli53

COPY cli53routes.tmpl /app/cli53routes.tmpl

ENV DOCKER_HOST unix:///tmp/docker.sock

CMD /usr/local/bin/docker-gen -watch -notify "/bin/bash /tmp/cli53routes" /app/cli53routes.tmpl /tmp/cli53routes
