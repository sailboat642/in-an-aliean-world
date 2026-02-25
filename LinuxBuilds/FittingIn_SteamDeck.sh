#!/bin/sh
printf '\033c\033]0;%s\a' InAnAlienWorld
base_path="$(dirname "$(realpath "$0")")"
"$base_path/FittingIn_SteamDeck.x86_64" "$@"
