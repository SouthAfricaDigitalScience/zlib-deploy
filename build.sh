#!/bin/bash -e
. /etc/profile.d/modules.sh
SOURCE_FILE=${NAME}-${VERSION}.tar.gz
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
	wget http://zlib.net/${SOURCE_FILE} -O ${SRC_DIR}/${SOURCE_FILE}
  echo "releasing lock"
  rm -v ${SRC_DIR}/${SOURCE_FILE}.lock
elif [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; then
  # Someone else has the file, wait till it's released
  while [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; do
    echo " There seems to be a download currently under way, will check again in 5 sec"
    sleep 5
  done
fi

tar xvzf ${SRC_DIR}/${SOURCE_FILE} -C ${WORKSPACE} --skip-old-files
ls ${WORKSPACE}

cd ${WORKSPACE}/${NAME}-${VERSION}
./configure \
--prefix=${SOFT_DIR}
make -j2
