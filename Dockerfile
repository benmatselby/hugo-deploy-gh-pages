FROM alpine:latest
LABEL maintainer="Ben Selby <benmatselby@gmail.com>"

LABEL "com.github.actions.name"="Hugo Deploy GitHub Pages"
LABEL "com.github.actions.description"="Build and deploy a hugo site to GitHub Pages"
LABEL "com.github.actions.icon"="target"
LABEL "com.github.actions.color"="purple"

RUN	apk add --no-cache \
	bash \
	ca-certificates \
	curl \
	git

COPY action.sh /usr/bin/action.sh

ENTRYPOINT ["action.sh"]
