#!/usr/bin/env bash

set -e

if [ -f ../server/paper.jar ]; then
  echo "paper.jar found, skipping server setup..."
  exit 0
fi

if [ "$1" = "1.12" ] || [ -z "$1" ]; then
  echo "installing paper 1.12.2 (1618)"
  PAPER_URL=https://papermc.io/api/v1/paper/1.12.2/1618/download
  PAPER_MD5=4c81838696da39b1b06987e81ca8b0af
elif [ "$1" = "1.13" ]; then
  echo "installing paper 1.13.2 (655)"
  PAPER_URL=https://papermc.io/api/v1/paper/1.13.2/655/download
  PAPER_MD5=0e4136328c43a3719b614beca6c3259c
elif [ "$1" = "1.14" ]; then
  echo "installing paper 1.14.4 (243)"
  PAPER_URL=https://papermc.io/api/v1/paper/1.14.4/243/download
  PAPER_MD5=8be71db025e6a14c86b4f096e543d6e8
elif [ "$1" = "1.15" ]; then
  echo "installing paper 1.15.2 (391)"
  PAPER_URL=https://papermc.io/api/v1/paper/1.15.2/391/download
  PAPER_MD5=3d7aa76694cad3140da1ba136a350264
elif [ "$1" = "1.16" ]; then
  echo "installing paper 1.16.5 (463)"
  PAPER_URL=https://papermc.io/api/v1/paper/1.16.5/463/download
  PAPER_MD5=ae676ce11c66fa5c09bc517cf68f4a23
else
  echo "unknown paper version!"
  exit 1
fi

cd "$(dirname "${BASH_SOURCE[0]}")"
mkdir -p ../server
cd ../server

curl "$PAPER_URL" -o paper.jar

if md5sum -c <<<"$PAPER_MD5 paper.jar" | grep -q "paper.jar: OK"; then
  echo "download successful"
else
  echo "download failed"
  exit 1
fi

if [ -z "$MC_EULA" ]; then
  echo "Press Y or set MC_EULA to agree with Mojangs EULA: https://account.mojang.com/documents/minecraft_eula"
  read -p "" -n 1 -r
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

echo "eula=true" >./eula.txt

mkdir -p ./plugins/bStats

{
  echo "motd=some test server"
  echo "online-mode=false"
  echo "spawn-protection=0"
  echo "enable-command-block=true"
} >./server.properties

{
  echo "enabled: false"
  echo "serverUuid: 00000000-0000-0000-0000-000000000000"
  echo "logFailedRequests: false"
} >./plugins/bStats/config.yml

echo "server installation complete"
