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
    -eval "(asdf:make-build :maxima :type :fasl)" ^
    -eval "(quit)"
if errorlevel 1 exit 1

:: Test
:: TODO
