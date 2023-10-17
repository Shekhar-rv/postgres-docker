currentver="$(docker compose version --short)"
requiredver="2.1.1"
echo "Checking for docker version... found: ${currentver}"

if [ "$(printf '%s\n' "$requiredver" "$currentver" | sort -V | head -n1)" = "$requiredver" ]; then
    echo "Docker Compose installed and is a version >= 2.1.1 - you're good!"
else
    echo "docker compose could not be found or the version is less than 2.1.1. we can't continue, please installed a recent version"
    echo "https://docs.docker.com/compose/compose-v2/ for more information"
    exit 1
fi

exit 0