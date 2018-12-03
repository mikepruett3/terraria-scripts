#!/usr/bin/env bash

Container="Terraria"
GameBackups="/data/game-backups/$Container/"
TimeStamp=$(date +"%m-%d-%Y_%H-%M-%S")
FileName="$Container_$TimeStamp.tar.gz"

docker run --rm --volumes-from ${Container} -v ${GameBackups}:/backup ubuntu tar cvf /backup/${FileName} /app/Worlds