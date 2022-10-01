#!/bin/sh

ROOT_DIR=$(dirname $0)
BIN=$(basename $0)

nixos_rebuild() {
    if [[ "$DEVICE" = "" ]]; then
        nixos-rebuild --use-remote-sudo --flake "$ROOT_DIR" $@
    else
	    nixos-rebuild --use-remote-sudo --flake "$ROOT_DIR#$DEVICE" $@
    fi
}

# Parse subcommands
case $1 in
    # Help command
    "" | "-h" | "--help")
        echo "Usage: $BIN <subcommand> [options]"
        echo "Subcommands:"
        echo "    boot        Build generation and add to bootloader"
        echo "    build       Build the system"
        echo "    dry-build   Run a dry build for the system"
        echo "    format      Format all nix expressions"
        echo "    switch      Build and switch to generation"
        echo ""
        echo "For help with each subcommand run:"
        echo "$BIN <subcommand> -h|--help"
        echo ""
        ;;
    # Forward to nixos-rebuild
    "boot" | "build" | "dry-build" | "switch")
        nixos_rebuild $@
        ;;
    # Format
    "format")
        alejandra $ROOT_DIR
        ;;
    # Unknown command
    *)
        echo "Error: '$1' is not a valid subcommand." >&2
        echo "       Run '$BIN --help' for a list of known subcommands." >&2
        exit 1
esac
