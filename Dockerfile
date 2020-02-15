FROM alpine:latest
LABEL maintainer="Ben Selby <benmatselby@gmail.com>"

RUN	apk add --no-cache \
	bash \
	ca-certificates \
	curl \
	git

COPY action.sh /usr/bin/action.sh

ENTRYPOINT ["action.sh"]
