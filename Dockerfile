FROM debian:buster-slim
LABEL maintainer="Ben Selby <benmatselby@gmail.com>"

##
# Define the location of Go.
# We may not always install it, but if we do, it's here.
##
ENV GOPATH /go
ENV PATH /go/bin:/usr/local/go/bin:$PATH

##
# Installation of all the tooling we need.
##
RUN apt-get update && \
	apt-get install -y --no-install-recommends \
	ca-certificates  \
	curl \
	jq \
	git && \
	rm -rf /var/lib/apt/lists/*

##
# Copy over the action script.
##
COPY action.sh /usr/bin/action.sh

##
# Run the action.
##
ENTRYPOINT ["action.sh"]
