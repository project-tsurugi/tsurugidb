#!/bin/bash

export GLOG_logtostderr=1

get_config_content() {
  local config_file="$TSURUGI_HOME/var/etc/tsurugi.ini"

  if [[ ! -f "$config_file" ]]; then
    echo "Error: Config file not found: $config_file" >&2
    exit 1
  fi

  cat "$config_file"
}

get_config_value() {
  local section_param="$1"
  local default_value="$2"

  if [[ ! "$section_param" == *.* ]]; then
    echo "Error: Invalid format '$section_param'. Expected 'section.parameter'" >&2
    exit 1
  fi

  local section="${section_param%%.*}"
  local param="${section_param#*.}"

  local in_target_section=0
  local param_value=""

  while IFS= read -r line; do
    if [[ "$line" =~ ^\[[[:space:]]*([^]]+)[[:space:]]*\]$ ]]; then
      local current_section="${BASH_REMATCH[1]}"
      if [[ "$current_section" == "$section" ]]; then
        in_target_section=1
      else
        in_target_section=0
      fi
    elif [[ $in_target_section -eq 1 ]]; then
      if [[ "$line" =~ ^[[:space:]]*${param}[[:space:]]*=[[:space:]]*(.+)$ ]]; then
        param_value="${BASH_REMATCH[1]}"
        break
      fi
    fi
  done < <(get_config_content)

  echo "${param_value:-$default_value}"
}

start() {
  local -r MAX_AUTH_RETRIES=10
  local -r AUTH_RETRY_INTERVAL=1
  local -r DEFAULT_AUTH_URL="http://localhost:8080/harinoki"

  cd ${TSURUGI_HOME} || exit
  cat BUILDINFO.md

  if [[ "$(get_config_value "authentication.enabled" "false")" == "true" ]]; then
    echo 'starting authentication-server...'
    ./bin/authentication-server start

    local auth_url
    auth_url=$(get_config_value "authentication.url" "$DEFAULT_AUTH_URL")

    echo "Waiting for authentication-server to be ready at $auth_url/hello..."
    local retry_count=0

    while [[ $retry_count -lt $MAX_AUTH_RETRIES ]]; do
      if curl -s --max-time 2 --connect-timeout 2 -o /dev/null -w "%{http_code}" "$auth_url/hello" 2>/dev/null | grep -q "^200$"; then
        echo "Authentication-server is ready"
        break
      fi

      retry_count=$((retry_count + 1))
      echo "Authentication-server not ready (attempt $retry_count/$MAX_AUTH_RETRIES), retrying in $AUTH_RETRY_INTERVAL second..."
      sleep $AUTH_RETRY_INTERVAL
    done

    if [[ $retry_count -eq $MAX_AUTH_RETRIES ]]; then
      echo "Error: Authentication-server failed to start after $MAX_AUTH_RETRIES attempts" >&2
      exit 1
    fi
  else
    echo 'authentication is disabled, skipping authentication-server startup...'
  fi

  echo 'starting tsurugi...'
  ./bin/tgctl start ${TG_OPTS}
}

handle_term() {
  cd ${TSURUGI_HOME} || exit

  if [[ "$(get_config_value "authentication.enabled" "false")" == "true" ]]; then
    echo 'stopping authentication-server...'
    ./bin/authentication-server stop
  fi

  if [[ "${TSURUGI_TGCTL_STOP_COMMAND}" != "kill" ]]; then
    TSURUGI_TGCTL_STOP_COMMAND="shutdown"
  fi

  echo "stopping tsurugi with ${TSURUGI_TGCTL_STOP_COMMAND}..."
  ./bin/tgctl "${TSURUGI_TGCTL_STOP_COMMAND}"
  _RET=$?

  exit ${_RET}
}
trap handle_term TERM

start
while :
do
  sleep 1
done
