#!/bin/bash
sops -d -i secrets.yaml
sops -d -i controlplane.yaml
sops -d -i worker.yaml
