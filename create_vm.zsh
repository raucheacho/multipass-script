#!/bin/zsh

# Vérifie les paramètres
if [[ $# -ne 4 ]]; then
  echo "Usage: $0 <ubuntu_version> <ram> <cpus> <disk>"
  echo "Exemple: $0 20.04 2G 2 20G"
  exit 1
fi

UBUNTU_VERSION=$1
RAM=$2
CPUS=$3
DISK=$4

# Nom de la VM basé sur la version
VM_NAME="cyberpanel-vm-${UBUNTU_VERSION//./}"

echo "🚀 Lancement de la VM $VM_NAME avec Ubuntu $UBUNTU_VERSION"
echo "📦 RAM: $RAM | CPU: $CPUS | Disque: $DISK"

# Lancer la VM
multipass launch "$UBUNTU_VERSION" \
  --name "$VM_NAME" \
  --mem "$RAM" \
  --cpus "$CPUS" \
  --disk "$DISK"

# Afficher les infos de la VM
multipass info "$VM_NAME"

