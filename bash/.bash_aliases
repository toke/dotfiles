#
# Helper for allowing only aliases to existing commands
# Similar to [ -e /usr/bin/translate-shell ] && alias abc="/usr/bin/abc"
#
function bin_alias {
	aliasname="$1"
	aliascontent="$2"
	
	command -v "$aliascontent" > /dev/null && \
		alias $aliasname="$aliascontent"
}

### Aliases following

bin_alias vi "/usr/bin/vim"
bin_alias pw "/usr/bin/pwsafe"
bin_alias translate "/usr/bin/translate-shell"
