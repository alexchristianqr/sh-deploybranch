#!/bin/bash

# Eliminar tag
remove_tag() {
  AUTO_DELETED_TAG="$VALUE_AUTO_DELETED_TAG"

  # Validar ejecución
  [[ "$AUTO_DELETED_TAG" == 'false' ]] && return 0 # Cortar función

  TAG="$VALUE_TAG"

  git push --delete origin "$TAG" # Eliminar en remoto
  echo "[MESSAGE_CLI] Eliminando en remoto... tag: $TAG"
  git tag -d "$TAG" # Eliminar en local
  echo "[MESSAGE_CLI] Eliminando en local... tag: $TAG"
}

# Agregar o eliminar tag
add_remove_tag() {
  USE_TAG="$VALUE_USE_TAG"

  # Validar ejecución
  [[ "$USE_TAG" == 'false' ]] && return 0 # Cortar función

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

# Subir tag previamente creado al servidor remoto
push_tag() {
  ONLY_PUSH="$VALUE_ONLY_PUSH"

  # Validar ejecución
  [[ "$ONLY_PUSH" == 'true' ]] && return 0 # Cortar función

  TAG="$VALUE_TAG"

  # Validar ejecución
  [[ "$USE_TAG" == 'false' ]] && return 0 # Cortar función

  git push origin "$TAG"
}

# Ejecutar comandos de comppilación del proyecto
execute_builder_command() {
  USE_EXEC="$VALUE_USE_EXEC"

  # Validar ejecución
  [[ "$USE_EXEC" == 'false' ]] && return 0 # Cortar función

  IFS=',' read -ra COMMANDS <<< "$EXEC" # Ejecutar múltiples comandos

  for cmd in "${COMMANDS[@]}"; do
    trimmed_cmd=$(echo "$cmd" | xargs) # Recortar espacios en blanco
    eval "$trimmed_cmd"
  done
}

# Desplegar rama
deploy_branch() {
  TAG="$VALUE_TAG"
  EXEC="$VALUE_EXEC"
  DIRECTORY="$VALUE_DIRECTORY"
  REPOSITORY="$VALUE_REPOSITORY"
  BRANCH_LOCAL="$VALUE_BRANCH_LOCAL"
  BRANCH_REMOTE="$VALUE_BRANCH_REMOTE"

  push_tag # Subir tag remoto
  execute_builder_command # Ejecutar comando de compilación

#  cd "$DIRECTORY"
#  git init
  git add -A
  git commit -m "New deployment for release $TAG"
  git push -f "git@github.com:$REPOSITORY.git" "$BRANCH_LOCAL:$BRANCH_REMOTO"
  cd -

#  rm -rf "$DIRECTORY"
}

# Inicializar operaciones con git
process_git() {
  ONLY_PUSH="$VALUE_ONLY_PUSH"

  # Validar ejecución
  if [[ "$ONLY_PUSH" == 'false' ]]; then
    validate_args_required # Validar argumentos obligatorios
    add_remove_tag # Crear o remover tag
    deploy_branch # Ejecutar despliegue de branch
  else
    deploy_branch # Ejecutar despliegue de branch
  fi
}
