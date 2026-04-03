#!/usr/bin/env bash

set -e

# ── Colours & styles ──────────────────────────────────────────────────────────
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
RED='\033[0;31m'
WHITE='\033[1;37m'

# ── Helpers ───────────────────────────────────────────────────────────────────
step()    { echo -e "\n${CYAN}${BOLD}▶  $1${RESET}"; }
ok()      { echo -e "   ${GREEN}✔  $1${RESET}"; }
warn()    { echo -e "   ${YELLOW}⚠  $1${RESET}"; }
fatal()   { echo -e "\n   ${RED}${BOLD}✘  $1${RESET}\n"; exit 1; }
divider() { echo -e "${DIM}   ────────────────────────────────────────────${RESET}"; }
ts()      { date '+%H:%M:%S'; }

# ── Banner ────────────────────────────────────────────────────────────────────
echo -e ""
echo -e "${WHITE}${BOLD}  ╔══════════════════════════════════════╗${RESET}"
echo -e "${WHITE}${BOLD}  ║       uischemes  ·  deploy           ║${RESET}"
echo -e "${WHITE}${BOLD}  ╚══════════════════════════════════════╝${RESET}"
echo -e "${DIM}  Started at $(ts)${RESET}"
divider

# ── 1. Pull latest code ───────────────────────────────────────────────────────
step "Pulling latest code from origin/main"
git pull origin main
ok "Repository up to date"

# ── 2. Stop & remove existing container ──────────────────────────────────────
step "Stopping existing container"
if docker ps --format '{{.Names}}' | grep -q '^uischemes$'; then
  docker kill uischemes   > /dev/null
  docker container rm uischemes > /dev/null
  ok "Container stopped and removed"
else
  warn "No running container found — skipping"
fi

# ── 3. Build image ────────────────────────────────────────────────────────────
step "Building Docker image  ${DIM}(uis:latest)${RESET}"
docker build -t uis:latest --build-arg RAILS_MASTER_KEY="$(cat ../uischemes_master_key)" .
ok "Image built successfully"

# ── 4. Start container ────────────────────────────────────────────────────────
step "Starting new container"
docker run -d -p 32769:80 --name uischemes uis:latest > /dev/null
ok "Container started  ${DIM}→  http://localhost:32769${RESET}"

# ── Done ──────────────────────────────────────────────────────────────────────
divider
echo -e "\n  ${GREEN}${BOLD}🚀  Deployment complete${RESET}  ${DIM}($(ts))${RESET}\n"