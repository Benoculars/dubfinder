#!/bin/bash
progv=1
valid=()
rescan=false
sendalert=true
msg="new domains found"
mkdir -p dat
datafolder=dat

scand () {
	echo "finding subdomains of $1..."
	if [[ $rescan = true ]]; then
		newdiff=$(comm -13  <(sort $datafolder/$1.txt) <(sort <(echo "$(subfinder -silent -nW -d $1)")))
		if [[ $newdiff = *[!\ ]* ]]; then
			printf "$(tput setaf 4)$(tput setab 7)new domains found$(tput sgr 0)\n$newdiff\n"
			echo "$newdiff" >> $datafolder/$1.txt
			sed -ir '/^$/d' $datafolder/$1.txt
		fi
	else
		echo "$(subfinder -silent -nW -d $1)" > "$datafolder/$1.txt"
	fi
	length=$(wc -l < $datafolder/$1.txt)
	echo "scanning for hanging domains from $length subdomains..."
	while read -r p; do
		(( ++progv ))
		if ! [[ $p == "" ]]; then
			if [[ $(host $p) == *"NXDOMAIN"* ]] || [[ $(host $p) == *"SERVFAIL"* ]]; then
				dug=$(dig +short $p)
				if [[ $dug == *[!\ ]* ]]; then
					ab=${dug%?}
					var=$(expr $ab : '.*\.\(.*\..*\)')
					if $(whois $var | egrep --quiet '^No match|^NOT FOUND|^Not fo|AVAILABLE|^No Data Fou|has not been regi|No entri'); then
						valid+=("$(tput setaf 1)$(tput setab 7) $p $dug$(tput sgr 0)")
						msg="!!VULN!! $p $dug"
					else
						valid+=("$p $dug")
					fi
				fi
			fi
		fi
   done < $datafolder/$1.txt
if [[ $rescan = true ]]; then
	rm $1.txt
fi
git commit -a --quiet -m "$msg" 
git push --quiet
printf "%s\n" "${valid[@]}"
echo
}

if [ -f "$datafolder/$1.txt" ]; then
	rescan=true
	mod=$(date -r "dat/$1.txt")
	read -p "$1 has already been scanned $mod, do you want to rescan? [y/n] " -n 1 -r
	echo
	if [[ ! $REPLY =~ ^[Yy]$ ]]; then
		exit 1
	fi
	scand $1
else
scand $1
fi
