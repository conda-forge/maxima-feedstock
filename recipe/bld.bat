@echo on

:: Following https://sourceforge.net/p/maxima/code/ci/master/tree/INSTALL.lisp

:: Configure
ecl -load configure.lisp -eval "(configure :interactive nil)" -eval "(quit)"
if errorlevel 1 exit 1

:: Build
cd src
ecl --load maxima-build.lisp -eval "(require 'cmp)" -eval "(maxima-compile)" -eval "(quit)"
if errorlevel 1 exit 1

:: Test
:: TODO
