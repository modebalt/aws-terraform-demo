package main

import (
	"fmt"
	"net/http"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/sqs"
)

func main() {
	lambda.Start(handler)
}
func handler(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	queue := os.Getenv("SQS_QUEUE_URL")
	if 	queue == "" {
		fmt.Println("You must supply the url of a queue (-q QUEUE)")
		return events.APIGatewayProxyResponse{StatusCode: http.StatusInternalServerError}, nil
	}
	sess := session.Must(session.NewSessionWithOptions(session.Options{
		SharedConfigState: session.SharedConfigEnable,

	}))
	svc := sqs.New(sess)
	_, err := svc.SendMessage(&sqs.SendMessageInput{
		MessageBody:             &request.Body,
		QueueUrl:                &queue,
	})
	if err != nil {
		return events.APIGatewayProxyResponse{StatusCode: http.StatusInternalServerError}, err
	}

	return events.APIGatewayProxyResponse{StatusCode: http.StatusOK, Body: "success"}, nil
}
