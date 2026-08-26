#! /usr/bin/env -S uv run --script
"""Script to send a message to teams."""

# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "loguru>=0.7.3",
#     "requests>=2.34.2",
#     "typer>=0.27.1",
# ]
# ///

import requests
import typer

from loguru import logger

TEAMS_WEBHOOK_URL = "https://default9b6625d2cc844b8b88fe72fc92c96b.30.environment.api.powerplatform.com:443/powerautomate/automations/direct/cu/30/workflows/768ffcba10e94b1095a1f42d9ebb77f6/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=iUOMRXsSQjXgkvdwLh3pSubw9wu_Pv6bcD-YJWe5C1k"

app = typer.Typer(
    help="Twin Control",
    context_settings={"help_option_names": ["-h", "--help"]},
    pretty_exceptions_short=True,
    pretty_exceptions_enable=False,
)

@app.command("send_teams")
def send_teams_message_requests(text_message: str):
    # Simply replace this payload structure if your workflow expects a basic raw text body
    # payload = {"text": text_message} 
    payload = {
        "type": "message",
        "attachments": [
            {
                "contentType": "application/vnd.microsoft.card.adaptive",
                "content": {
                    "type": "AdaptiveCard",
                    "body": [
                        {
                            "type": "TextBlock",
                            "text": text_message,
                            "wrap": True
                        }
                    ],
                    "$schema": "http://adaptivecards.io",
                    "version": "1.4"
                }
            }
        ]
    }
    
    response = requests.post(TEAMS_WEBHOOK_URL, json=payload)
    
    if response.status_code in [200, 202]:
        print("Success!")
    else:
        print(f"Error {response.status_code}: {response.text}")



if __name__ == "__main__":
    logger.remove()
    format_str = "<green>{time:YYYY-MM-DD HH:mm:ss}</green> | <level>{level: <8}</level> | <level>{message}</level>"  # noqa:E501
    import sys

    logger.add(sys.stdout, format=format_str, colorize=True, level="INFO")

    app()
