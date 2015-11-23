#!/bin/bash -e
. /etc/profile.d/modules.sh
SOURCE_FILE=${NAME}-${VERSION}.tar.gz

module load ci
echo ${SOFT_DIR}
mkdir -p ${SOFT_DIR}
echo ${WORKSPACE}
mkdir -p ${WORKSPACE}
echo ${SRC_DIR}
mkdir -p ${SRC_DIR}
echo ${NAME}
echo ${VERSION}
#module load gcc/4.8.2
if [[ ! -s ${SRC_DIR}/${SOURCE_FILE} ]] ; then
  echo "Seems the file is not available locally, downloading"
  mkdir -p ${SRC_DIR}
	wget http://zlib.net/${SOURCE_FILE} -O ${SRC_DIR}/${SOURCE_FILE}
fi

tar xvzf ${SRC_DIR}/${SOURCE_FILE} -C ${WORKSPACE} --skip-old-files
ls ${WORKSPACE}

cd ${WORKSPACE}/${NAME}-${VERSION}
./configure --prefix=${SOFT_DIR}
make
