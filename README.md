# multipass-script

**script Zsh** personnalisable qui te permet de **lancer une VM Multipass** avec les paramètres suivants en ligne de commande :

* Version d'Ubuntu
* RAM
* Nombre de CPU
* Espace disque

---

### 📝 Script : `create_vm.zsh`

```zsh
#!/bin/zsh

# Vérifie les paramètres
if [[ $# -lt 4 ]]; then
  echo "Usage: $0 <ubuntu_version> <ram> <cpus> <disk> [vm_name]"
  echo "Exemple: $0 20.04 2G 2 20G (optionnel: nom_vm)"
  exit 1
fi

UBUNTU_VERSION=$1
RAM=$2
CPUS=$3
DISK=$4
NAME=$5

# Si aucun nom n'est fourni, on génère un nom
if [[ -z "$NAME" ]]; then
  VM_NAME="vm-${UBUNTU_VERSION//./}-$(date +%s)"
else
  VM_NAME="$NAME"
fi

echo "🚀 Lancement de la VM \"$VM_NAME\" avec Ubuntu $UBUNTU_VERSION"
echo "📦 RAM: $RAM | CPU: $CPUS | Disque: $DISK"

# Lancer la VM
multipass launch "$UBUNTU_VERSION" \
  --name "$VM_NAME" \
  --memory "$RAM" \
  --cpus "$CPUS" \
  --disk "$DISK"

# Vérifie que la VM a bien démarré
if [[ $? -eq 0 ]]; then
  echo "✅ VM \"$VM_NAME\" créée avec succès."
  multipass info "$VM_NAME"
  echo ""
  echo "💻 Pour vous connecter : multipass shell $VM_NAME"
else
  echo "❌ Erreur lors de la création de la VM."
fi

```

---

### ✅ Utilisation :

Rends le script exécutable :

```bash
chmod +x create_vm.zsh
```

Puis tu le lance :

```bash
./create_vm.zsh 20.04 2G 2 20G
```

---

### 📌 Remarques :

* La variable `VM_NAME` est automatiquement générée (`multipass-vm` par ex.).
* Tu peux ensuite te connecter avec :

  ```bash
  multipass shell nom-de-la-machine
  ```
