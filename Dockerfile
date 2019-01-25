FROM alpine:latest
LABEL maintainer="Ben Selby <benmatselby@gmail.com>"

LABEL "com.github.actions.name"="Hugo Deploy GitHub Pages"
LABEL "com.github.actions.description"="Build and deploy a hugo site to GitHub Pages"
LABEL "com.github.actions.icon"="target"
LABEL "com.github.actions.color"="purple"

ENV HUGO_VERSION 0.53

RUN	apk add --no-cache \
	bash \
	ca-certificates \
	curl

RUN curl -sSL https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz > /tmp/hugo.tar.gz && tar -f /tmp/hugo.tar.gz -xz
RUN mv /hugo /usr/bin/hugo

COPY action.sh /usr/bin/action.sh

ENTRYPOINT ["action.sh"]
