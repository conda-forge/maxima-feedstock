@echo on

:: Following https://sourceforge.net/p/maxima/code/ci/master/tree/INSTALL.lisp

:: Build
ecl -shell build-ecl.lisp
if errorlevel 1 exit 1
