#!/usr/bin/env bash
set -euo pipefail

SKILL_DIR="${HOME}/.claude/skills/user"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_SRC="${SCRIPT_DIR}/skills"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

usage() {
  echo "Usage: bash install.sh [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  (none)            Install all skills (skip existing)"
  echo "  --update          Force update all skills"
  echo "  --install-one     Install a single skill by name"
  echo "  --list            List installed skills"
  echo "  --help            Show this message"
  echo ""
  echo "Examples:"
  echo "  bash install.sh"
  echo "  bash install.sh --update"
  echo "  bash install.sh --install-one session-handoff"
}

list_skills() {
  echo -e "${CYAN}Installed skills in ${SKILL_DIR}:${NC}"
  if [ -d "$SKILL_DIR" ]; then
    for d in "$SKILL_DIR"/*/; do
      [ -d "$d" ] && echo "  • $(basename "$d")"
    done
  else
    echo "  (none)"
  fi
}

install_skill() {
  local name=$1
  local src="${SKILLS_SRC}/${name}"
  local dst="${SKILL_DIR}/${name}"

  if [ ! -d "$src" ]; then
    echo "❌  skill '$name' not found in ${SKILLS_SRC}"
    return 1
  fi

  if [ -d "$dst" ]; then
    echo -e "${YELLOW}⚠️  ${name} already exists, skipping (use --update to overwrite)${NC}"
    return
  fi

  cp -r "$src" "$dst"
  echo -e "${GREEN}✅  ${name} installed${NC}"
}

update_skill() {
  local name=$1
  local src="${SKILLS_SRC}/${name}"
  local dst="${SKILL_DIR}/${name}"

  if [ ! -d "$src" ]; then
    echo "❌  skill '$name' not found in ${SKILLS_SRC}"
    return 1
  fi

  rm -rf "$dst"
  cp -r "$src" "$dst"
  echo -e "${GREEN}🔄  ${name} updated${NC}"
}

mkdir -p "$SKILL_DIR"

MODE="${1:---install}"

case "$MODE" in
  --install)
    echo -e "${CYAN}Installing all skills...${NC}"
    for skill_dir in "${SKILLS_SRC}"/*/; do
      install_skill "$(basename "$skill_dir")"
    done
    echo ""
    list_skills
    ;;
  --update)
    echo -e "${CYAN}Updating all skills...${NC}"
    for skill_dir in "${SKILLS_SRC}"/*/; do
      update_skill "$(basename "$skill_dir")"
    done
    echo ""
    list_skills
    ;;
  --install-one)
    if [ -z "${2:-}" ]; then
      echo "❌  Please provide a skill name: bash install.sh --install-one <name>"
      exit 1
    fi
    install_skill "$2"
    ;;
  --list)
    list_skills
    ;;
  --help)
    usage
    ;;
  *)
    echo "❌  Unknown option: $MODE"
    usage
    exit 1
    ;;
esac
