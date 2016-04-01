#
# Helper for allowing only aliases to existing commands
# Similar to [ -e /usr/bin/translate-shell ] && alias abc="/usr/bin/abc"
#
function bin_alias {
	aliasname="$1"
	aliascontent="$2"

  if [[ -z "$aliasname" && -z $aliascontent ]] ; then
    echo "Call $0 alias-name alias-value"
    echo "Sets alias only if alias-value is a known command (see man 1 command)"
    exit 1
  else
    command -v "$aliascontent" > /dev/null && \
    		alias $aliasname="$aliascontent"
  fi
}
