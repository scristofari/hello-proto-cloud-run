package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"net"
	"os"

	grcphello "github.com/scristofari/helloproto/protobuf/grpchello"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

// server is used to implement grcphello.GreeterServer.
type server struct{}

// SayHello implements grcphello.GreeterServer
func (s *server) SayHello(ctx context.Context, in *grcphello.HelloRequest) (*grcphello.HelloReply, error) {
	log.Printf("Handling SayHello request [%v] with context %v", in, ctx)
	return &grcphello.HelloReply{Message: "Hello " + in.Name}, nil
}

func main() {
	flag.Parse()
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	fmt.Println("Listen on port: " + port)
	lis, err := net.Listen("tcp", ":"+port)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()
	grcphello.RegisterGreeterServer(s, &server{})
	reflection.Register(s)
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
