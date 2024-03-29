#!/bin/bash

export DEVELOPMENT_ROOT=$PWD/src

while [ $# -ne 0 ]; do
    case $1 in
        "-release") MODE="-DCMAKE_BUILD_TYPE=Release"
        ;;
        "-debug") MODE="-DCMAKE_BUILD_TYPE=Debug"
        ;;
        "-n")
            shift
            N=$1
        ;;
    esac
    shift
done

# ------------------------------------------------------------------------------
# add extra cmake options
if [ -f cmake.options ]; then
    while read ITEM; do
        MODE="$MODE $ITEM"
    done < cmake.options
fi

# add cmake from modules if they exist
if ! type cmake &> /dev/null; then
    if type module &> /dev/null; then
        module add cmake
    fi
fi

# ------------------------------------------------------------------------------
# run pre-installation hook if available
if [ -f ./preinstall-hook ]; then
    source ./preinstall-hook || exit 1
fi

# ------------------------------------------------------------------------------
# determine number of available CPUs if not specified
if [ -z "$N" ]; then
    N=1
    type nproc &> /dev/null
    if type nproc &> /dev/null; then
        N=`nproc --all`
    fi
fi

echo ""
echo ">>> Number of CPUs for building: $N"

# ------------------------------------------------------------------------------
function build_code() {
    echo ""
    echo "# $1 ($2)"
    echo "# -------------------------------------------" 
    OLDPWD=$PWD
    mkdir -p $1 || exit 1
    cd $1 || exit 1
    if [ -f CMakeLists.txt ]; then
        cmake --no-warn-unused-cli $MODE . || exit 1
        make -j$N || exit 1
    fi
    cd $OLDPWD
}
# ------------------------------------------------------------------------------

cat repositories | grep -v '^#' | while read A B C; do
   if [ -z "$2" ] || [ "$2" == "$B" ]; then 
      build_code $A $B || exit 1
   fi
done

echo ""
