#!/bin/bash

minikube_ip=$(minikube ip)

current=$(ps | sed -n -e 's/^.*[a]utossh -M 0 -R \([^:]*\).*$/\1/p' | sort)
echo "Current tunnels:"
echo "$current"

required=$(kubectl get ingress --all-namespaces -o jsonpath='{range ..host}{@}{"\n"}{end}' | sort)

create=$(comm -23 <(echo -n "$required") <(echo -n "$current"))
remove=$(comm -13 <(echo -n "$required") <(echo -n "$current"))

IFS=$'\n'
for host in $create; do
    echo "+ Creating tunnel for $host"
    autossh -M 0 -R ${host}:80:${minikube_ip}:80 serveo.net >>/tmp/serveo.log 2>&1 &
done

for host in $remove; do
    echo "- Removing tunnel for $host"
    pkill -9 -f "$host"
done
