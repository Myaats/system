#!/bin/sh

ROOT_DIR=$(dirname "$0")
BIN=$(basename "$0")

nixos_rebuild() {
    # Let the device be passed by env-var for flake
    DEVICE_ARG=""
    if [[ "$DEVICE" != "" ]]; then
        DEVICE_ARG="#$DEVICE"
    fi

    # Use remote sudo
    rebuild_args=("--use-remote-sudo")

    # Add a default flake argument if flake is not passed
    if [[ $(echo "$@" | grep -wo "\--flake") == "" ]]; then
        rebuild_args+=("--flake" "$ROOT_DIR$DEVICE_ARG")
    fi

    nixos-rebuild "${rebuild_args[@]}" "$@"
}

# Hold args, cmd to call and args to forward to cmd
args=("$@")
cmd=""
forward_args=()

# Check if there was no arguments or help was requsted
if [[ "${#args[@]}" -eq 0 || ("${#args[@]}" -eq 1 && ("${args[0]}" = "-h" || "${args[0]}" = "--help")) ]]; then
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
else
    for arg in "${args[@]}"; do
        # Check if no command was found
        if [[ $cmd = "" ]]; then
            # Parse subcommands
            case $arg in
                # Forward to nixos-rebuild
                "boot" | "build" | "dry-build" | "switch")
                    cmd="nixos_rebuild"
                    forward_args+=("$arg")
                    ;;
                # Format
                "format")
                    cmd="alejandra"
                    forward_args+=("$ROOT_DIR") # Automatically pass the root dir
                    ;;
                # Unknown command
                *)
                    # Check if it's a flag that should be forwarded
                    if [[ "$arg" =~ ^-.* ]]; then
                        forward_args+=($arg)
                    else
                        echo "Error: '$1' is not a valid subcommand." >&2
                        echo "       Run '$BIN --help' for a list of known subcommands." >&2
                        exit 1
                    fi
                    ;;
            esac
        # If a subcommand has already been found, just forward arguments
        else
            forward_args+=($arg)
        fi
    done

    # Default to nixos-rebuild if no cmd was specified
    if [[ $cmd = "" ]]; then
        cmd="nixos_rebuild"
    fi

    # Run the command
    $cmd "${forward_args[@]}"
fi
