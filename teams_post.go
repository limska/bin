package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"strings"
	"time"
)

// Replace with your actual URL copied from the Teams Workflow trigger
const TeamsWebhookURL = "https://default9b6625d2cc844b8b88fe72fc92c96b.30.environment.api.powerplatform.com:443/powerautomate/automations/direct/cu/30/workflows/768ffcba10e94b1095a1f42d9ebb77f6/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=iUOMRXsSQjXgkvdwLh3pSubw9wu_Pv6bcD-YJWe5C1k"

// TextBlock defines the layout for text inside the Adaptive Card body
type TextBlock struct {
	Type string `json:"type"`
	Text string `json:"text"`
	Wrap bool   `json:"wrap"`
}

// AdaptiveCardContent contains the strict structural schema required by Microsoft
type AdaptiveCardContent struct {
	Type    string      `json:"type"`
	Body    []TextBlock `json:"body"`
	Schema  string      `json:"$schema"`
	Version string      `json:"version"`
}

// Attachment binds the content to the specific Teams JSON media type
type Attachment struct {
	ContentType string              `json:"contentType"`
	Content     AdaptiveCardContent `json:"content"`
}

// TeamsPayload is the top-level structure transmitted to the webhook endpoint
type TeamsPayload struct {
	Type        string       `json:"type"`
	Attachments []Attachment `json:"attachments"`
}

func sendTeamsMessage(textMessage string) error {
	// Build the complete nested payload with the required content type string
	payload := TeamsPayload{
		Type: "message",
		Attachments: []Attachment{
			{
				ContentType: "application/vnd.microsoft.card.adaptive",
				Content: AdaptiveCardContent{
					Type: "AdaptiveCard",
					Body: []TextBlock{
						{
							Type: "TextBlock",
							Text: textMessage,
							Wrap: true,
						},
					},
					Schema:  "http://adaptivecards.io",
					Version: "1.4",
				},
			},
		},
	}

	// Marshall the Go struct data layers directly into JSON bytes
	jsonBytes, err := json.Marshal(payload)
	if err != nil {
		return fmt.Errorf("failed to marshal JSON payload: %w", err)
	}

	// Initialize the network request with a context/timeout layer for resilience
	req, err := http.NewRequest("POST", TeamsWebhookURL, bytes.NewBuffer(jsonBytes))
	if err != nil {
		return fmt.Errorf("failed to create request: %w", err)
	}

	// Teams Workflows require explicit JSON header declarations
	req.Header.Set("Content-Type", "application/json")

	// Execute request with an explicit client network timeout
	client := &http.Client{Timeout: 10 * time.Second}
	resp, err := client.Do(req)
	if err != nil {
		return fmt.Errorf("network request failed: %w", err)
	}
	defer resp.Body.Close()

	// Webhook triggers return a 202 Accepted status upon queueing the flow execution
	if resp.StatusCode != http.StatusAccepted && resp.StatusCode != http.StatusOK {
		return fmt.Errorf("teams returned an error status code: %d", resp.StatusCode)
	}

	return nil
}

func main() {
	// Verify that the user passed an argument
	if len(os.Args) < 2 {
		fmt.Fprintf(os.Stderr, "Usage: %s \"your message here\"\n", os.Args[0])
		os.Exit(1)
	}

	// Join all remaining command-line arguments with a space.
	// This allows the user to pass text without quotes if desired, 
	// though wrapped quotes are still best for structured formatting.
	message := strings.Join(os.Args[1:], " ")


	fmt.Println("Sending message to Microsoft Teams...")
	if err := sendTeamsMessage(message); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}

	fmt.Println("Message successfully sent to Teams Workflow!")
}

