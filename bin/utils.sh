#!/bin/bash

# Ejecutar programa
execute_script() {

  [[ -z "$1" ]] && info
#
  for ARGUMENT in "$@"; do
    KEY="${ARGUMENT%%=*}"
    VALUE="${ARGUMENT#*=}"

#    case "$KEY" in
#      -h|--help) info ;;
#      -t|--tag) VALUE_TAG="$PREFIX_VERSION$VALUE" ;;
#      -p|--push) VALUE_ONLY_PUSH="$VALUE" ;;
#      *) echo "Comando inválido" ;;
#    esac

  # VALIDAR LLAVE
    if [[ "$KEY" ]]; then
      if [[ "$KEY" == '-h' ]] || [[ "$KEY" == '--help' ]]; then
        info
      elif [[ "$KEY" == '-t' ]] || [[ "$KEY" == '--tag' ]]; then
        VALUE_TAG="$PREFIX_VERSION$VALUE"
      elif [[ "$KEY" == '-p' ]] || [[ "$KEY" == '--push' ]]; then
        VALUE_ONLY_PUSH="$VALUE"
      else
        info
      fi
    else
      info
    fi
  done

  process_git
}