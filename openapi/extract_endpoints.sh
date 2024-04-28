#!/bin/bash
# Script to extract each path as a separate YAML file.
# Requires yq

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <input_yaml_file>"
    exit 1
fi

input_file="$1"

if [ ! -f "$input_file" ]; then
    echo "Error: File '$input_file' not found!"
    exit 1
fi

output_directory="endpoints"
mkdir -p "$output_directory"

paths=$(yq e '.paths | keys | .[]' "$input_file")

for path in $paths; do
    yq e ".paths |= pick([\"$path\"])" "$input_file" > "${output_directory}/$(echo $path | sed 's/\//_/g').yaml"
done

echo "Generated YAML files for each path in the '$output_directory' directory."
