#!/bin/bash

process_directory() {
  local dir="$1"
  for file in "$dir"/*; do
    if [[ -f "$file" ]]; then
      if [[ "$(basename "$file")" == "metadata.xml" ]]; then
        rm "$file"
        pushd "$dir"
          haku digest
        popd
      fi
    elif [[ -d "$file" ]]; then
      process_directory "$file"
    fi
  done
}

process_directory "."
