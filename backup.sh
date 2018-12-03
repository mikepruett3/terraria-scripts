#!/usr/bin/env bash

# Top Variables
#Container="Terraria"

# Check Parameters
while getopts c:u:g: option; do
    case "${option}" in
        c )
            shift
            Container=$1
            ;;
        u )
            shift
            User=$2
            ;;
        g )
            shift
            Group=$3
            ;;
        * )
            User=$(id -u -n)
            Group=$(id -g -n)
            Containers=( $(docker container list --format '{{.Names}}') )
            printf '%s\n' "${Containers[@]}"
            echo ""
            read -p "Which Container? > " Container
            if [[ "$Container" != "${Containers[@]}" ]]; then
                echo "$Container not a valid Container!"
                exit 1
            fi
            echo "$Container $User $Group"
    esac
    shift
done

#containers() {
#    Containers=( $(docker container list --format '{{.Names}}') )
#    printf '%s\n' "${Containers[@]}"
#    echo ""
#    read -p "Which Container? > " Container
#    if [[ "$Container" != "${Containers[@]}" ]]; then
#        echo "$Container not a valid Container!"
#        exit 1
#    fi
#}

# Lower Variables
GameBackups="/data/game-backups/$Container/"
TimeStamp=$(date +"%m-%d-%Y_%H-%M-%S")

# Create Backup of Volume
docker run --rm --volumes-from $Container -v $GameBackups:/backup ubuntu tar cvf "/backup/$Container-$TimeStamp.tar.gz" /app/Worlds

# Change Owner of Archive
sudo chown $User:$Group "$GameBackups/$Container-$TimeStamp.tar.gz"