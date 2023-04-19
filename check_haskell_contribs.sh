#!/bin/bash -e

function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }

exceptions=(
	"dev-lang/ghc"
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
		relative="${DIR}"
		if [[ ! " ${exceptions[*]} " =~ " ${relative} " ]]; then
			portage="/home/gentoo-haskell/${relative}"
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
						if [ $(version ${versp}) -lt $(version ${vers}) ]; then
							echo "${relative}: ${versp} in portage, ${vers} in overlay!"
						fi
					fi
				done < <(find "$portage" -type f -not -path '*/\.*' -name '*.ebuild')
			else
				echo "${relative} is missing in portage"
			fi
		fi
	fi
done < <(find dev-haskell -type f -not -path '*/\.*' -name '*.ebuild')

