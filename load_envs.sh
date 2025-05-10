#!/bin/bash

# Folder containing .env files (adjust this path)
ENV_FOLDER="./var"

echo "Loading environment variables from .env files in $ENV_FOLDER..."


for env_file in "$ENV_FOLDER"/*.env; do
    if [ -f "$env_file" ]; then
        echo " → Processing $env_file"
        while IFS='=' read -r key value; do
            # Ignore lines starting with # or empty lines
            if [[ ! "$key" =~ ^# && -n "$key" ]]; then
                export "$key"="$value"
                eval echo "Loaded "$key" with \$$key"
            fi
        done < <(grep -v '^#' "$env_file" | sed '/^\s*$/d')
    fi
done

echo "Loading of environment variables completed."