#!/bin/bash -e

function replace_config() {
    local _CONFIG_FILE="$1"
    local _REPLACE_CONFIG="$2"

    if [[ ! -f "$_CONFIG_FILE" ]]; then
        echo "Error: Config file not found: $_CONFIG_FILE" >&2
        return 1
    fi

    local -a _ARR_CONFIG=()
    local _current=""
    local _in_single_quote=0
    local _in_double_quote=0
    local _i _char

    for ((_i=0; _i<${#_REPLACE_CONFIG}; _i++)); do
        _char="${_REPLACE_CONFIG:_i:1}"

        case "$_char" in
            "'")
                if [[ $_in_double_quote -eq 0 ]]; then
                    _in_single_quote=$(( 1 - _in_single_quote ))
                fi
                _current+="$_char"
                ;;
            '"')
                if [[ $_in_single_quote -eq 0 ]]; then
                    _in_double_quote=$(( 1 - _in_double_quote ))
                fi
                _current+="$_char"
                ;;
            ',')
                if [[ $_in_single_quote -eq 0 && $_in_double_quote -eq 0 ]]; then
                    _ARR_CONFIG+=("$_current")
                    _current=""
                else
                    _current+="$_char"
                fi
                ;;
            *)
                _current+="$_char"
                ;;
        esac
    done

    if [[ -n "$_current" ]]; then
        _ARR_CONFIG+=("$_current")
    fi

    for _KEYVALUE in "${_ARR_CONFIG[@]}"; do
        if [[ ! "$_KEYVALUE" =~ ^[^=]+=[^=]*$ ]]; then
            echo "Error: Invalid key=value format: $_KEYVALUE" >&2
            return 1
        fi

        IFS='=' read -r _KEY_FULL _VALUE <<< "$_KEYVALUE"

        if [[ "$_KEY_FULL" == *.* ]]; then
            local _SECTION="${_KEY_FULL%%.*}"
            local _KEY="${_KEY_FULL#*.}"

            local _SECTION_START
            _SECTION_START=$(grep -n "^\\[${_SECTION}\\]" "$_CONFIG_FILE" | cut -d: -f1)
            if [[ -z "$_SECTION_START" ]]; then
                echo "Error: Section [$_SECTION] not found in $_CONFIG_FILE" >&2
                return 1
            fi

            local _SECTION_END
            _SECTION_END=$(tail -n +"$((_SECTION_START + 1))" "$_CONFIG_FILE" | grep -n "^\\[" | head -n 1 | cut -d: -f1)
            if [[ -n "$_SECTION_END" ]]; then
                _SECTION_END=$((_SECTION_START + _SECTION_END - 1))
            else
                _SECTION_END=$(wc -l < "$_CONFIG_FILE")
            fi

            if ! sed -i "${_SECTION_START},${_SECTION_END}s|^\\([[:space:]]*\\)#*[[:space:]]*\\(${_KEY}\\)[[:space:]]*=.*|\\1\\2=${_VALUE}|g" "$_CONFIG_FILE"; then
                echo "Error: Failed to update $_KEY in section [$_SECTION]" >&2
                return 1
            fi
        else
            echo "Error: Key must be specified as 'section.parameter' format: $_KEY_FULL" >&2
            return 1
        fi
    done
}

