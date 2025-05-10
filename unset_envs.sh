#!/bin/bash

# Folder containing .env files
ENV_FOLDER="./var"

echo "Unsetting environment variables from .env files in $ENV_FOLDER..."

for env_file in "$ENV_FOLDER"/*.env; do
    if [ -f "$env_file" ]; then
        echo " → Processing $env_file"
        while IFS='=' read -r key value; do
            # Ignore lines starting with # or empty lines
            if [[ ! "$key" =~ ^# && -n "$key" ]]; then
                unset "$key"
                echo "Unset: $key"
            fi
        done < <(grep -v '^#' "$env_file" | sed '/^\s*$/d')
    fi
done

echo ""
echo "✅ Done unsetting variables."