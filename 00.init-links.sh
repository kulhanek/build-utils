#!/bin/bash

for A in  01.pull-code.sh 02.push-code.sh 03.clean-all.sh 04.build-inline.sh 05.run-tests.sh 06.gen-runtime-paths.sh 08.git-status.sh; do
    ln -s "build-utils/$A" "$A"
done

