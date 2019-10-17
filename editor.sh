#! /bin/bash
pushd $1 > /dev/null
emacs -q -l ../misc/init.el & > /dev/null
