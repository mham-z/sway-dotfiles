#!/bin/bash

HOSTNAME=$(cat /proc/sys/kernel/hostname)
RESET="\033[0m"
GREEN="\033[32m"
BLUE="\033[34m"
YELLOW="\033[33m"

echo -e "Targeting '${HOSTNAME}'\n"

echo -e "    ${GREEN}Stowing 'base' profile...${BLUE}"
stow -v -t ~ base 2>&1 | sed "s/^/       /"
echo -e "${RESET}"

if [ -d "$HOSTNAME" ]; then
    echo -e "    ${GREEN}Stowing [${HOSTNAME}]...${BLUE}"
    stow -v -t ~ "$HOSTNAME" 2>&1 | sed "s/^/          /"
else
    echo -e "    ${YELLOW}[!] Profile '${HOSTNAME}' not found.${RESET}"
    echo -e "    ${GREEN}Stowing 'fallback'...${BLUE}"
    stow -v -t ~ fallback 2>&1 | sed "s/^/       /"
fi

echo -e "\n${RESET}Complete!"