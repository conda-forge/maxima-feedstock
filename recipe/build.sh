#!/bin/bash

export LD_LIBRARY_PATH="$PREFIX/lib:$LD_LIBRARY_PATH"
export CFLAGS="-g -O2 $CFLAGS"

if [[ "$target_platform" == osx* ]]; then
    export CFLAGS="-Wno-unknown-attributes $CFLAGS"
fi

chmod +x configure
./configure \
        --host=$HOST \
        --prefix="$PREFIX" \
        --libdir="$PREFIX/lib" \
        --enable-ecl

make -j${CPU_COUNT}

if [[ "$target_platform" == "linux-ppc64le" || "$target_platform" == "linux-aarch64" ]]; then
  echo "Skipping tests as they take too long"
else
  make check -j${CPU_COUNT} || (cat tests/test-suite.log && exit 1)
fi
make install

# Install Maxima into ECL's library directory
ECLLIB=`ecl -eval "(princ (SI:GET-LIBRARY-PATHNAME))" -eval "(quit)"`
cp -f "src/binary-ecl/maxima.fas" "$ECLLIB/maxima.fas"
# Remove this once https://github.com/conda/conda-build/pull/1775 is in a release
cp -f "src/binary-ecl/maxima.fas" "$ECLLIB/../ecl/maxima.fas"

