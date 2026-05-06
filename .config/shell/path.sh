path_prepend() {
	[ -d "$1" ] || return  # skip if directory doesn't exist
	case ":$PATH:" in
		*":$1:"*) ;;
		*) export PATH="$1:$PATH" ;;
	esac
}

path_append() {
	[ -d "$1" ] || return
	case ":$PATH:" in
		*":$1:"*) ;;
		*) export PATH="$PATH:$1" ;;
	esac
}

path_prepend "/home/daniel/.cargo/bin"
path_prepend "/home/daniel/.nimble/bin"
path_prepend "/home/daniel/.local/bin"
path_prepend "/home/daniel/.local/bin/scripts"
path_prepend "/home/daniel/git/busy.sh"
path_prepend "/home/daniel/.config/composer/vendor/bin"
path_prepend "/opt/nvim-linux64/bin"
path_prepend "/opt/resolve/bin"

# MCPELauncher crap
path_append "/home/daniel/git/others/mcpelauncher/build/mcpelauncher-client"
# MSA for MCPELauncher
path_append "/home/daniel/git/others/msa/build/msa-daemon"
# MCPELauncher UI QT 
path_append "/home/daniel/git/others/mcpelauncher-ui/build/mcpelauncher-ui-qt"
