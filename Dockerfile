# Builds proto
FROM znly/protoc:0.4.0 as proto-builder
WORKDIR /workspace
COPY ./echo.proto .
RUN mkdir echo && \
    protoc ./echo.proto --go_out=plugins=grpc:echo

# Builds application
FROM golang:1.12 as builder
ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64
WORKDIR /workspace
COPY --from=proto-builder /workspace/echo .
COPY . .
RUN make build-server

# Builds docker image 
FROM alpine:3.9
RUN apk --no-cache --update add tzdata ca-certificates && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime 
COPY --from=builder /workspace/server/server /server
EXPOSE 55555
ENTRYPOINT ["/server"]
