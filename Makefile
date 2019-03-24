all: build
get:
	go get -d -v ./...
build-server: get
	go build -o server/server ./server
build-client: get 
	go build -o client/client ./client
gen-pb:
	mkdir -p echo
	docker run --rm \
		-v $$(pwd):$$(pwd) \
		-w $$(pwd) \
		znly/protoc:0.4.0 \
		-I . echo.proto --go_out=plugins=grpc:echo
build: gen-pb get build-server build-client

build-image:
	docker build . -t grpc-example

.PHONY: \
	build-server \
	build-client \
	gen-pb \
	build \
	build-image \
	all
