#!/bin/bash
sops -e -i secrets.yaml
sops -e -i controlplane.yaml
sops -e -i worker.yaml
