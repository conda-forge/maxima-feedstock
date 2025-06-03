@echo on

:: Following https://sourceforge.net/p/maxima/code/ci/master/tree/INSTALL.lisp

:: Configure
ecl -load configure.lisp -eval "(configure :interactive nil)" -eval "(quit)"
if errorlevel 1 exit 1

:: Build
:: Using "(maxima-compile)" doesn't work: https://sourceforge.net/p/maxima/bugs/4565/
cd src
ecl -load maxima-build.lisp ^
    -eval "(require 'asdf)" ^
    -eval "(push \"./\" asdf:*central-registry*)" ^
    -eval "(asdf:make-build :maxima :type :fasl :move-here \".\")" ^
    -eval "(quit)"
if errorlevel 1 exit 1

:: Test
:: TODO

:: Install Maxima into ECL's library directory
dir
for /f "delims=" %%i in ('ecl -eval "(princ (SI:GET-LIBRARY-PATHNAME))" -eval "(quit)"') do set "ECLLIB=%%i"
copy /Y "src\maxima.fas" "%ECLLIB%\maxima.fas"
