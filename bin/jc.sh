#!/bin/zsh

# Consolidate daily journal files into a monthly file
# Usage: jc.sh [YYYY/MM]  (defaults to current month)
# Inspired by https://oppi.li/posts/plain_text_journaling/

VAULT_DIR="/Users/poulycroc/PoulyStuff"

if [ -n "$1" ]; then
  YEAR=$(echo "$1" | cut -d'/' -f1)
  MONTH=$(echo "$1" | cut -d'/' -f2)
else
  YEAR=$(date "+%Y")
  MONTH=$(date "+%m")
fi

DAILY_DIR="$VAULT_DIR/journal/$YEAR/$MONTH"
MONTHLY_FILE="$VAULT_DIR/journal/$YEAR/$MONTH.md"

# Check daily directory exists
if [ ! -d "$DAILY_DIR" ]; then
  echo "No daily entries found at $DAILY_DIR"
  exit 1
fi

# Count daily files
FILE_COUNT=$(ls "$DAILY_DIR"/*.md 2>/dev/null | wc -l | tr -d ' ')

if [ "$FILE_COUNT" -eq 0 ]; then
  echo "No .md files found in $DAILY_DIR"
  exit 1
fi

# Get month name for header
MONTH_NAME=$(date -jf "%m" "$MONTH" "+%B" 2>/dev/null)

# Write monthly header
cat > "$MONTHLY_FILE" << EOF
---
tags:
  - journal
hubs:
  - "[[journal]]"
---

# $MONTH_NAME $YEAR
EOF

# Append each daily file (strip frontmatter)
for file in "$DAILY_DIR"/*.md; do
  echo "" >> "$MONTHLY_FILE"
  # Skip lines between --- markers (frontmatter), print the rest
  awk 'BEGIN{skip=0} /^---$/{skip++; next} skip>=2{print}' "$file" >> "$MONTHLY_FILE"
done

# Remove daily directory
rm -rf "$DAILY_DIR"

echo "Consolidated $FILE_COUNT entries into $MONTHLY_FILE"
