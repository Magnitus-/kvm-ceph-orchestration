if command -v nerdctl >/dev/null 2>&1; then
    export COMMAND="nerdctl compose"
elif command -v docker-compose >/dev/null 2>&1; then
    export COMMAND="docker-compose"
else
    echo "Neither docker-compose nor nerdctl is found in the PATH"
    exit 1;
fi

bash -c "$COMMAND run ansible"