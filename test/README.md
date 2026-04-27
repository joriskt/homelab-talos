

## VM maken

In proxmox:

- General:
  - Name: `k8s-test-...`
  - Resource Pool: `k8s-testing` 
- OS: standaard
- System:
  - Qemu Agent: yes
  - Bios: OVMF (UEFI)
  - Add TPM: yes
    - TPM Storage: ceph-vms
    - Version: v2.0
  - Add EFI disk: yes
    - EFI Storage: ceph-vms
    - Pre-Enroll keys: **no**

## Control nodes
- Disks:
    - Storage: ceph-vms
    - Disk size (GiB): 40
    - Discard: no
    - IO thread: yes
- CPU:
  - Sockets: 1
  - Cores: 3
- Memory: 4096
- Network:
  - Bridge: internet
(Finish)

- Add: Network Device
  - Bridge: k8stst
- Add: Network Device
  - Bridge: storage

## Worker nodes
- Disks:
    - Storage: ceph-vms
    - Disk size (GiB): 40
    - Discard: no
    - IO thread: yes
- CPU:
    - Sockets: 1
    - Cores: 3
- Memory: 4096
- Network:
    - Bridge: internet
      (Finish)

- Add: Network Device
    - Bridge: k8stst
- Add: Network Device
    - Bridge: storage

# VM starten

Bij het starten van de VM moet je als je het vergeten was eerst via de UEFI de pre-enrolled keys wipen.
De ISO installeert dan de keys wanneer je daar vanaf boot.

## Installeren

### Eerste control node
```bash
# .229 is hier het DHCP adres wat hij heeft gekregen.
talosctl apply-config --insecure --nodes 192.168.11.229 -f controlplane.yaml -p @node/control1.yaml
talosctl bootstrap -e 192.168.11.51 --nodes 192.168.11.51 --talosconfig talosconfig.yaml
 ```

### Overige control nodes
```bash
talosctl apply-config --insecure -e 192.168.11.XXX --nodes 192.168.11.XXX -f controlplane.yaml -p @node/control2.yaml --mode reboot --talosconfig talosconfig.yaml
talosctl apply-config --insecure -e 192.168.11.XXX --nodes 192.168.11.XXX -f controlplane.yaml -p @node/control3.yaml --mode reboot --talosconfig talosconfig.yaml
```

### Worker nodes
```bash
talosctl apply-config -e 192.168.11.XXX --nodes 192.168.11.XXX -f worker.yaml -p @node/worker1.yaml --mode reboot --talosconfig talosconfig.yaml
talosctl apply-config -e 192.168.11.XXX --nodes 192.168.11.XXX -f worker.yaml -p @node/worker2.yaml --mode reboot --talosconfig talosconfig.yaml
talosctl apply-config -e 192.168.11.XXX --nodes 192.168.11.XXX -f worker.yaml -p @node/worker3.yaml --mode reboot --talosconfig talosconfig.yaml
```

## Herinstalleren

Om te herinstalleren, boot naar de ISO, selecteer de tweede optie, "Reset server disk" of iets dergelijks.
