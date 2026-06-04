#!/usr/bin/env bash
#
# Ruflo Installer (formerly Claude Flow)
# https://github.com/ruvnet/ruflo
#
# Usage:
#   curl -fsSL https://cdn.jsdelivr.net/gh/ruvnet/ruflo@main/scripts/install.sh | bash
#   curl -fsSL https://cdn.jsdelivr.net/gh/ruvnet/ruflo@main/scripts/install.sh | bash -s -- --full
#   curl -fsSL https://cdn.jsdelivr.net/gh/ruvnet/ruflo@main/scripts/install.sh | bash -s -- --global
#   curl -fsSL https://cdn.jsdelivr.net/gh/ruvnet/ruflo@main/scripts/install.sh | bash -s -- --minimal
#
# Options (via arguments):
#   --global              Global install (npm install -g)
#   --minimal             Minimal install (no optional deps)
#   --full                Full setup (global + MCP + doctor + init)
#   --version=X.X.X       Specific version
#
# Options (via environment - requires export):
#   export CLAUDE_FLOW_VERSION=alpha
#   export CLAUDE_FLOW_MINIMAL=1
#   export CLAUDE_FLOW_GLOBAL=1
#

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m' # No Color

# Default configuration (can be overridden by env vars)
VERSION="${RUFLO_VERSION:-${CLAUDE_FLOW_VERSION:-latest}}"
MINIMAL="${CLAUDE_FLOW_MINIMAL:-0}"
GLOBAL="${CLAUDE_FLOW_GLOBAL:-0}"
SETUP_MCP="${CLAUDE_FLOW_SETUP_MCP:-0}"
RUN_DOCTOR="${CLAUDE_FLOW_DOCTOR:-0}"
RUN_INIT="${CLAUDE_FLOW_INIT:-1}"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --global|-g)
            GLOBAL="1"
            shift
            ;;
        --minimal|-m)
            MINIMAL="1"
            shift
            ;;
        --setup-mcp|--mcp)
            SETUP_MCP="1"
            shift
            ;;
        --doctor|-d)
            RUN_DOCTOR="1"
            shift
            ;;
        --init|-i)
            RUN_INIT="1"
            shift
            ;;
        --no-init)
            RUN_INIT="0"
            shift
            ;;
        --full|-f)
            GLOBAL="1"
            SETUP_MCP="1"
            RUN_DOCTOR="1"
            RUN_INIT="1"
            shift
            ;;
        --version=*)
            VERSION="${1#*=}"
            shift
            ;;
        --help|-h)
            echo "Ruflo Installer"
            echo ""
            echo "Usage: curl -fsSL .../install.sh | bash -s -- [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --global, -g     Install globally (npm install -g ruflo)"
            echo "  --minimal, -m    Minimal install (skip optional deps)"
            echo "  --setup-mcp      Auto-configure MCP server for Claude Code"
            echo "  --doctor, -d     Run diagnostics after install"
            echo "  --no-init        Skip project initialization (enabled by default)"
            echo "  --full, -f       Full setup (global + mcp + doctor + init)"
            echo "  --version=X.X.X  Install specific version (default: alpha)"
            echo "  --help, -h       Show this help"
            exit 0
            ;;
        *)
            shift
            ;;
    esac
done

PACKAGE="ruflo@${VERSION}"

# Progress display
# Braille spinner frames kept as an array so multibyte UTF-8 glyphs are sliced
# safely regardless of the active locale (substring expansion on a packed
# string can split mid-character and print garbage).
SPINNER_FRAMES=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')

# Step counter for overall progress ("[2/5]"). Populated by compute_total_steps.
TOTAL_STEPS=0
CURRENT_STEP=0

compute_total_steps() {
    # Always run: requirements, install, verify.
    TOTAL_STEPS=3
    [ "$SETUP_MCP" = "1" ] && TOTAL_STEPS=$((TOTAL_STEPS + 1))
    [ "$RUN_DOCTOR" = "1" ] && TOTAL_STEPS=$((TOTAL_STEPS + 1))
    [ "$RUN_INIT" = "1" ] && TOTAL_STEPS=$((TOTAL_STEPS + 1))
    CURRENT_STEP=0
}

# Restore the cursor if the user interrupts mid-spinner.
_restore_cursor() {
    [ -t 1 ] && printf '\033[?25h' >&2 || true
}
trap _restore_cursor EXIT INT TERM

# Run a command while showing an animated progress spinner with elapsed time.
# Usage: run_with_spinner "Message" command [args...]
# - On a TTY: animates a spinner, then prints success/failure with duration.
# - Off a TTY (CI logs, redirected output): prints plain start/finish lines.
# Command output is captured and only shown (tail) if the command fails.
run_with_spinner() {
    local message="$1"
    shift

    local log_file
    log_file="$(mktemp 2>/dev/null || echo "/tmp/ruflo-install.$$.log")"

    local start_ts
    start_ts=$(date +%s)

    # Non-interactive: no animation, just bookend messages.
    if [ ! -t 1 ]; then
        print_substep "$message..."
        local status=0
        "$@" >"$log_file" 2>&1 || status=$?
        local total=$(( $(date +%s) - start_ts ))
        if [ "$status" -eq 0 ]; then
            print_success "$message (${total}s)"
        else
            print_error "$message failed after ${total}s"
            tail -n 20 "$log_file" >&2 2>/dev/null || true
        fi
        rm -f "$log_file"
        return "$status"
    fi

    # Interactive: run in background and animate until it finishes.
    "$@" >"$log_file" 2>&1 &
    local cmd_pid=$!

    local i=0
    printf '\033[?25l'  # hide cursor
    while kill -0 "$cmd_pid" 2>/dev/null; do
        local frame="${SPINNER_FRAMES[i]}"
        local elapsed=$(( $(date +%s) - start_ts ))
        printf "\r  ${CYAN}%s${NC} %s ${DIM}(%ds)${NC}\033[K" "$frame" "$message" "$elapsed"
        i=$(( (i + 1) % ${#SPINNER_FRAMES[@]} ))
        sleep 0.1
    done

    local status=0
    wait "$cmd_pid" || status=$?
    printf '\r\033[K\033[?25h'  # clear line, show cursor

    local total=$(( $(date +%s) - start_ts ))
    if [ "$status" -eq 0 ]; then
        print_success "$message ${DIM}(${total}s)${NC}"
    else
        print_error "$message failed after ${total}s"
        tail -n 20 "$log_file" >&2 2>/dev/null || true
    fi
    rm -f "$log_file"
    return "$status"
}

print_banner() {
    echo ""
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}Ruflo${NC} — AI Agent Orchestration for Claude Code     ${CYAN}║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_step() {
    CURRENT_STEP=$((CURRENT_STEP + 1))
    if [ "$TOTAL_STEPS" -gt 0 ]; then
        echo -e "${GREEN}▸${NC} ${DIM}[${CURRENT_STEP}/${TOTAL_STEPS}]${NC} $1"
    else
        echo -e "${GREEN}▸${NC} $1"
    fi
}

# Section header that does NOT advance the step counter.
print_header() {
    echo -e "${GREEN}▸${NC} $1"
}

print_substep() {
    echo -e "  ${DIM}├─${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

check_requirements() {
    print_step "Checking requirements..."

    # Check Node.js
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node -v | sed 's/v//')
        NODE_MAJOR=$(echo "$NODE_VERSION" | cut -d. -f1)
        if [ "$NODE_MAJOR" -ge 20 ]; then
            print_substep "Node.js ${GREEN}v${NODE_VERSION}${NC} ✓"
        else
            print_error "Node.js 20+ required (found v${NODE_VERSION})"
            echo ""
            echo "Install Node.js 20+:"
            echo "  curl -fsSL https://fnm.vercel.app/install | bash"
            echo "  fnm install 20"
            exit 1
        fi
    else
        print_error "Node.js not found"
        echo ""
        echo "Install Node.js 20+:"
        echo "  curl -fsSL https://fnm.vercel.app/install | bash"
        echo "  fnm install 20"
        exit 1
    fi

    # Check npm
    if command -v npm &> /dev/null; then
        NPM_VERSION=$(npm -v)
        print_substep "npm ${GREEN}v${NPM_VERSION}${NC} ✓"
    else
        print_error "npm not found"
        exit 1
    fi

    # Check Claude Code CLI
    if command -v claude &> /dev/null; then
        CLAUDE_VERSION=$(claude --version 2>/dev/null | head -1 || echo "installed")
        print_substep "Claude Code ${GREEN}${CLAUDE_VERSION}${NC} ✓"
    else
        print_warning "Claude Code CLI not found"
        print_substep "Installing Claude Code CLI via npm..."
        if npm install -g @anthropic-ai/claude-code 2>/dev/null; then
            if command -v claude &> /dev/null; then
                CLAUDE_VERSION=$(claude --version 2>/dev/null | head -1 || echo "installed")
                print_substep "Claude Code ${GREEN}${CLAUDE_VERSION}${NC} ✓"
            else
                print_substep "Installed. Restart terminal to use 'claude' command"
            fi
        else
            print_warning "npm install failed. Try manually:"
            print_substep "${BOLD}npm install -g @anthropic-ai/claude-code${NC}"
        fi
    fi

    echo ""
}

show_install_options() {
    print_header "Installation options:"
    print_substep "Package: ${BOLD}${PACKAGE}${NC}"
    if [ "$GLOBAL" = "1" ]; then
        print_substep "Mode: ${BOLD}Global${NC} (npm install -g)"
    else
        print_substep "Mode: ${BOLD}npx${NC} (on-demand)"
    fi
    if [ "$MINIMAL" = "1" ]; then
        print_substep "Profile: ${BOLD}Minimal${NC} (--omit=optional)"
    else
        print_substep "Profile: ${BOLD}Full${NC} (all features)"
    fi
    echo ""
}

install_package() {
    if [ "$GLOBAL" = "1" ]; then
        print_step "Installing globally..."
        if [ "$MINIMAL" = "1" ]; then
            run_with_spinner "Installing ${PACKAGE} (global, minimal)" \
                npm install -g "$PACKAGE" --omit=optional || return 1
        else
            run_with_spinner "Installing ${PACKAGE} (global)" \
                npm install -g "$PACKAGE" || return 1
        fi
    else
        print_step "Installing for npx usage..."
        # Pre-warm the npx cache so the first real invocation is instant.
        run_with_spinner "Caching ${PACKAGE} for npx" \
            npx -y "$PACKAGE" --version || \
            print_warning "Pre-cache step did not complete — npx will fetch on first run"
    fi

    echo ""
}

verify_installation() {
    print_step "Verifying installation..."

    local VERSION_OUTPUT
    if [ "$GLOBAL" = "1" ]; then
        VERSION_OUTPUT=$(ruflo --version 2>/dev/null || claude-flow --version 2>/dev/null || echo "")
        if [ -z "$VERSION_OUTPUT" ]; then
            print_warning "Global command not found in PATH"
            print_substep "Try: ${BOLD}npm install -g ruflo@${VERSION}${NC}"
            return 0  # Don't fail - npm might need PATH refresh
        fi
    else
        # For npx mode, package was already installed during install_package
        VERSION_OUTPUT=$(npx "$PACKAGE" --version 2>/dev/null || echo "")
    fi

    if [ -n "$VERSION_OUTPUT" ]; then
        print_substep "Version: ${GREEN}${VERSION_OUTPUT}${NC}"
        echo ""
        return 0
    else
        print_error "Installation verification failed"
        return 1
    fi
}

show_quickstart() {
    echo -e "${CYAN}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}Quick Start${NC}                                              ${CYAN}║${NC}"
    echo -e "${CYAN}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    if [ "$GLOBAL" = "1" ]; then
        echo -e "  ${DIM}# Interactive setup wizard${NC}"
        echo -e "  ${BOLD}ruflo init wizard${NC}"
        echo ""
        echo -e "  ${DIM}# Quick non-interactive init${NC}"
        echo -e "  ${BOLD}ruflo init${NC}"
        echo ""
        echo -e "  ${DIM}# Run system diagnostics${NC}"
        echo -e "  ${BOLD}ruflo doctor${NC}"
        echo ""
        echo -e "  ${DIM}# Add as MCP server to Claude Code${NC}"
        echo -e "  ${BOLD}claude mcp add ruflo -- ruflo mcp start${NC}"
    else
        echo -e "  ${DIM}# Interactive setup wizard${NC}"
        echo -e "  ${BOLD}npx ruflo@latest init wizard${NC}"
        echo ""
        echo -e "  ${DIM}# Quick non-interactive init${NC}"
        echo -e "  ${BOLD}npx ruflo@latest init${NC}"
        echo ""
        echo -e "  ${DIM}# Run system diagnostics${NC}"
        echo -e "  ${BOLD}npx ruflo@latest doctor${NC}"
        echo ""
        echo -e "  ${DIM}# Add as MCP server to Claude Code${NC}"
        echo -e "  ${BOLD}claude mcp add ruflo -- npx -y ruflo@latest mcp start${NC}"
    fi

    echo ""
    echo -e "${DIM}Documentation: https://github.com/ruvnet/ruflo${NC}"
    echo -e "${DIM}Issues: https://github.com/ruvnet/ruflo/issues${NC}"
    echo ""
}

setup_mcp_server() {
    if [ "$SETUP_MCP" != "1" ]; then
        return 0
    fi

    print_step "Setting up MCP server..."

    if ! command -v claude &> /dev/null; then
        print_warning "Claude CLI not found, skipping MCP setup"
        return 0
    fi

    # Check if already configured
    if claude mcp list 2>/dev/null | grep -q "ruflo\|claude-flow"; then
        print_substep "MCP server already configured ✓"
        return 0
    fi

    # Add MCP server (pass CLAUDE_FLOW_CWD so tools resolve paths correctly
    # even when the MCP server is spawned with cwd='/')
    if [ "$GLOBAL" = "1" ]; then
        claude mcp add ruflo -e CLAUDE_FLOW_CWD="$HOME" -- ruflo mcp start 2>/dev/null && \
            print_substep "MCP server configured ✓" || \
            print_warning "MCP setup failed - run manually: claude mcp add ruflo -e CLAUDE_FLOW_CWD=\"\$HOME\" -- ruflo mcp start"
    else
        claude mcp add ruflo -e CLAUDE_FLOW_CWD="$HOME" -- npx -y ruflo@${VERSION} mcp start 2>/dev/null && \
            print_substep "MCP server configured ✓" || \
            print_warning "MCP setup failed - run manually: claude mcp add ruflo -e CLAUDE_FLOW_CWD=\"\$HOME\" -- npx -y ruflo@latest mcp start"
    fi
    echo ""
}

run_doctor() {
    if [ "$RUN_DOCTOR" != "1" ]; then
        return 0
    fi

    print_step "Running diagnostics..."
    echo ""

    if [ "$GLOBAL" = "1" ]; then
        ruflo doctor 2>&1 || true
    else
        npx ruflo@${VERSION} doctor 2>&1 || true
    fi
    echo ""
}

run_init() {
    if [ "$RUN_INIT" != "1" ]; then
        return 0
    fi

    print_step "Initializing project..."
    echo ""

    if [ "$GLOBAL" = "1" ]; then
        ruflo init 2>&1 || true
    else
        npx ruflo@${VERSION} init 2>&1 || true
    fi
    echo ""
}

# Main
main() {
    compute_total_steps
    print_banner
    check_requirements
    show_install_options
    install_package
    verify_installation
    setup_mcp_server
    run_doctor
    run_init
    show_quickstart

    print_success "${BOLD}Ruflo is ready!${NC}"
    echo ""
}

main "$@"
