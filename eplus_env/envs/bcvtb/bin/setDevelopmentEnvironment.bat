@echo off

rem ------------------------------------------------------------------
rem Batch file that sets environment variables for BCVTB.
rem This file sets environment variables for the BCVTB.
rem It is only needed for users who develop and compile the
rem BCVTB. 
rem This file gets all environment variables from
rem the file systemVariables-windows.properties
rem
rem The file need to be executed from the binary directory of the 
rem BCVTB (bcvtb\bin), otherwise an error message will be written.
rem
rem MWetter@lbl.gov                                         2009-06-18
rem ------------------------------------------------------------------

rem ------------------------------------------------------------------
rem    Read environment variables from systemVariables-windows.properties
rem ------------------------------------------------------------------
rem Flag, set to true on 32 bit systems, or to false on 64 bit systems
@set BCVTB_JAR=%~dp0\BCVTB.jar
for /F "delims=" %%i in ('java -jar "%BCVTB_JAR%" --getEnvironmentVariable BCVTB_32bit') do set BCVTB_32bit=%%i
rem EnergyPlus installation directory
for /F "delims=" %%i in ('java -jar "%BCVTB_JAR%" --getEnvironmentVariable ENERGYPLUS_BIN') do set ENERGYPLUS_BIN="%%i"
rem Dymola executable
for /F "delims=" %%i in ('java -jar "%BCVTB_JAR%" --getEnvironmentVariable BCVTB_DYMOLA_BIN') do set BCVTB_DYMOLA_BIN="%%i"
rem TRNSYS executable
for /F "delims=" %%i in ('java -jar "%BCVTB_JAR%" --getEnvironmentVariable BCVTB_TRNSYS_BIN') do set BCVTB_TRNSYS_BIN="%%i"
rem Radiance directory
for /F "delims=" %%i in ('java -jar "%BCVTB_JAR%" --getEnvironmentVariable BCVTB_RADIANCE_BIN') do set BCVTB_RADIANCE_BIN="%%i"
rem Batch file that sets environment variables for Visual Studio C compiler
for /F "delims=" %%i in ('java -jar "%BCVTB_JAR%" --getEnvironmentVariable BCVTB_VS_BAT') do set BCVTB_VS_BAT="%%i"
rem Directory with libraries that are needed to compile the BACnet stack
for /F "delims=" %%i in ('java -jar "%BCVTB_JAR%" --getEnvironmentVariable BCVTB_SDKLib_DIR') do set BCVTB_SDKLib_DIR="%%i"
rem Directory with include files that are needed to compile the ADInterfaceMCC stack
for /F "delims=" %%i in ('java -jar "%BCVTB_JAR%" --getEnvironmentVariable BCVTB_JNI_DIR') do set BCVTB_JNI_DIR="%%i"
rem Batch file that sets environment variables for Intel Fortran compiler
for /F "delims=" %%i in ('java -jar "%BCVTB_JAR%" --getEnvironmentVariable BCVTB_IFORT_BAT') do set BCVTB_IFORT_BAT="%%i"
rem PATH variable so that dll's can be found. Don't quote PATH as it contain
rem many entries.
for /F "delims=" %%i in ('java -jar "%BCVTB_JAR%" --getEnvironmentVariable PATH') do set PATH=%%i
rem Get the flag that indicates whether the BACnet interface is available on this installation
for /F "delims=" %%i in ('java -jar "%BCVTB_JAR%" --getEnvironmentVariable haveBACnetALC') do set haveBACnetALC=%%i
rem Get the flag that indicates whether the A/D interface is available on this installation
for /F "delims=" %%i in ('java -jar "%BCVTB_JAR%" --getEnvironmentVariable haveADInterfaceMCC') do set haveADInterfaceMCC=%%i

rem ------------------------------------------------------
rem - Make sure we are called from the top-level directory
rem ------------------------------------------------------
rem if exist bin\setenv.bat goto CHECKPT
rem echo Error: The file setenv.bat need to be called from
rem echo        the top-level directory of the BCVTB, and
rem echo        not from %cd%
rem echo        Exit with error.
rem goto END

:CHECKPT
rem ---------------------------------------------------
rem --------------- Ptolemy ---------------------------
rem ---------------------------------------------------
rem if defined PTII goto :CHECKCONFIG
@set PTII=%~dp0..\lib\ptII
if exist "%PTII%\copyright.txt" goto CHECKCONFIG
echo Error: Environment variable PTII does not point to Ptolemy.
echo        File %PTII%\copyright.txt does not exist.
echo        You need to set the PTII environment variable
echo        so that PTII\ptolemy, PTII\lbnl etc. exist.
echo        Exit with error.
goto END

:CHECKCONFIG
rem ---------------------------------------------------
rem ---- PTII is set. 
rem ---- Make sure it contains the bcvtb configuration
rem ---------------------------------------------------
if exist "%PTII%\ptolemy\configs\bcvtb\configuration.xml" goto SETVARS1
echo Error: PTII is set to %PTII%.
echo        But this Ptolemy version does not contain the BCVTB configuration.
echo        You need to update to Ptolemy 8.1 or later.
echo        If you set PTII manually, you may want to unset it in order to use
echo        the Ptolemy version that is distributed with the BCVTB.
echo        Exit with error.
goto END

rem ---------------------------------------------------
rem ---- PTII is set. 
rem ---- Make sure it contains the bcvtb configuration
rem ---------------------------------------------------

:SETVARS1
cd ..
@set BCVTB_HOME=%CD%
cd bin
@set ANT_HOME=%BCVTB_HOME%\lib\apache-ant

IF %BCVTB_32bit%==true  echo Configuring BCVTB development environment for 32 bit.
IF %BCVTB_32bit%==false echo Configuring BCVTB development environment for 64 bit.

:CHECKIFORT
rem ---------------------------------------------------
rem ---------------Fortran Compiler -------------------
rem ---------------------------------------------------

rem Set Fortran environment variables. IFortVars.bat also sets the C++
rem variables
if exist %BCVTB_IFORT_BAT% (
  IF %BCVTB_32bit%==true  CALL %BCVTB_IFORT_BAT% ia32
  IF %BCVTB_32bit%==false CALL %BCVTB_IFORT_BAT% intel64
    goto CHECKVC
)
echo **************************************************************
echo *** Warning: Did not find environment variable for Fortran.
echo  You will not be able to compile Fortran source code.
echo  You will be able to use compiled code.
echo  Fortran batch file is set to 
echo  %BCVTB_IFORT_BAT%.
echo  If Fortran is installed, adjust the file 
echo  %BCVTB_HOME%\bin\systemVariables-windows.properties.bat

:CHECKVC
rem --------------------------------------------------
rem ------------- C++ compiler -----------------------
rem --------------------------------------------------
rem The next command sets VCINSTALLDIR if available
if defined BCVTB_VS_BAT call %BCVTB_VS_BAT%
if exist "%VCINSTALLDIR%\vcvarsall.bat" (
  IF %BCVTB_32bit%==true  call "%VCINSTALLDIR%\vcvarsall.bat"
  IF %BCVTB_32bit%==false call "%VCINSTALLDIR%\vcvarsall.bat" amd64
  goto CHECKSDKLibDir
)
echo **************************************************************
echo *** Warning: Did not find Visual C++ compiler.
echo  Environment variable BCVTB_VCDIR does not point to Visual C++ directory.
echo  You will not be able to compile source code.
echo  You will be able to use compiled code.
echo  C++ batch file is set to 
echo  %BCVTB_VS_BAT%.
echo  If C++ is installed, adjust the file 
echo  %BCVTB_HOME%\bin\systemVariables-windows.properties.bat

:CHECKSDKLibDir
rem --------------------------------------------------
rem ------------- C++ compiler -----------------------
rem --------------------------------------------------
rem The next command checks if the directory pointed to by BCVTB_SDKLib_DIR exists
if exist %BCVTB_SDKLib_DIR% (
  goto CHECKJNIDir
)
echo **************************************************************
echo *** Warning: Did not find Microsoft's SDK directory.
echo  This directory is only needed to compile the BACnet stack.
echo  BCVTB_SDKLib_DIR is set to 
echo  %BCVTB_SDKLib_DIR%.
echo  If Microsoft's SDK is installed, adjust BCVTB_SDKLib_DIR
echo  in %BCVTB_HOME%\bin\systemVariables-windows.properties, and
echo  in %BCVTB_HOME%\lib\bacnet-stack\build.xml


:CHECKJNIDir
rem --------------------------------------------------
rem ------------- JNI include files ------------------
rem --------------------------------------------------
rem The next command checks if the directory pointed to by BCVTB_JNI_DIR exists
if exist %BCVTB_JNI_DIR% (
  goto SETVARS2
)
echo **************************************************************
echo *** Warning: Did not find JNI include files.
echo  This directory is only needed to compile the ADInterfaceMCC stack.
echo  BCVTB_JNI_DIR is set to 
echo  %BCVTB_JNI_DIR%.
echo  If Java is installed, adjust BCVTB_JNI_DIR
echo  in %BCVTB_HOME%\bin\systemVariables-windows.properties, and
echo  in %BCVTB_HOME%\lib\adInterfaceMCC-stack\src\C\build.xml


:SETVARS2
@set PATH=%PATH%;%ANT_HOME%\bin
@set CLASSPATH=%PTII%;%CLASSPATH%;%BCVTB_HOME%\lib\cpptasks.jar
@set BCVTB_OS=windows 

:WRITECONFIG
rem --------------------------------------------------
rem -----Generate configuration file for ant ---------
rem --------------------------------------------------
cd %BCVTB_HOME%
echo // This file was autogenerated on %date% > build.properties
echo // Changes to this file will be lost whenever >> build.properties
echo // %0 is executed.  >> build.properties
if exist %BCVTB_IFORT_BAT% echo haveIfort=true >> build.properties

rem --- Check for MATLAB
java -jar  "%BCVTB_HOME%\lib\config\getPath\build\jar\GetPath.jar" > setenv.temp
find /c /i "matlab" setenv.temp > NUL
IF %ERRORLEVEL%==0 (
   echo haveMatlab=true >> build.properties
) ELSE (
   echo **************************************************************
   echo *** Warning: Did not find matlab.
   echo  If matlab is installed, add it to the PATH
   echo  variable in %BCVTB_HOME%\bin\systemVariables-windows.properties
)
del setenv.temp

rem --- Check for EnergyPlus
if exist %ENERGYPLUS_BIN% (
   echo haveEnergyPlus=true >> build.properties
) ELSE (
   echo **************************************************************
   echo *** Warning: Did not find EnergyPlus.
   echo  ENERGYPLUS_BIN is set to 
   echo  %ENERGYPLUS_BIN%.
   echo  If EnergyPlus is installed, adjust ENERGYPLUS_BIN
   echo  in %BCVTB_HOME%\bin\systemVariables-windows.properties
)

rem --- Check for Dymola
if exist %BCVTB_DYMOLA_BIN% (
   echo haveDymola=true >> build.properties
) ELSE (
   echo **************************************************************
   echo *** Warning: Did not find Dymola.
   echo  BCVTB_DYMOLA_BIN is set to 
   echo  %BCVTB_DYMOLA_BIN%.
   echo  If Dymola is installed, adjust BCVTB_DYMOLA_BIN
   echo  in %BCVTB_HOME%\bin\systemVariables-windows.properties
)

rem --- Check for TRNSYS
if exist %BCVTB_TRNSYS_BIN% (
   echo haveTRNSYS=true >> build.properties
) ELSE (
   echo **************************************************************
   echo *** Warning: Did not find TRNSYS.
   echo  BCVTB_TRNSYS_BIN is set to 
   echo  %BCVTB_TRNSYS_BIN%.
   echo  If TRNSYS is installed, adjust BCVTB_TRNSYS_BIN
   echo  in %BCVTB_HOME%\bin\systemVariables-windows.properties
)

rem --- Check for Radiance
if exist %BCVTB_RADIANCE_BIN% (
   echo haveRadiance=true >> build.properties
) ELSE (
   echo **************************************************************
   echo *** Warning: Did not find Radiance.
   echo  BCVTB_RADIANCE_BIN is set to 
   echo  %BCVTB_RADIANCE_BIN%.
   echo  If Radiance is installed, adjust BCVTB_RADIANCE_BIN
   echo  in %BCVTB_HOME%\bin\systemVariables-windows.properties
)

rem -- Write flags for BACnet and A/D interface
echo haveBACnetALC=%haveBACnetALC% >> build.properties
echo haveADInterfaceMCC=%haveADInterfaceMCC% >> build.properties

:END
