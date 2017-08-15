#!/bin/bash

# ------------------------------------------------------------------------------
function push_code() {
    echo ""
    echo "# $2 -> $1"
    SRV=`echo $2 | cut -d '@' -f 2`
    if [ "$SRV" == "ncbr" ]; then
       SRV="ncbr"
    else
       SRV="github"
    fi
    echo "# -------------------------------------------" 
    OLDPWD=$PWD
    cd $1 || exit 1
    git push $SRV master || exit 1
    cd $OLDPWD 
}

# ------------------------------------------------------------------------------

echo ""
if [ -f repositories.push ]; then
    echo "Using: repositories.push ..."
    cat repositories.push | grep -v '^#' | while read A B; do
    push_code $A $B || exit 1
    done
else
    echo "Using: repositories ..."
    cat repositories | grep -v '^#' | while read A B; do
    push_code $A $B || exit 1
    done
fi

echo ""

