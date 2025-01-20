@echo on

set "IMAGE_NAME=therealspring/esos-spring-env:latest"
set "WORKDIR=/usr/local/esos_c_models"
set "CURRENT_DIR=%CD%"
docker pull %IMAGE_NAME% .

docker run -it --rm --env WORKDIR=%WORKDIR% -v "%CURRENT_DIR%:%WORKDIR%/data" %IMAGE_NAME%
