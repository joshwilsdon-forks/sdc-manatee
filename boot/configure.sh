#!/bin/bash
# -*- mode: shell-script; fill-column: 80; -*-
#
# Copyright (c) 2014 Joyent Inc., All rights reserved.
#

export PS4='[\D{%FT%TZ}] ${BASH_SOURCE}:${LINENO}: ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
set -o xtrace


# For SDC we want to check if we should enable or disable the sitter on each boot.
svccfg import /opt/smartdc/manatee/smf/manifests/sitter.xml
disableSitter=$(json disableSitter < /opt/smartdc/manatee/etc/sitter.json)
if [[ -n ${disableSitter} && ${disableSitter} == "true" ]]; then
    # HEAD-1327 we want to be able to disable the sitter on the 2nd manatee we
    # create as part of the dance required to go from 1 -> 2+ nodes. This should
    # only ever be set for the 2nd manatee.
    echo "Disabing sitter per /opt/smartdc/manatee/etc/sitter.json"
    svcadm disable manatee-sitter
else
    echo "Starting sitter"
    svcadm enable manatee-sitter
fi


exit 0
