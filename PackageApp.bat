@echo off
set PAUSE_ERRORS=1
call bat\SetupSDK.bat
call bat\SetupApplication.bat

set AIR_TARGET=
::set AIR_TARGET=-captive-runtime
set OPTIONS=-tsa none
call bat\Packager.bat

call adt -package -tsa none %SIGNING_OPTIONS% %OPTIONS% -target bundle %OUTPUT% %APP_XML% %FILE_OR_DIR%

pause