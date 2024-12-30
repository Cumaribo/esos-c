@echo on
set "IMAGE_NAME=esoc_c_models"
set "WORKDIR=/usr/local/esoc_c_models"
docker build -t %IMAGE_NAME% .

if errorlevel 1 (
    echo Docker build failed. Exiting...
    exit /b 1
)

for /f "delims=" %%i in ('cd') do set "CURRENT_DIR=%%i"
set "CURRENT_DIR=%CURRENT_DIR:\=/%

:: Array of scripts
set "SCRIPTS=
docker run -it --rm --env WORKDIR=%WORKDIR% -v %CURRENT_DIR%:%WORKDIR%/data %IMAGE_NAME% python3  /usr/local/esoc_c_models/swy_global/run_swy_global.py --help
if errorlevel 1 (
    echo Error occurred while running %%SCRIPT --help. Exiting...
    exit /b 1
)

docker run -it --rm --env WORKDIR=%WORKDIR% -v %CURRENT_DIR%:%WORKDIR%/data %IMAGE_NAME% python3  /usr/local/esoc_c_models/pollination_sufficiency/pollination_pipeline.py --help
if errorlevel 1 (
    echo Error occurred while running %%SCRIPT --help. Exiting...
    exit /b 1
)

docker run -it --rm --env WORKDIR=%WORKDIR% -v %CURRENT_DIR%:%WORKDIR%/data %IMAGE_NAME% python3  /usr/local/esoc_c_models/distance-to-hab-with-friction/ppl_travel_coverage.py --help
if errorlevel 1 (
    echo Error occurred while running %%SCRIPT --help. Exiting...
    exit /b 1
)

docker run -it --rm --env WORKDIR=%WORKDIR% -v %CURRENT_DIR%:%WORKDIR%/data %IMAGE_NAME% python3  /usr/local/esoc_c_models/distance-to-hab-with-friction/mask_travel_coverage.py --help
if errorlevel 1 (
    echo Error occurred while running %%SCRIPT --help. Exiting...
    exit /b 1
)

docker run -it --rm --env WORKDIR=%WORKDIR% -v %CURRENT_DIR%:%WORKDIR%/data %IMAGE_NAME% python3  /usr/local/esoc_c_models/people_protected_by_coastal_habitat/people_protected_by_coastal_habitat.py --help
if errorlevel 1 (
    echo Error occurred while running %%SCRIPT --help. Exiting...
    exit /b 1
)

docker run -it --rm --env WORKDIR=%WORKDIR% -v %CURRENT_DIR%:%WORKDIR%/data %IMAGE_NAME% python3  /usr/local/esoc_c_models/coastal_risk_reduction/coastal_risk_reduction.py --help
if errorlevel 1 (
    echo Error occurred while running %%SCRIPT --help. Exiting...
    exit /b 1
)

docker run -it --rm --env WORKDIR=%WORKDIR% -v %CURRENT_DIR%:%WORKDIR%/data %IMAGE_NAME% python3  /usr/local/esoc_c_models/downstream-beneficiaries/global_flow_accumulation.py --help
if errorlevel 1 (
    echo Error occurred while running %%SCRIPT --help. Exiting...
    exit /b 1
)

docker run -it --rm --env WORKDIR=%WORKDIR% -v %CURRENT_DIR%:%WORKDIR%/data %IMAGE_NAME% python3  /usr/local/esoc_c_models/downstream-beneficiaries/downstream_beneficiaries.py --help
if errorlevel 1 (
    echo Error occurred while running %%SCRIPT --help. Exiting...
    exit /b 1
)

docker run -it --rm --env WORKDIR=%WORKDIR% -v %CURRENT_DIR%:%WORKDIR%/data %IMAGE_NAME% python3  /usr/local/esoc_c_models/downstream-beneficiaries/downstream_mask.py --help
if errorlevel 1 (
    echo Error occurred while running %%SCRIPT --help. Exiting...
    exit /b 1
)

docker run -it --rm --env WORKDIR=%WORKDIR% -v %CURRENT_DIR%:%WORKDIR%/data %IMAGE_NAME% python3  /usr/local/esoc_c_models/ndr_sdr_global/run_ndr_sdr_pipeline.py --help
if errorlevel 1 (
    echo Error occurred while running %%SCRIPT --help. Exiting...
    exit /b 1
)

if errorlevel 1 (
    echo Error occurred while running %%SCRIPT --help. Exiting...
    exit /b 1
)

echo All scripts executed successfully.
