#!/usr/bin/env bash
# safe-remove-container.sh
# Usage: ./safe-remove-container.sh <container-name>

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <container-name>"
    exit 1
fi

CONTAINER_NAME="$1"

# Step 1: Get container ID
CID=$(sudo docker ps -a --filter "name=^/${CONTAINER_NAME}$" --format "{{.ID}}")

if [[ -z "$CID" ]]; then
    echo "No container found with name: $CONTAINER_NAME"
    exit 1
fi

echo "[INFO] Found container ID: $CID"

# Step 2: Try normal force remove
echo "[STEP] Attempting 'docker rm -f'..."
if sudo docker rm -f "$CID"; then
    echo "[SUCCESS] Container removed."
    exit 0
else
    echo "[WARN] Normal force remove failed, escalating..."
fi

# Step 3: Kill process directly
PID=$(sudo docker inspect --format '{{.State.Pid}}' "$CID" || true)

if [[ -z "$PID" || "$PID" -eq 0 ]]; then
    echo "[ERROR] Could not retrieve container PID."
    exit 1
fi

echo "[STEP] Killing container process PID: $PID..."
if sudo kill -9 "$PID"; then
    echo "[INFO] Process killed. Trying to remove container again..."
    if sudo docker rm "$CID"; then
        echo "[SUCCESS] Container removed after killing process."
        exit 0
    else
        echo "[ERROR] Still unable to remove container."
        exit 1
    fi
else
    echo "[ERROR] Failed to kill process PID: $PID"
    exit 1
fi
