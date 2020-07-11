package main

import (
	"context"
	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"net/http"
)

func handler(ctx context.Context, request events.APIGatewayV2HTTPRequest) (events.APIGatewayV2HTTPResponse,error) {
	return events.APIGatewayV2HTTPResponse{
		Body: "it work :)",
		StatusCode: http.StatusOK,
	}, nil
}


func main() {
	lambda.Start(handler)
}

