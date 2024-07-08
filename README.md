# npm-deploy-branch

Automatiza el despliegue de ramas de Git en cualquier entorno. Con npm-deploy-branch, puedes crear, gestionar y eliminar tags, así como desplegar el contenido de tus ramas de forma fácil y rápida. Ideal para desarrolladores que buscan simplificar su flujo de trabajo con Git.

## Steps for usage

```bash
sh deploy.sh --tag="0.0.0"
```
```bash
sh deploy.sh --tag="0.0.0" --dir="dist"
```
```bash
sh deploy.sh --tag="0.0.0" --branch="main"
```
```bash
sh deploy.sh --tag="0.0.0" --exec="build"
```
```bash
sh deploy.sh --tag="0.0.0" --repository="alexchristianqr/public-repository"
```
```bash
sh deploy.sh --tag="0.0.0" --deleted-lasttag="true"
```
```bash
sh deploy.sh --tag="0.0.0" --github-pages="true"
```
```bash
sh deploy.sh --help
```
