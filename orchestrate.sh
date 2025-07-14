#!/bin/bash
set -euo pipefail

# Required env vars:
# - ADO_PAT
# - ADO_ORG
# - ADO_PROJECT
# - ADO_REPO

MANIFEST_PATH="/manifest.json"
ENCODED_PATH=$(jq -rn --arg p "$MANIFEST_PATH" '$p|@uri')

# Add &$format=octetStream to get raw content
MANIFEST_URL="https://dev.azure.com/${ADO_ORG}/${ADO_PROJECT}/_apis/git/repositories/${ADO_REPO}/items?path=${ENCODED_PATH}&api-version=7.0&\$format=octetStream"

echo "🌐 Fetching manifest from ADO API:"
echo "$MANIFEST_URL"

response=$(curl -sS -u ":${ADO_PAT}" "$MANIFEST_URL")

if [ -z "$response" ]; then
  echo "❌ Failed to fetch manifest content"
  exit 1
fi

echo "✅ Manifest content:"
echo "$response" | jq
