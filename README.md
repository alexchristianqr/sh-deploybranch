# Shell to GitHub Pages

Shell script automatizado para recibir multiples parametros que permiten el despliegue de un repositorio público en Github Pages.

## Steps for usage

```bash
sh main.sh --tag="0.0.0"
```
```bash
sh main.sh --tag="0.0.0" --dir="dist"
```
```bash
sh main.sh --tag="0.0.0" --branch="main"
```
```bash
sh main.sh --tag="0.0.0" --exec="build"
```
```bash
sh main.sh --tag="0.0.0" --repository="alexchristianqr/public-repository"
```
```bash
sh main.sh --tag="0.0.0" --deleted-lasttag="true"
```
```bash
sh main.sh --tag="0.0.0" --github-pages="true"
```
```bash
sh main.sh --help
```
