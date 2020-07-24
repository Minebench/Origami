#!/usr/bin/env bash
(
set -e
PS1="$"

function changelog() {
    base=$(git ls-tree HEAD $1  | cut -d' ' -f3 | cut -f1)
    cd $1 && git log --oneline ${base}...HEAD
}
changes=$(changelog Paper)

updated=""
logsuffix=""
if [ ! -z "$changes" ]; then
    if [ -z "$updated" ]; then updated="Paper"; else updated="$updated/Paper"; fi
fi
disclaimer=""

if [ ! -z "$1" ]; then
    disclaimer="$@"
fi

log="${UP_LOG_PREFIX}Update $updated\n\n${disclaimer}${logsuffix}${changes}"

echo -e "$log" | git commit -F -

) || exit 1