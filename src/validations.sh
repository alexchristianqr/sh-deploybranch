#!/bin/bash

# Validar argumento tag
validate_error_arg_tag() {
  USE_TAG="$VALUE_USE_TAG"

  # Validar ejecución
  [[ "$USE_TAG" == "false" ]] && return 0 # Cortar función

  cat << EOF
[ COMANDOS CLI ]
-t, --tag ........................... Crea el tag especificado en local y remoto. Estructura recomendada: [Xmayor.Ymenor.Zbugfix]. Depedendecias en YAML: use_tag,auto_deleted_tag
-h, --help .......................... Ayuda
EOF
  exit 1
}

# Validar argumentos obligatorios
validate_args_required() {
  TAG="$VALUE_TAG"

  [[ -z "$TAG" ]] && validate_error_arg_tag
}