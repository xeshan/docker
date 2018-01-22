#!/bin/bash

prepare_image() {
[[ -z "$1" ]] && \
   SUFFIX=$1 \
   NAME_SUFFIX="" \
   NAME_SUFFIX="${1}-"

EMS_VERSION=${EMS_VERSION:="7.1.0.8"}
ARTIFACTORY=${ARTIFACTORY:="artifact.message.com"}

EMS_ARTIFACTORY_URL="http://${ARTIFACTORY}:8081/artifactory/simple/libs-release-local/com/m1/emsbundle/emsBundle"

BIN_DIR=bin/
DOCKER_BIN_DIR=docker_bin/

# check and create docker_bin directory
[[ -d "${DOCKER_BIN_DIR}" ]] && \
    mkdir $DOCKER_BIN_DIR

# download and extract EMS bundle
[[ ! -f "${BIN_DIR}/emsBundle-${EMS_VERSION}-ems-bundle.tar" ]] && \     
  echo "Downloading EMS bundle & RPMs..." \
  wget -P ${BIN_DIR} "${EMS_ARTIFACTORY_URL}/${EMS_VERSION}/emsBundle-${EMS_VERSION}-ems-bundle.tar"

# extract ems bundle
[[ ! -d "${BIN_DIR}/emsBundle-${EMS_VERSION}" ]] && \
  echo "Extracting EMS bundle..." \
  cd ${BIN_DIR} \
  tar xf "emsBundle-${EMS_VERSION}-ems-bundle.tar" \
  cd - 

#create required directory to copy projects files
for d in "packages" "res"; do
  [[ ! -d "${DOCKER_BIN_DIR}/${d}" ]] && \
    mkdir "${DOCKER_BIN_DIR}/${d}"
done


mkdir -p "${DOCKER_BIN_DIR}/res/conf/wfe"
mkdir -p "${DOCKER_BIN_DIR}/res/conf/eengine"

ls ${DOCKER_BIN_DIR}/packages/dynamic.webserve* >/dev/null 2>&1
RES=$?
if [ $RES != 0 ]; then
  echo "Copying files for docker image from EMS bundle..."
  cp ${BIN_DIR}/emsBundle-${EMS_VERSION}/ems_rpm_noarch/files/dynamic.webserver-m1-ems-${EMS_VERSION}-*.rpm ${DOCKER_BIN_DIR}/packages/
  cp ${BIN_DIR}/emsBundle-${EMS_VERSION}/emscore/templates/import_certificate.sh ${DOCKER_BIN_DIR}/res/
  cp ${BIN_DIR}/emsBundle-${EMS_VERSION}/emscore/files/discovery.properties ${DOCKER_BIN_DIR}/res/conf
  cp ${BIN_DIR}/emsBundle-${EMS_VERSION}/emsinit/files/product.version ${DOCKER_BIN_DIR}/res/conf
  cp ${BIN_DIR}/emsBundle-${EMS_VERSION}/emsfoldersync/files/foldersync-service-context.xml ${DOCKER_BIN_DIR}/res/conf
  cp ${BIN_DIR}/emsBundle-${EMS_VERSION}/emsnotifications/files/notification-service-context.xml ${DOCKER_BIN_DIR}/res/conf
  cp ${BIN_DIR}/emsBundle-${EMS_VERSION}/emsnotifications/files/notification-service.properties ${DOCKER_BIN_DIR}/res/conf
  cp ${BIN_DIR}/emsBundle-${EMS_VERSION}/emsrecoveryarchive/files/recovery-archive-service-context.xml ${DOCKER_BIN_DIR}/res/conf
  cp ${BIN_DIR}/emsBundle-${EMS_VERSION}/emstransition/files/transition-service-context.xml ${DOCKER_BIN_DIR}/res/conf/wfe
  for file in \
    "amdb-prod-pool-context.xml" \
    "emsdb-prod-nonpool-context.xml" \
    "emsdb-prod-pool-context.xml" \
    "trackdb-prod-pool-context.xml" \
    "archive-context.xml" \
    "amqdb-prod-pool-context.xml" \
    "emsdb-prod-nonpool-context.xml" \
    "trackdb-prod-nonpool-context.xml" \
    "fast.mime.filter" \
    "mime-mapper.filter" \
    "sms-profiles.xml" \
    "log4j.dtd" \
    "cache.xml" \
    "messages.xml" \
    "qa-sms-profiles.xml" \
    "StaticResourceRewriteMap.json" \
    "tika-content-errors.filter" \
  ; do
    cp ${BIN_DIR}/emsBundle-${EMS_VERSION}/emscore/files/$file ${DOCKER_BIN_DIR}/res/conf/wfe
  done

fi

DOCKERFILE="Dockerfile"
echo "Starting image build with dockerfile: ${DOCKERFILE}"
docker build -f ${DOCKERFILE} \
  -t dkr.ecr.us-east-1.amazonaws.com/ems-${SUFFIX}:${EMS_VERSION}${NAME_SUFFIX} .
echo "Deleting temporary directories"
rm -fr "${DOCKER_BIN_DIR}"
rm -fr "${BIN_DIR}"
}

check_args $@
prepare_image $1
exit 0
