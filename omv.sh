# Install the openmediavault keyring
apt-get install --yes gnupg
wget --quiet --output-document=- https://packages.openmediavault.org/public/archive.key | gpg --dearmor | tee "/etc/apt/trusted.gpg.d/openmediavault-archive-keyring.gpg"

# Add the package repositories
cat <<EOF > /etc/apt/sources.list.d/openmediavault.list
deb https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/public shaitan main
deb https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/packages shaitan main
## Uncomment the following line to add software from the proposed repository.
# deb https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/public shaitan-proposed main
# deb https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/packages shaitan-proposed main
## This software is not part of OpenMediaVault, but is offered by third-party
## developers as a service to OpenMediaVault users.
# deb https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/public shaitan partner
# deb https://mirrors.tuna.tsinghua.edu.cn/OpenMediaVault/packages shaitan partner
EOF

# Install the openmediavault package
export LANG=C.UTF-8
export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none
apt-get update
apt-get --yes --auto-remove --show-upgraded \
    --allow-downgrades --allow-change-held-packages \
    --no-install-recommends \
    --option DPkg::Options::="--force-confdef" \
    --option DPkg::Options::="--force-confold" \
    install openmediavault-keyring openmediavault

# Populate the openmediavault database with several existing system settings, e.g. the network configuration
omv-confdbadm populate

# Re-deploy the network configuration via the services used by openmediavault
omv-salt deploy run systemd-networkd