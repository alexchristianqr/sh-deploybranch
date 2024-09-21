# sh-deploybranch 

Automatiza el despliegue de ramas de Git en cualquier entorno. Especificamente diseñado para crear tags y release.

## Instalación
```bash
npm install sh-deploybranch
```

## Modo de uso
```bash
npm sh-deploybranch --help
npm sh-deploybranch --tag="1.0.0"
npm sh-deploybranch --push
```

## Documentación
```bash
----------------
[ COMANDOS CLI ]
----------------
-t, --tag ........................... Crea el tag especificado en local y remoto. Estructura recomendada: [Xmayor.Ymenor.Zbugfix]. Depedendecias en YAML: use_tag,auto_deleted_tag
-p, --push .......................... Hace un simple push
-h, --help .......................... Ayuda

---------------------------------
[ ARCHIVO DE CONFIGURACION YAML ]
---------------------------------
repository .......................... Repositorio git donde se alojará el proyecto.
branch_local ........................ Rama local desde la cual se realizará el despliegue.
branch_remote ....................... Rama remota donde se desplegará el proyecto.
directory ........................... Carpeta donde se genera la compilación del proyecto. Por defecto: dist
use_exec ............................ Indica si esta usando una comando de compilación. Por defecto: true
exec ................................ Comando de compilación que se ejecutará antes del despliegue; separar por 'coma', para ejecutar multiples comandos. Por defecto: sh bin/start.sh -h,npm run build
use_tag ............................. Indica si esta usando tag en el despliegue. Por defecto: true
auto_deleted_tag .................... Indica si se debe eliminar automáticamente el último tag registrado antes de crear uno nuevo. Por defecto: true

-----------------
[ DOCUMENTACION ]
-----------------
Repositorio GitHub: https://github.com/alexchristianqr/npm-sh-deploybranch
```
