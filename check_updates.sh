#!/bin/bash -e

function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }

exceptions=(
	"dev-util/boost-build"
	"dev-libs/boost"
	"net-vpn/protonvpn-cli"
	"gnome-base/gnome-core-apps"
	"app-editors/vscode"
	"sci-libs/vtk"
)

while read e; do
	DIR="$(dirname "${e}")";
	FILE="$(basename "${e}")";
	vers=${FILE##*-};
	if [[ $vers == r* ]]; then
		vers=${FILE%-*}
		vers=${vers##*-};
	fi
	vers=${vers%.ebuild*};
	if [[ "$vers" != "9999" ]]; then
		relative="${DIR:2}"
		if [[ ! " ${exceptions[*]} " =~ " ${relative} " ]]; then
			portage="/data2/portage/${relative}"
			if [ -d "$portage" ]; then
				while read p; do
					FILEP="$(basename "${p}")";
					versp=${FILEP##*-};
					if [[ $versp == r* ]]; then
						versp=${FILEP%-*}
						versp=${versp##*-};
					fi
					versp=${versp%.ebuild*};
					if [[ "$versp" != "9999" ]]; then
						if [ $(version ${versp}) -gt $(version ${vers}) ]; then
							echo "${relative}: ${versp} in portage, ${vers} in overlay!"
						fi
					fi
				done < <(find "$portage" -type f -not -path '*/\.*' -name '*.ebuild')
			fi
		fi
	fi
done < <(find . -type f -not -path '*/\.*' -name '*.ebuild')

for d in */ ; do
	if [ -z "$(ls -A $d)" ]; then
		echo "$d category is empty"
	fi
done
