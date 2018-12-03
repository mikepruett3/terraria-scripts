#!/usr/bin/env bash

# Top Variables
#Container="Terraria"

containers() {
    Containers=( $(docker container list --format '{{.Names}}') )
    printf '%s\n' "${Containers[@]}"
    echo ""
    read -p "Which Container? > " Container
    if [[ "$Container" != "${Containers[@]}" ]]; then
        echo "$Container not a valid Container!"
        exit 1
    fi
}

# Check Parameters
while [ "$1" != "" ]; do 
    case "$@" in
        -c )
            shift
            Container=$1
            echo "$Container"
            ;;
        -u )
            shift
            User=$2
            echo "$User"
            ;;
        -g )
            shift
            Group=$3
            echo "$Group"
            ;;
        *)
            User=$(id -u -n)
            Group=$(id -g -n)
            echo "$Container $User $Group"
            containers
    esac
done

# Lower Variables
GameBackups="/data/game-backups/$Container/"
TimeStamp=$(date +"%m-%d-%Y_%H-%M-%S")

# Create Backup of Volume
docker run --rm --volumes-from $Container -v $GameBackups:/backup ubuntu tar cvf "/backup/$Container-$TimeStamp.tar.gz" /app/Worlds

# Change Owner of Archive
sudo chown $User:$Group "$GameBackups/$Container-$TimeStamp.tar.gz"