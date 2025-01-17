# build stage
FROM golang:1.18 as backend
ENV GOPROXY="https://goproxy.cn"

RUN mkdir -p /go/src/github.com/mospany/scheduler
ADD Gopkg.* Makefile /go/src/github.com/mospany/scheduler/
WORKDIR /go/src/github.com/mospany/scheduler
#RUN make vendor
ADD . /go/src/github.com/mospany/scheduler

RUN make build

FROM alpine:3.13
COPY --from=backend /usr/share/zoneinfo/ /usr/share/zoneinfo/
COPY --from=backend /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=backend /go/src/github.com/mospany/scheduler/build/scheduler /bin
RUN apk add --update --no-cache bash ca-certificates curl git make tzdata

ENTRYPOINT ["/bin/scheduler"]

