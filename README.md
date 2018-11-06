# Jenkins X on Minikube

This repo contains a couple of scripts to set up and run Jenkins X in prow mode on Minikube using serveo to tunnel webhooks from GitHub.

## Prereqs

* A bot user on GitHub (`demo-bot` in my case)
* A domain name with wildcard support (`*.serveo.currie.cloud` in my case)

The DNS records for the domain name should be configured as per the [serveo docs](https://serveo.net/#manual) i.e. with an A record for the wildcard pointing at `159.89.214.31` and a TXT record of the form `authkeyfp=<ssh-fingerprint>`.

Update the `jx-minikube.sh` script with your bot's GitHub username and your domain name. The script uses `hyperkit` as the VM driver by default. You will also need to update this if you do not have the [hyperkit driver installed](https://github.com/kubernetes/minikube/blob/master/docs/drivers.md#hyperkit-driver).

## Usage

Execute `jx-minikube.sh` to create the minikube VM with Jenkins X installed in prow mode. The script then runs `watch -n 10 ./serveo.sh` to set up a serveo tunnel for each ingress. The script needs to run continuously to create tunnels for new preview environments and promoted applications. 