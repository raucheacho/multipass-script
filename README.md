# ⚙️ `multipass-script`

**Script Zsh personnalisable** pour **créer facilement une VM Multipass** avec :

* Version d’Ubuntu
* Quantité de RAM
* Nombre de CPU
* Taille disque
* ✅ (NOUVEAU) Interface réseau (optionnelle)

---

## 📝 Script : `create_vm.zsh`

```zsh
#!/bin/zsh

# Vérifie les paramètres
if [[ $# -lt 4 ]]; then
  echo "Usage: $0 <ubuntu_version> <ram> <cpus> <disk> [vm_name] [network_interface]"
  echo "Exemple: $0 22.04 2G 2 20G (optionnel: nom_vm) (optionnel: interface réseau ex: en0)"
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
  echo "🌐 Interface réseau utilisée : $NETWORK_INTERFACE"
  LAUNCH_CMD+=("--network" "name=$NETWORK_INTERFACE")
fi

# Lancer la VM
echo "🚀 Lancement de la VM \"$VM_NAME\" avec Ubuntu $UBUNTU_VERSION"
echo "📦 RAM: $RAM | CPU: $CPUS | Disque: $DISK"

"${LAUNCH_CMD[@]}"

# Vérifie que la VM a bien démarré
if [[ $? -eq 0 ]]; then
  echo "✅ VM \"$VM_NAME\" créée avec succès."
  multipass info "$VM_NAME"
  echo ""
  echo "💻 Connexion : multipass shell $VM_NAME"
else
  echo "❌ Erreur lors de la création de la VM."
fi
```

---

## ✅ Utilisation

### 🔒 Rends le script exécutable :

```bash
chmod +x create_vm.zsh
```

### ▶️ Lance une VM avec les paramètres de base :

```bash
./create_vm.zsh 22.04 2G 2 20G
```

### 🌐 Lance une VM avec réseau bridgé (`en0` par exemple) :

```bash
./create_vm.zsh 22.04 2G 2 20G hestia-vm en0
```

---

## 📌 Remarques

* Le nom de la VM est généré automatiquement si tu ne le précises pas.

* Tu peux lister les interfaces disponibles avec :

  ```bash
  multipass networks
  ```

* Pour te connecter ensuite :

  ```bash
  multipass shell nom-vm
  ```

* Si tu utilises une interface réseau bridgée, tu peux accéder à la VM depuis n’importe quel appareil du réseau local (idéal pour tests web, etc.)
