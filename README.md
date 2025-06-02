# geth-prysm-k8s

This project sets up a Geth and Prysm Ethereum node using Docker Compose v2 on Ubuntu.

## Installation

### 1. Install Docker and Docker Compose v2
```bash
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo systemctl enable --now docker
sudo systemctl enable --now containerd
```

### 2. Add user to Docker group (optional)
```bash
sudo usermod -aG docker $USER
newgrp docker
```

### 3. Configure Zsh for Docker (optional)
```bash
cat >> ~/.zshrc << 'INNER_EOF'
# Docker completion
autoload -U compinit && compinit
source <(docker completion zsh)
INNER_EOF
source ~/.zshrc
```

## Usage

### 1. Generate JWT secret
```bash
chmod +x ./scripts/generate-jwt.sh
./scripts/generate-jwt.sh
```

### 2. Start services
```bash
docker compose up -d
```

### 3. Check service status
```bash
docker compose ps
```

### 4. Stop services
```bash
docker compose down
```

## Notes
- Uses `docker compose` v2 (not `docker-compose` v1)
- Ensure overlay2 storage driver is configured in `/etc/docker/daemon.json`:
  ```bash
  sudo mkdir -p /etc/docker
  echo '{
    "storage-driver": "overlay2"
  }' | sudo tee /etc/docker/daemon.json
  sudo systemctl restart docker
  ```
- Check Docker logs if encountering issues:
  ```bash
  sudo journalctl -u docker.service --no-pager
  sudo journalctl -u containerd --no-pager
  ```

## Troubleshooting

### Docker service fails
```bash
sudo mv /etc/containerd/config.toml /etc/containerd/config.toml.bak
sudo containerd config default > /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl restart docker
```

### Compose errors
```bash
docker compose config
```