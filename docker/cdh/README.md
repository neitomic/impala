### How to build docker images

```bash
# from impala root
./bin/bootstrap_system.sh
source ./bin/impala-config.sh 
./buildall.sh -release -skiptests -ninja -noclean -notests
ninja docker_images
```
