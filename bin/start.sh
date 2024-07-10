#!/bin/bash

set -e

# Control de archivos [bash]
source "$(dirname "$0")/utils.sh"
source "$(dirname "$0")/config.sh"
source "$(dirname "$0")/validations.sh"
source "$(dirname "$0")/git.sh"


start() {
  execute_script "$@" # Ejecutar script [bash]
}

# Inicializar archivo [bash]
start "$@"