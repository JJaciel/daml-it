
# Installation
## Daml installation
Mac/linux [-> docs](https://docs.daml.com/getting-started/installation.html#mac-and-linux)
```sh
curl -sSL https://get.daml.com/ | sh
```

## Dependencies
Visual Studio Code
JDK 11 or greater

## Other requirements
- set JAVA_HOME variable [-> docs](https://docs.daml.com/getting-started/path-variables.html#mac-os)
- on `.zprofile`
```sh
export JAVA_HOME="$(/usr/libexec/java_home)"
export PATH="$HOME/.daml/bin:$PATH"
```
then source `source ~/.zprofile`
- confirm installation:
```sh
java -version
daml version
echo $JAVA_HOME
```




