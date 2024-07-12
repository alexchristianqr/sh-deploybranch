#!/bin/bash

# Ejecutar programa
execute_script() {

  [[ -z "$1" ]] && info
#
  for ARGUMENT in "$@"; do
    KEY="${ARGUMENT%%=*}"
    VALUE="${ARGUMENT#*=}"

  # VALIDAR LLAVE
    if [[ "$KEY" ]]; then
      if [[ "$KEY" == '-h' ]] || [[ "$KEY" == '--help' ]]; then
        info
      elif [[ "$KEY" == '-t' ]] || [[ "$KEY" == '--tag' ]]; then
        VALUE_TAG="$PREFIX_VERSION$VALUE"
        shift
      elif [[ "$KEY" == '-p' ]] || [[ "$KEY" == '--push' ]]; then
        VALUE_ONLY_PUSH=true
      else
        printf "Mensaje de error: El comando ingresado no es válido \n\n"
        info
      fi
    else
      printf "Mensaje de error: El comando ingresado no es válido \n\n"
      info
    fi
  done

  process_git
}