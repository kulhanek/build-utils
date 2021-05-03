#!/bin/bash

# ------------------------------------------------------------------------------
function dowload_code() {
    echo ""
    echo "# $2 -> $1"
    REPO=`echo $2 | cut -d '@' -f 1`
    SRV=`echo $2 | cut -d '@' -f 2`
    if [ "$SRV" == "ncbr" ]; then
       SRV="ncbr"
       URL="$SRV ${REPO}@git.ncbr.muni.cz:/local/gitrepos/${REPO}.git"
    else
       SRV="github"
       URL="$SRV https://github.com/kulhanek/${REPO}.git"
    fi
    echo "# -------------------------------------------"
    OLDPWD=$PWD
    mkdir -p $1 || exit 1
    cd $1 || exit 1
    if ! [ -d .git ]; then
        git init || exit 1
        echo "git remote add $URL"
        git remote add $URL || exit 1
    fi
    git pull $SRV master || exit 1
    if [ -x UpdateGitVersion ]; then
        ./UpdateGitVersion activate
    fi
    cd $OLDPWD
}

# ------------------------------------------------------------------------------

cat repositories | grep -v '^#' | while read A B; do
   dowload_code $A $B || exit 1
done

echo ""

