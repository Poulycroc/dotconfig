#!/bin/zsh

# Create/open today's journal entry
# Inspired by https://oppi.li/posts/plain_text_journaling/

VAULT_DIR="/Users/poulycroc/PoulyStuff"
TEMPLATE="$VAULT_DIR/templates/journal-daily.md"

YEAR=$(date "+%Y")
MONTH=$(date "+%m")
DAY=$(date "+%d")
WEEK=$(date "+%V")
DATE_STR=$(date "+%Y-%m-%d")

JOURNAL_DIR="$VAULT_DIR/journal/$YEAR/$MONTH"
JOURNAL_FILE="$JOURNAL_DIR/$DAY.md"

# Create directory if needed
mkdir -p "$JOURNAL_DIR"

# Create file from template if it doesn't exist
if [ ! -f "$JOURNAL_FILE" ]; then
  sed -e "s/{{date}}/$DATE_STR/g" -e "s/{{week_number}}/$WEEK/g" "$TEMPLATE" > "$JOURNAL_FILE"
fi

# Print path for nvim to open
echo "$JOURNAL_FILE"
