package main

import (
	"context"
	"fmt"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/sns"
)

func handler(ctx context.Context, sqsEvent events.SQSEvent) error {
	topic := os.Getenv("SNS_TOPIC_ARN")
	if 	topic == "" {
		fmt.Println("You must supply sns topic arn")
		os.Exit(1)
	}
    sess := session.Must(session.NewSessionWithOptions(session.Options{
        SharedConfigState: session.SharedConfigEnable,
    }))

    svc := sns.New(sess)
    for _, message := range sqsEvent.Records {
        fmt.Printf("The message %s for event source %s = %s \n", message.MessageId, message.EventSource, message.Body)
    
    result, err := svc.Publish(&sns.PublishInput{
        Message:  &message.Body,
        TopicArn: &topic,
    })
    if err != nil {
        fmt.Println(err.Error())
        os.Exit(1)
    }

    fmt.Println(*result.MessageId)
    }
    return nil
}

func main() {
    lambda.Start(handler)
}