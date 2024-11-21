#! /usr/bin/env bash
set -Eeuo pipefail
echo "You can mount a shell script to /app/hook.sh to run whenever a cert is issued. bash/curl/wget/jq are installed.";

# # Sample script to reload nginx in another docker container.
# # This needs /var/run/docker.sock mounted.
# # Set the container name and command
# CONTAINER_NAME="nginx01"
# COMMAND="nginx -t && nginx -s reload"

# # Step 1: Get the container ID
# CONTAINER_ID=$(curl --unix-socket /var/run/docker.sock -s http://localhost/containers/json | \
#   jq -r --arg name "/$CONTAINER_NAME" '.[] | select(.Names[] == $name) | .Id')

# # Check if the container ID was found
# if [ -z "$CONTAINER_ID" ]; then
#   echo "Container with name $CONTAINER_NAME not found!"
#   exit 1
# fi

# echo "Found container ID: $CONTAINER_ID"

# # Step 2: Create an exec instance in the container
# EXEC_ID=$(curl --unix-socket /var/run/docker.sock -s -X POST \
#   -H "Content-Type: application/json" \
#   -d "{\"Cmd\": [\"/bin/sh\", \"-c\", \"$COMMAND\"], \"AttachStdout\": true, \"AttachStderr\": true}" \
#   http://localhost/containers/$CONTAINER_ID/exec | jq -r '.Id')

# # Check if the exec ID was created
# if [ -z "$EXEC_ID" ]; then
#   echo "Failed to create exec instance in container $CONTAINER_ID"
#   exit 1
# fi

# echo "Created exec instance ID: $EXEC_ID"

# # Step 3: Start the exec instance
# curl --unix-socket /var/run/docker.sock -s -X POST \
#   -H "Content-Type: application/json" \
#   -d '{"Detach": false, "Tty": false}' \
#   http://localhost/exec/$EXEC_ID/start
