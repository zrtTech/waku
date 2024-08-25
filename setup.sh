#!/bin/bash
set -e

# Установка других необходимых пакетов
echo "Updating and upgrading system packages..."
sudo apt update && sudo apt upgrade -y

echo "Installing build-essential, git, libpq5, and jq..."
sudo apt-get install -y build-essential git libpq5 jq

echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

echo "Sourcing Cargo environment..."
. "$HOME/.cargo/env"

echo "Checking Rust version..."
rustc --version

echo "Sourcing Cargo environment..."
source "$HOME/.cargo/env"

echo "Checking Rust version..."
rustc --version

# Клонирование репозитория и работа с ним
echo "Cloning the nwaku-compose repository..."
git clone https://github.com/waku-org/nwaku-compose
cd nwaku-compose

echo "Copying environment example and opening for editing..."
cp .env.example .env
nano .env

echo "Registering RLN..."
./register_rln.sh

echo "Bringing up Docker containers..."
docker-compose up -d

echo "Fetching logs for nwaku..."
docker-compose logs nwaku

echo "Checking version from debug endpoint..."
curl --location 'http://127.0.0.1:8645/debug/v1/version'

echo "Fetching info from debug endpoint..."
curl --location 'http://127.0.0.1:8645/debug/v1/info'

echo "Setup complete!"
