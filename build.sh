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

. /etc/profile.d/modules.sh
SOURCE_FILE=v${VERSION}.tar.gz
module add ci
echo ${SOFT_DIR}
mkdir -p ${SOFT_DIR}
echo ${WORKSPACE}
mkdir -p ${WORKSPACE}
echo ${SRC_DIR}
mkdir -p ${SRC_DIR}
echo ${NAME}
echo ${VERSION}

if [ ! -e ${SRC_DIR}/${SOURCE_FILE}.lock ] && [ ! -s ${SRC_DIR}/${SOURCE_FILE} ] ; then
  touch  ${SRC_DIR}/${SOURCE_FILE}.lock
  echo "Seems the file is not available locally, downloading"
  mkdir -p ${SRC_DIR}
	wget https://github.com/madler/zlib/archive/${SOURCE_FILE} -O ${SRC_DIR}/${SOURCE_FILE}
  echo "releasing lock"
  rm -v ${SRC_DIR}/${SOURCE_FILE}.lock
elif [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; then
  # Someone else has the file, wait till it's released
  while [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; do
    echo " There seems to be a download currently under way, will check again in 5 sec"
    sleep 5
  done
fi

tar xvf ${SRC_DIR}/${SOURCE_FILE} -C ${WORKSPACE} --skip-old-files
ls ${WORKSPACE}

cd ${WORKSPACE}/${NAME}-${VERSION}
./configure --static --shared \
--prefix=${SOFT_DIR}
make -j2
