#!/usr/bin/env bash

declare -r day=$(date +"%d")
declare -r month=$(date +"%m")
declare -r year=$(date +"%Y")

for i in 01 02 03 04; do
	rsync -avz --delete sysmaint@advideohd${i}.uimserv.net:/var/log/sysstat /tmp/advideohd${i}
	./sar_graph.sh /tmp/advideohd${i}/sysstat/sa${day} ~/public_html/advideohd/${year}/${month}/${day}/advideohd${i}
done



