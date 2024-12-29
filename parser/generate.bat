@echo off
setlocal enabledelayedexpansion

REM Set the path to the ANTLR JAR file
set "ANTLR_JAR=antlr-4.13.2-complete.jar"

REM Check for the presence of at least one .g4 file
set "G4_EXISTS=false"
for %%f in (*.g4) do (
    set "G4_EXISTS=true"
    goto :RUN_ANTLR
)

REM If no .g4 files are found, display an error and exit
if "!G4_EXISTS!"=="false" (
    echo ERROR: No .g4 files found in the current directory.
    exit /b 1
)

:RUN_ANTLR
REM Run ANTLR with the specified options
java -jar "%ANTLR_JAR%" -Dlanguage=Python3 -visitor -package parsing -o "..\parsing" *.g4

REM Check if the ANTLR command succeeded
if errorlevel 1 (
    echo ERROR: ANTLR code generation failed.
    exit /b 1
)

echo ANTLR code generation completed successfully.
exit /b 0