#! /bin/zsh
monoRepo="${1:-}"
if [[ -z "$monoRepo" ]]; then
  echo "Please add the repository that contains all java projects"
  exit 1;
fi

rg -U -I -t java import "$monoRepo" > ~/.import.lib
no_dup_data=$(awk '!a[$0]++' ~/.import.lib)
echo $no_dup_data | sed 's/import //g' > ~/.import.lib

echo "Sync import done"
