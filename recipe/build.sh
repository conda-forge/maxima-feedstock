#!/bin/bash

export CPPFLAGS="-I$PREFIX/include $CPPFLAGS"
export LDFLAGS="-L$PREFIX/lib $LDFLAGS"
export LD_LIBRARY_PATH="$PREFIX/lib:$LD_LIBRARY_PATH"
export CFLAGS="-g -O2 $CFLAGS"

if [[ "$target_platform" == osx* ]]; then
    export CFLAGS="-Wno-unknown-attributes $CFLAGS"
fi

chmod +x configure
./configure \
        --prefix="$PREFIX" \
        --libdir="$PREFIX/lib" \
        --enable-ecl

make -j${CPU_COUNT}
make check -j${CPU_COUNT} || (cat tests/test-suite.log && exit 1)
make install

# Install Maxima into ECL's library directory
ECLLIB=`ecl -eval "(princ (SI:GET-LIBRARY-PATHNAME))" -eval "(quit)"`
cp -f "src/binary-ecl/maxima.fas" "$ECLLIB/maxima.fas"
# Remove this once https://github.com/conda/conda-build/pull/1775 is in a release
cp -f "src/binary-ecl/maxima.fas" "$ECLLIB/../ecl/maxima.fas"

