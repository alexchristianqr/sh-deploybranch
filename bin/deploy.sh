#!/bin/bash

set -e

# VARIABLES LOCALES
KEY=''
VALUE=''
LASTTAG=''

# Valores por defecto
VALUE_TAG=''
VALUE_DIRECTORY='dist'
VALUE_EXEC='build'
VALUE_REPOSITORY='alexchristianqr/portfolio'
VALUE_DELETED_TAG='true'
PREFIX_VERSION='v'
VALUE_BRANCH_LOCAL='main'
VALUE_BRANCH_REMOTO='gh-pages'

# VARIABLES PARA USAR EN LA EJECUCION
TAG=''
DIRECTORY=''
BRANCH_LOCAL=''
BRANCH_REMOTO=''
EXEC=''
REPOSITORY=''

# Mostrar mensaje de error de argumento tag
error_arg_tag() {
  echo "[ OBLIGATORIO ]"
  echo "-t=$VALUE_TAG, --tag=$VALUE_TAG ........................... Estructura de un tag [X_mayor.Y_menor.Z_bugfix]"
  exit 1
}

# Mostrar mensaje de error general
error_args_general() {
cat << EOF
[ COMANDOS CLI ]
-t, --tag ........................... Estructura de un tag [X_mayor.Y_menor.Z_bugfix]
-dt, --deleted-lasttag .............. Eliminar último tag registrado
-b, --branch ........................ Rama git
--exec .............................. Comando de compilación
-o, --out-dir ....................... Carpeta de compilación
--repository ........................ Repositorio git
-gp, --github-pages ................. Utilizar github pages

[ DOCUMENTACION ]
Repositorio GitHub: https://github.com/alexchristianqr/npm-deploy-branch

[ AUTOR ]
Usuario: Alex Christian
Email: alexchristianqr@gmail.com
GitHub: https://github.com/alexchristianqr
EOF
  exit 1
}

# Eliminar tag
remove_tag() {
  TAG="$VALUE_TAG"

  git push --delete origin "$TAG" # Eliminar en remoto
  echo "[MESSAGE_CLI] Eliminando en remoto... tag: $TAG"
  git tag -d "$TAG" # Eliminar en local
  echo "[MESSAGE_CLI] Eliminando en local... tag: $TAG"
}

# Agregar o eliminar tag
add_remove_tag() {
  TAG="$VALUE_TAG"

  LATEST_TAG=$(git ls-remote --tags origin | grep -v '\^{}' | sort -t '/' -k 3 -V | tail -n 1 | awk '{print $2}' | sed 's|refs/tags/||')
  echo "[MESSAGE_CLI] Exite en remoto, tag: $LATEST_TAG"

  if [[ "$TAG" == "$LATEST_TAG" ]]; then
    echo "[MESSAGE_CLI] Existe en local, tag: $TAG"
    VALUE_TAG="$LATEST_TAG"
    remove_tag
    add_remove_tag
  else
    VALUE_TAG="$TAG"
    git tag -a -m "New tag release $TAG" "$TAG" # Crear en local
    echo "[MESSAGE_CLI] Creado en local... tag: $TAG"
    git push origin "$TAG" # Crear en remoto
    echo "[MESSAGE_CLI] Creado en remoto... tag: $TAG"
  fi
}

# Desplegar en GitHub
deploy_to_github() {
  TAG="$VALUE_TAG"
  EXEC="$VALUE_EXEC"
  DIRECTORY="$VALUE_DIRECTORY"
  REPOSITORY="$VALUE_REPOSITORY"
  BRANCH_LOCAL="$VALUE_BRANCH_LOCAL"
  BRANCH_REMOTO="$VALUE_BRANCH_REMOTO"

  git push origin "$TAG"

  npm run "$EXEC"

  cd "$DIRECTORY"
  git init
  git add -A
  git commit -m "New deployment for release $TAG"
  git push -f "git@github.com:$REPOSITORY.git" "$BRANCH_LOCAL:$BRANCH_REMOTO"
  cd -

  rm -rf "$DIRECTORY"
}

# Validar valores de los argumentos obligatorios
validate_values_args() {
  TAG="$VALUE_TAG"

  [[ -z "$TAG" ]] && error_arg_tag
}

# Procesar argumentos
process_args() {
  [[ -z "$1" ]] && error_args_general

  for ARGUMENT in "$@"; do
    KEY="${ARGUMENT%%=*}"
    VALUE="${ARGUMENT#*=}"

    case "$KEY" in
      -h|--help) error_args_general ;;
      -t|--tag) VALUE_TAG="$PREFIX_VERSION$VALUE" ;;
      -o|--out-dir|--out-directory) VALUE_DIRECTORY="$VALUE" ;;
      -b|--branch) VALUE_BRANCH_LOCAL="$VALUE" ;;
      --exec) VALUE_EXEC="$VALUE" ;;
      --repository) VALUE_REPOSITORY="$VALUE" ;;
      -dt|--deleted-lasttag) VALUE_DELETED_TAG="$VALUE" ;;
      *) error_args_general ;;
    esac
  done

  validate_values_args # Validar parametros obligatorios
  add_remove_tag # Crear tag
  deploy_to_github # Ejecutar despliegue
}

# Menu principal
main() {
  process_args "$@"
}

# Constructor
main "$@"