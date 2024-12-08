#!/bin/bash
set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo "Starting Auto Install Nodes Multiple Network"
sleep 5

ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    CLIENT_URL="https://cdn.app.multiple.cc/client/linux/x64/multipleforlinux.tar"
elif [[ "$ARCH" == "aarch64" ]]; then
    CLIENT_URL="https://cdn.app.multiple.cc/client/linux/arm64/multipleforlinux.tar"
else
    echo -e "${RED}Unsupported architecture: $ARCH${NC}"
    exit 1
fi

echo -e "${GREEN}Downloading client from $CLIENT_URL...${NC}"
wget $CLIENT_URL -O multipleforlinux.tar

echo -e "${GREEN}Extracting installation package...${NC}"
tar -xvf multipleforlinux.tar

cd multipleforlinux

echo -e "${GREEN}Setting required permissions...${NC}"
chmod +x multiple-cli
chmod +x multiple-node

echo -e "${GREEN}Configuring PATH...${NC}"
echo "PATH=\$PATH:$(pwd)" >> ~/.bashrc
source ~/.bashrc


echo -e "${GREEN}Setting permissions for the directory...${NC}"
chmod -R 777 .


read -p "Enter your IDENTIFIER: " IDENTIFIER
read -p "Enter your PIN: " PIN


echo -e "${GREEN}Running the program...${NC}"
nohup ./multiple-node > output.log 2>&1 &


echo -e "${GREEN}Binding account with identifier and PIN...${NC}"
./multiple-cli bind --bandwidth-download 1000 --identifier "$IDENTIFIER" --pin "$PIN" --storage 200 --bandwidth-upload 1000

echo -e "${GREEN}Process completed.${NC}"


echo -e "${YELLOW}You can perform other operations if necessary. Use the --help option to view specific commands for logs.${NC}"
