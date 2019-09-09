OUT_GO_DIR="."

proto:
	@echo "generating proto..."
	@cd protobuf && protoc -I . *.proto --go_out=plugins=grpc:${OUT_GO_DIR}

build: proto
