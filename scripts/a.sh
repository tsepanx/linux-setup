#!/bin/bash

echo $0, $1, $@
no_backups=$([[ $1 == "-nb" ]] && echo 1)
echo $([[ -n $no_backups ]] && echo 111)
