#!/bin/bash -e
. /etc/profile.d/modules.sh
module add ci
echo $PWD
cd ${WORKSPACE}/${NAME}-${VERSION}

# Zlib does not have a make check
make install

# At this point, we should have built zlib

ls -lht ${SOFT_DIR}

mkdir -p modules
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
    puts stderr "       This module does nothing but alert the user"
    puts stderr "       that the [module-info name] module is not available"
}
module-whatis   "$NAME $VERSION. See https://gitub.com/SouthAfricaDigitalScience/zlib-deploy"
setenv       ZLIB_VERSION       $VERSION
setenv       ZLIB_DIR           $::env(SOFT_DIR)/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH   $::env(ZLIB_DIR)/lib
MODULE_FILE
) > modules/${VERSION}

mkdir -p ${LIBRARIES_MODULES}/${NAME}
cp -v modules/${VERSION} ${LIBRARIES_MODULES}/${NAME}
module avail
