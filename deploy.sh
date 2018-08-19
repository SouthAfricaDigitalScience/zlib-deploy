#!/bin/bash -e
# Copyright 2016 CSIR Meraka Institute
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# this should be run after check-build finishes.
. /etc/profile.d/modules.sh
echo ${SOFT_DIR}
mkdir -vp ${SOFT_DIR}
module add deploy
echo ${SOFT_DIR}
cd ${WORKSPACE}/${NAME}-${VERSION}
echo "All tests have passed, will now build into ${SOFT_DIR}"
make distclean
./configure --static --shared --prefix=${SOFT_DIR}
make -j2
make install
echo "Creating the modules file directory ${LIBRARIES}"
mkdir -p ${LIBRARIES}/${NAME}
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
    puts stderr "       This module does nothing but alert the user"
    puts stderr "       that the [module-info name] module is not available"
}

module-whatis   "$NAME $VERSION : See https://github.com/SouthAfricaDigitalScience/zlib-deploy"
setenv       ZLIB_VERSION       $VERSION
setenv       ZLIB_DIR           $::env(CVMFS_DIR)/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path LD_LIBRARY_PATH   $::env(ZLIB_DIR)/lib
prepend-path GCC_INCLUDE_DIR   $::env(ZLIB_DIR)/include
MODULE_FILE
) > ${LIBRARIES}/${NAME}/${VERSION}
module avail ${NAME}

# check the modulefile

module add ${NAME}/${VERSION}
