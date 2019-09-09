# Default value of GRPC_PORT
ARG GRPC_PORT=8080
FROM golang:alpine as builder

# Install tools required to build the project
RUN apk update && apk add git && apk add ca-certificates

# Create appuser
RUN adduser -D -g '' appuser

# Copy all project and build it
COPY . $GOPATH/src/github.com/scristofari/helloworld/
WORKDIR $GOPATH/src/github.com/scristofari/helloworld/

RUN GO111MODULE=on go mod vendor
#build the binary linux only with debug information removed
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags="-w -s -X main.Env=prod" -o /go/bin/helloworld cmd/grpc/main.go

#
# final stage
#
# start from scratch
FROM scratch
ARG GRPC_PORT

# Copy ssl certificate from ca-certificates of previous image
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/passwd
# Copy our static executable
COPY --from=builder /go/bin/helloworld /go/bin/helloworld
USER appuser
# Expose our service on port $GRPC_PORT
EXPOSE $GRPC_PORT
ENTRYPOINT ["/go/bin/helloworld"]
