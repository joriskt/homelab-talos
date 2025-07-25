# homelab-talos

Alle configuratie en beheer handleidingen van mijn TalosOS kubernetes nodes.

Momenteel heb ik twee clusters:

- `k8s-staging` met diensten op `*.staging.joris.me` en interne IP range `192.168.11.0/24`
- `k8s-production` met diensten op `*.prod.joris.me` en interne IP range `192.168.12.0/24`
    - Gebruik loopt normaliter via CNAME records in de vorm `\<dienst\>.joris.me` => `\<dienst\>.prod.joris.me`

## Images genereren

Voordat je TalosOS virtuele- of bare-metal nodes gaat installeren is het **zeer wenselijk** om zelf een image te bouwen op de [Talos Linux Image Factory](https://factory.talos.dev/).

Voor clusters heb ik de volgende images:

- `k8s-staging`: Bare-metal, amd64, SecureBoot OFF, extensies: `siderolabs/qemu-guest-agent`.
- `k8s-production`: Bare-metal, amd64, SecureBoot ON, extensies: `siderolabs/qemu-guest-agent`.

Hier kan je ISOs van downloaden, maar **je moet ook in de machine config de installer image updaten** onder `machine: install: image:`. (Dit was ik bij staging vergeten, dus die hebben nu allemaal geen QEMU guest agent..)

## Configuratie genereren

Configuratie genereren:

```bash
# Genereer secrets.yaml:
$ talosctl gen secrets

# Genereer worker.yaml, controlplane.yaml en talosconfig:
$ talosctl gen config \
    joris-acc \ # Naam van cluster
    https://192.168.11.50:6443 \ # HA controlplane endpoint
    --with-secrets secrets.yaml
```

## Configuratie toepassen

Vervolgens kan je Talos installeren op een node die in de Talos ISO geboot is:

```bash
$ talosctl apply-config --insecure --nodes 192.168.11.xxx -f controlplane.yml -p @network.yaml -p @node/ctl1.yaml
```

TODO afmaken :)