#!/usr/bin/env bash
# Copyright (c) Ericsson AB 2020-2021. All rights reserved.
#
# The information in this document is the property of Ericsson.
#
# Except as specifically authorized in writing by Ericsson, the
# receiver of this document shall keep the information contained
# herein confidential and shall protect the same in whole or in
# part from disclosure and dissemination to third parties.
#
# Disclosure and disseminations to the receivers employees shall
# only be made on a strict need to know basis.
#

# Log level to number
# args:
#   log_level
_log_level_to_num(){
    case "$1" in
        debug) echo 1 ;;
        info)  echo 2 ;;
        error) echo 3 ;;
        *)     echo 0 ;;
    esac
}

declare -i _debug_to_num _info_to_num _error_to_num _log_level_to_num

_debug_to_num=$(_log_level_to_num "debug")
_info_to_num=$(_log_level_to_num "info")
_error_to_num=$(_log_level_to_num "error")
_undefined_num=$(_log_level_to_num "")

log_level=${LOG_LEVEL:="info"}
_log_level_to_num=$(_log_level_to_num "${log_level}")

# Info is default
(( _log_level_to_num != _undefined_num )) || { _log_level_to_num=_info_to_num ; log_level="info" ; }

_log(){
    if [[ -n "$1" ]]; then
        local log_level message
        log_level="$1"
        message="$2"
        formatted_log "${log_level}" "${message}"
    fi
}

log_debug(){
    if (( _log_level_to_num <= _debug_to_num )); then
        _log "debug" "$1"
    fi
}

log_info(){
    if (( _log_level_to_num <= _info_to_num )); then
        _log "info" "$1"
    fi
}

log_error(){
    if (( _log_level_to_num <= _error_to_num )); then
        _log "error" "$1"
    fi
}

get_utc_timestamp(){
    local date_fmt
    date_fmt="%Y-%m-%dT%H:%M:%S.%3NZ"
    date --utc +${date_fmt}
}

# Print log according to ADP log format.
# args:
#   severity
#   message
formatted_log(){
    local severity message service_id version timestamp fmtstring

    severity="$1"
    message="$2"
    service_id=${SERVICE_NAME:="not-set"}
    version="0.2.0"
    timestamp="$(get_utc_timestamp)"
    fmtstring="{\"version\": \"${version}\", \"timestamp\":\"${timestamp}\", \"severity\":\"${severity}\", \"service_id\":\"${service_id}\", \"message\":\"${message}\"}"

    printf -- "%s\n" "${fmtstring}" >&1
}
