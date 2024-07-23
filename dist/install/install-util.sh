#!/bin/bash -e

function replace_config() {
    _CONFIG_FILE=$1
    _REPLACE_CONFIG=$2

    _ARR_CONFIG=(${_REPLACE_CONFIG//,/ })

    for _KEYVALUE in "${_ARR_CONFIG[@]}"; do
        _ARR_KEYVALUE=(${_KEYVALUE//=/ })
        sed -i -e "s;\(#*\)\(${_ARR_KEYVALUE[0]}\)\s*=.*;\2=${_ARR_KEYVALUE[1]};g" ${_CONFIG_FILE}
    done
}

