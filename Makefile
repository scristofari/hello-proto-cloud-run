OUT_GO_DIR="."

proto:
	@echo "generating proto..."
	@cd protobuf/grpc-hello && protoc -I . *.proto --go_out=plugins=grpc:${OUT_GO_DIR}

build: proto
