#!/bin/bash -e

digest() {
	local e=$1
	if [[ $e == *.ebuild ]]
	then
		ebuild "$e" digest
	fi
}

copyright_year() {
    local e=$1
    echo 'FIX "# Copyright" in: '"$e"
    sed -e 's/^# Copyright .*/# Copyright 1999-2022 Gentoo Authors/g' -i "${e}"
    digest "$e"
}

legacy_header() {
    local e=$1
    echo 'FIX "# $Header:" in: '"$e"
    sed -e 's/^# \$Header: .*\$$/# $Id$/g' -i "${e}"
    digest "$e"
}

while read e; do
    while read l
    do
        if [[ $l == '# Copyright 1999-'* ]]; then
            copyright_year "$e"
        fi
        if [[ $l == '# $Header:'* ]]; then
            legacy_header "$e"
            break
        fi
    done < "$e"
done < <(find . -type f -not -path '*/\.*')
