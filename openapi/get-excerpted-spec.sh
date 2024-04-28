#!/bin/bash
# Download latest spec and remove bulky sections
# Requires yq

curl -s 'https://raw.githubusercontent.com/openai/openai-openapi/master/openapi.yaml' |
  yq 'del(.components, .security, .x-oaiMeta)' |
  yq 'del(.. | .python?) | del(.. | ."node.js"?) | del (.. | .node?) | del(.. | .response?)' > openapi.excerpt.yaml

echo "OpenAPI excerpt saved as openapi.excerpt.yaml"
