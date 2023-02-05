#!/bin/bash

set -e

# VARIABLES LOCALES
KEY=''
VALUE=''
TAG=''
DIRECTORY=''
VALUE_TAG='0.0.0'
VALUE_DIRECTORY='dist'

# MOSTRAR MENSAJE DE ERROR DE ARGUMENTO TAG
error_arg_level() {
  echo "SOLUCION: Debes especificar un tag así: --tag=$VALUE"
  echo "NOTA: La estructura de un tag es [NivelMayor.NivelMenor.NivelBugfix]"
  exit 1
}

# MOSTRAR MENSAJE DE ERROR DE ARGUMENTO DIRECTORY
error_arg_directory() {
  echo "SOLUCION: Debes especificar un directorio así --dir=$VALUE // --directory=$VALUE"
  exit 1
}

# MOSTRAR MENSAJE DE ERROR GENERAL
error_args_general() {
  echo "SOLUCION:"
  echo "- Debes especificar un tag así: --tag=$VALUE_TAG"
  echo "  NOTA: La estructura de un tag es [NivelMayor.NivelMenor.NivelBugfix]"
  echo "- Debes especificar un directorio así: --dir=$VALUE_DIRECTORY // --directory=$VALUE_DIRECTORY"
  exit 1
}

# PROCESAR ARGUMENTOS
process_args() {
  if [ -z "$1" ]; then
    error_args_general
  fi

  # ITERAR ARGUMENTOS CLI
  for ARGUMENT in "$@"; do

    KEY=$(echo "$ARGUMENT" | cut -f1 -d=)

    # SET LLAVE Y VALOR
    KEY_LENGTH=${#KEY}
    VALUE="${ARGUMENT:$KEY_LENGTH+1}"

    # VALIDAR LLAVE
    echo ">>> $KEY"
    if [[ "$KEY" ]]; then
      if [[ "$KEY" == '--dir' ]] || [[ "$KEY" == '--directory' ]]; then

        VALUE_DIRECTORY="$VALUE"

      elif [[ "$KEY" == '--tag' ]]; then

        VALUE_TAG="$VALUE"

      else
        error_args_general
      fi
    else
      error_args_general
    fi

    echo "CORRECTO: $DIRECTORY"
  done

  # EJECUTAR ACTION IN GITHUB PAGES
  deploy_to_ghpages
}

# AGREGAR TAG
add_tag() {
  TAG="$VALUE_TAG"
  DIRECTORY="$VALUE_DIRECTORY"

  set -e

  #git tag -d "v$tagVersion"
  git tag -a -m "new tag release v$TAG" "v$TAG"
  git push origin "v$TAG"
}

# DESPLEGAR EN GITHUB PAGES
deploy_to_ghpages() {
  npm run build

  cd "$DIRECTORY"

  git init
  git add -A
  git commit -m "New deployment for release v$TAG"
  git push -f git@github.com:alexchristianqr/gmail-ionic-v3.git main:gh-pages

  cd -
}

# MENU PRINCIPAL
main() {
  process_args "$@"
}

# CONSTRUCTOR
main "$@"

#for ARGUMENT in "$@"
#do
#   KEY=$(echo "$ARGUMENT" | cut -f1 -d=)
#
#   KEY_LENGTH=${#KEY}
#   VALUE="${ARGUMENT:$KEY_LENGTH+1}"
#
#   export "$KEY"="$VALUE"
#done
#
## use here your expected variables
#echo "STEPS = $STEPS"
#echo "REPOSITORY_NAME = $REPOSITORY_NAME"
