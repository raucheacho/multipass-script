#!/bin/zsh

# Vérifie les paramètres
if [[ $# -lt 4 ]]; then
  echo "Usage: $0 <ubuntu_version> <ram> <cpus> <disk> [vm_name] [network_interface]"
  echo "Exemple: $0 20.04 2G 2 20G (optionnel: nom_vm) (optionnel: interface réseau ex: en0)"
  exit 1
fi

UBUNTU_VERSION=$1
RAM=$2
CPUS=$3
DISK=$4
NAME=$5
NETWORK_INTERFACE=$6

# Si aucun nom n'est fourni, on génère un nom
if [[ -z "$NAME" ]]; then
  VM_NAME="vm-${UBUNTU_VERSION//./}-$(date +%s)"
else
  VM_NAME="$NAME"
fi

# Préparation de la commande multipass
LAUNCH_CMD=("multipass" "launch" "$UBUNTU_VERSION" "--name" "$VM_NAME" "--memory" "$RAM" "--cpus" "$CPUS" "--disk" "$DISK")

# Ajout du réseau si précisé
if [[ -n "$NETWORK_INTERFACE" ]]; then
  echo "🌐 Utilisation de l'interface réseau: $NETWORK_INTERFACE"
  LAUNCH_CMD+=("--network" "name=$NETWORK_INTERFACE")
fi

# Affichage
echo "🚀 Lancement de la VM \"$VM_NAME\" avec Ubuntu $UBUNTU_VERSION"
echo "📦 RAM: $RAM | CPU: $CPUS | Disque: $DISK"

# Exécute la commande
"${LAUNCH_CMD[@]}"

# Vérifie que la VM a bien démarré
if [[ $? -eq 0 ]]; then
  echo "✅ VM \"$VM_NAME\" créée avec succès."
  multipass info "$VM_NAME"
  echo ""
  echo "💻 Pour vous connecter : multipass shell $VM_NAME"
else
  echo "❌ Erreur lors de la création de la VM."
fi
