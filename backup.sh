#!/usr/bin/env bash

# Function to prompt for Container
containers() {
    Containers=( $(docker container list --format '{{.Names}}') )
    echo "Listing Containers:"
    echo ""
    printf '%s\n' "${Containers[@]}"
    echo ""
    read -p "Which Container? > " Container
    if [[ "$Container" != "${Containers[@]}" ]]; then
        echo "$Container not a valid Container!"
        exit 1
    fi
}

# Check Parameters
while [ "$#" -gt 0 ]; do 
    case "$1" in
        -c)
            shift;
            Container=$1;
            ;;
        -u)
            shift;
            User=$1;
            ;;
        -g)
            shift;
            Group=$1;
            ;;
        *)  ;;
    esac
    shift
done

echo "$#"
if [ "$#" -eq 0 ]; then
    User=$(id -u -n)
    Group=$(id -g -n)
    containers
fi

# Lower Variables
GameBackups="/data/game-backups/$Container/"
TimeStamp=$(date +"%m-%d-%Y_%H-%M-%S")

# Create Backup of Volume
docker run --rm --volumes-from $Container -v $GameBackups:/backup ubuntu tar cvf "/backup/$Container-$TimeStamp.tar.gz" /app/Worlds

# Change Owner of Archive
sudo chown $User:$Group "$GameBackups/$Container-$TimeStamp.tar.gz"