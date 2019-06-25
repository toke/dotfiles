#!/usr/bin/env sh

set -e

: "${DIGEST_EXT:=SHA256}"
: "${SHASUM:=shasum}"
: "${SHA_ALGO:=256}"
: "${FLASHROM:=flashrom}"
: "${DMIDECODE:=dmidecode}"

[ $# -gt 0 ] && cmd=$1 && shift

for prg in "$FLASHROM" "$DMIDECODE" "$SHASUM" ; do
	if ! command -v "$prg" >/dev/null ; then
		echo "Error: $prg missing"
		exit 3
	fi
done

while [ $# -gt 0 ] && [ "$1" != "${1#-}" ] ; do
	case $1 in
	-f)
		force=1
		;;
	-y)
		assume_yes=1
		;;
	*)
		printf "Unknown flag %s\n" $1
		exit 1
		;;
	esac
	shift
done
[ $# -eq 1 ] && [ "$1" = "${1#-}" ] && file_name="$1" && shift

bios_version(){
	$DMIDECODE -s bios-version | sed -r 's/([v\.0-9\-_a-zA-Z]+)/\1/g'
}
digestfile_name(){
	basefile="${1:-$file_name}"
	printf "%s/%s.%s" "$(dirname $basefile)" "$(basename -s .rom $basefile)" "$DIGEST_EXT"
}

check_infile(){
	if [ -z "$file_name" ] || [ ! -e "$file_name" ] ; then
		printf 'File: "%s" not found\n' "$file_name"
		exit 2
	fi
}

check_digest(){
	if [ -e "$(digestfile_name)" ] ; then
		 "$SHASUM" -c "$(digestfile_name)" || exit 2
	else
		printf "Digest file not found, please check manually:\n"
		"$SHASUM" -a "$SHA_ALGO" "$file_name"
	fi
}

ask_user(){
	[ -n "$assume_yes" ] && return 0
	printf "%s [y/n]?" "$1"
	read response
	[ "$response" = "y" ] && return 0
	return 1
}

check_platform(){
	if [ "$($DMIDECODE -s bios-vendor)" != "coreboot" ] ; then
		echo "This script is made to run on coreboot machines."
		echo "Especially the APU2. This machine is unknown to me, exiting."
		exit 2
	fi
}

case $cmd in
	r|read)
		: "${file_name:=bios-`bios_version`-`date +%Y%m%d`.rom.bak}"
		check_platform
		if [ -z "$force" ] && [ -e "$file_name" ] ; then
			printf "Backup file %s already exists - aborting\n" $file_name
			exit 2
		fi

		printf "Backing up to: %s\n\n" "$file_name"
		$FLASHROM -r "$file_name" -p internal
	;;
	v|verify)
		check_platform
		check_infile
		check_digest
		$FLASHROM -v "$file_name" -p internal
	;;
	f|flash)
		check_platform
		check_infile
		check_digest
		$DMIDECODE -t bios
		if ask_user "Flash $file_name?" ; then
			$FLASHROM -w "$file_name" -p internal
		else
			echo "Aborting"
		fi
	;;
	i|info)
		$FLASHROM -R

		$DMIDECODE -t bios
		;;
	*)
		printf "Usage: %s <cmd> [flag...] [filename]\n" $0
		printf "Commands:\n"
		printf "\tread [-f] [filename]\t - writes flash to file (backup)\n"
		printf "\tverify <filename>\t - verify flash against file\n"
		printf "\tflash [-y] <filename>\t - flash file\n"
		printf "\tinfo\t\t\t - Prints firmware information\n"
		printf "Flags:\n"
		printf "\t-f\t - force\n"
		printf "\t-y\t - assume yes\n"
		exit 1
	;;
esac


