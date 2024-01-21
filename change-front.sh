#!/bin/bash

# Mevcut tarih ve zamanı al
current_date_time=$(date "+%Y-%m-%d %H:%M:%S")

# Git commit mesajını oluştur
commit_message="Juniflow Front-end şu tarihte güncellendi: $current_date_time"

# Git commit yap
git add .

set -x

git commit -m "$commit_message"

set -x

git push

set -x

cd ../juniflow-leo-dist

set -x

source ./generate.sh

sleep 300

set -x 

cd ..

set -x 

docker rmi -f juniflow.fe:latest

set -x

cd juniflow-leo-front

set -x 

docker build -t juniflow.fe:latest -f ./docker/Dockerfile .

set -x

cd ../juniflow-leo

set -x

exec docker-compose up -d $@