#!/bin/bash

set -e

# Archivo de configuración por defecto
DEFAULT_FILE="deploybranch.yaml"

# Valores por defecto
DEFAULT_USE_EXEC="true"
DEFAULT_EXEC="npm run build"
DEFAULT_USE_TAG="true"
DEFAULT_AUTO_DELETED_TAG="true"
DEFAULT_ONLY_PUSH="false"

# Comprobar si el archivo de configuración existe
if [ ! -f "$DEFAULT_FILE" ]; then
  echo "Advertencia: El archivo de configuración $DEFAULT_FILE no existe. Usando valores por defecto."
fi

# Función para leer y validar valores booleanos desde un archivo YAML
only_boolean() {
  local key=$1
  local value=$2

  if [[ "$value" != "true" && "$value" != "false" ]]; then
    echo "Error: El valor de $key debe ser 'true' o 'false'."
    exit 1
  fi
}

# Función para extraer valores del YAML
extract_value() {
  local key=$1
  if [ -f "$DEFAULT_FILE" ]; then
    awk -F ": " "/^$key:/ {print \$2}" "$DEFAULT_FILE"
  fi
}

# Verificar si los valores requeridos están presentes
REQUIRED_FIELDS=("directory" "repository" "branch_local" "branch_remote")
for field in "${REQUIRED_FIELDS[@]}"; do
  value=$(extract_value "$field")
  if [ -z "$value" ]; then
    echo "Error: El campo requerido '$field' no está presente en el archivo $DEFAULT_FILE."
    exit 1
  fi
done

# Leer valores por defecto desde el archivo YAML o usar valores predefinidos
FILE_VALUE_USE_EXEC=$(extract_value "use_exec")
FILE_VALUE_USE_TAG=$(extract_value "use_tag")
FILE_VALUE_AUTO_DELETED_TAG=$(extract_value "auto_deleted_tag")
FILE_VALUE_EXEC=$(extract_value "exec")
FILE_VALUE_DIRECTORY=$(extract_value "directory") # Campo obligatorio
FILE_VALUE_REPOSITORY=$(extract_value "repository") # Campo obligatorio
FILE_VALUE_BRANCH_LOCAL=$(extract_value "branch_local") # Campo obligatorio
FILE_VALUE_BRANCH_REMOTE=$(extract_value "branch_remote") # Campo obligatorio

# Asignar valores por defecto si no se encuentran en el YAML
VALUE_USE_EXEC=${FILE_VALUE_USE_EXEC:-$DEFAULT_USE_EXEC} && only_boolean "use_exec" "$VALUE_USE_EXEC"
VALUE_EXEC=${FILE_VALUE_EXEC:-$DEFAULT_EXEC}
VALUE_USE_TAG=${FILE_VALUE_USE_TAG:-$DEFAULT_USE_TAG} && only_boolean "use_tag" "$VALUE_USE_TAG"
VALUE_AUTO_DELETED_TAG=${FILE_VALUE_AUTO_DELETED_TAG:-$DEFAULT_AUTO_DELETED_TAG} && only_boolean "auto_deleted_tag" "$VALUE_AUTO_DELETED_TAG"
VALUE_REPOSITORY=${FILE_VALUE_REPOSITORY}
VALUE_DIRECTORY=${FILE_VALUE_DIRECTORY}
VALUE_BRANCH_LOCAL=${FILE_VALUE_BRANCH_LOCAL}
VALUE_BRANCH_REMOTE=${FILE_VALUE_BRANCH_REMOTE}
VALUE_TAG=''
VALUE_ONLY_PUSH=${DEFAULT_ONLY_PUSH}

# Variables para el archivo yaml
USE_EXEC=''
EXEC=''
USE_TAG=''
DIRECTORY=''
REPOSITORY=''
AUTO_DELETED_TAG=''
BRANCH_LOCAL=''
BRANCH_REMOTE=''

# Variables para el comando
PREFIX_VERSION='v'
TAG=''
ONLY_PUSH=''

# Mostrar información general
info() {
  cat << EOF
[ COMANDOS CLI ]
-t, --tag ........................... Crea el tag especificado en local y remoto. Estructura recomendada: [X_mayor.Y_menor.Z_bugfix]. Depedendecias en YAML: use_tag,auto_deleted_tag
-p, --push .......................... Hace un simple push
-h, --help .......................... Ayuda

[ ARCHIVO DE CONFIGURACION YAML ]
repository .......................... Repositorio git donde se alojará el proyecto.
branch_local ........................ Rama local desde la cual se realizará el despliegue.
branch_remote ....................... Rama remota donde se desplegará el proyecto.
directory ........................... Carpeta donde se genera la compilación del proyecto. Por defecto: dist
use_exec ............................ Indica si esta usando una comando de compilación. Por defecto: true
exec ................................ Comando de compilación que se ejecutará antes del despliegue; separar por 'coma', para ejecutar multiples comandos. Por defecto: sh bin/start.sh -h,npm run build
use_tag ............................. Indica si esta usando tag en el despliegue. Por defecto: true
auto_deleted_tag .................... Indica si se debe eliminar automáticamente el último tag registrado antes de crear uno nuevo. Por defecto: true

[ DOCUMENTACION ]
Repositorio GitHub: https://github.com/alexchristianqr/npm-sh-deploybranch

[ AUTOR ]
Usuario: Alex Christian
Email: alexchristianqr@gmail.com
GitHub: https://github.com/alexchristianqr
EOF
  exit 1
}
