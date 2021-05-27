#!/usr/bin/env bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
. $(dirname $SOURCE)/init.sh

workdir=$basedir/Paper/work
minecraftversion=$(cat $basedir/Paper/work/BuildData/info.json | grep minecraftVersion | cut -d '"' -f 4)
decompiledir=$workdir/Minecraft/$minecraftversion/forge
# replace for now
decompiledir="$workdir/Minecraft/$minecraftversion/spigot"

nms="net/minecraft"
export MODLOG=""
cd $basedir

function containsElement {
    local e
    for e in "${@:2}"; do
        [[ "$e" == "$1" ]] && return 0;
    done
    return 1
}

export importedmcdev=""
function import {
    if [ -f "$basedir/Paper/Paper-Server/src/main/java/$nms/$1.java" ]; then
        echo "ALREADY IMPORTED $1"
        return 0
    fi
    export importedmcdev="$importedmcdev $1"
    file="${1}.java"
    target="$basedir/Paper/Paper-Server/src/main/java/$nms/$file"
    base="$decompiledir/$nms/$file"

    if [[ ! -f "$target" ]]; then
        export MODLOG="$MODLOG  Imported $file from mc-dev\n";
        echo "$(bashColor 1 32) Copying $(bashColor 1 34)$base $(bashColor 1 32)to$(bashColor 1 34) $target $(bashColorReset)"
        mkdir -p "$(dirname "$target")"
        cp "$base" "$target"
    else
        echo "$(bashColor 1 33) UN-NEEDED IMPORT STATEMENT:$(bashColor 1 34) $file $(bashColorReset)"
    fi
}

(
    cd Paper/Paper-Server/
    lastlog=$(git log -1 --oneline)
    if [[ "$lastlog" = *"EMC-Extra mc-dev Imports"* ]]; then
        git reset --hard HEAD^
    fi
)


files=$(cat patches/server/* | grep "+++ b/src/main/java/net/minecraft/" | sort | uniq | sed 's/\+\+\+ b\/src\/main\/java\/net\/minecraft\///g')

nonnms=$(grep -R "new file mode" -B 1 "$basedir/patches/server/" | grep -v "new file mode" | grep -oE --color=none "net\/minecraft\/.*.java" | sed 's/.*\/net\/minecraft\///g')

for f in $files; do
    containsElement "$f" ${nonnms[@]}
    if [ "$?" == "1" ]; then
        if [ ! -f "$basedir/Paper/Paper-Server/src/main/java/net/minecraft/$f" ]; then
            f="$(echo "$f" | sed 's/.java//g')"
            if [ ! -f "$decompiledir/$nms/$f.java" ]; then
                echo "$(bashColor 1 31) ERROR!!! Missing NMS$(bashColor 1 34) $f $(bashColorReset)";
            else
                import $f
            fi
        fi
    fi
done

###############################################################################################
###############################################################################################
#################### ADD TEMPORARY ADDITIONS HERE #############################################
###############################################################################################
###############################################################################################

# import Foo

################
(
    cd Paper/Paper-Server/
    rm -rf nms-patches
    git add src -A
    echo -e "Origami-Extra mc-dev Imports\n\n$MODLOG" | git commit src -F -
)
