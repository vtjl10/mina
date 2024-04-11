#!/bin/bash

# This script is supposed to be executed from pipeline without arguments. In order to control
# Input parameters pipeline should defined env variables like below:
# steps:
#  - commands:
#      - "./buildkite/scripts/run_promote_build_job.sh | buildkite-agent pipeline upload"
#    label: ":pipeline: run promote build job"
#    agents:
#       size: "generic"
#   plugins:
#      "docker#v3.5.0":
#        environment:
#          - BUILDKITE_AGENT_ACCESS_TOKEN
#          - "PACKAGES=LogProc"
#          - "VERSION=2.0.0berkeley-rc1-develop-91bf5d2"
#          - "CODENAME=Bullseye"
#          - "FROM_CHANNEL=Unstable"
#          - "TO_CHANNEL=Nightly"
#        image: codaprotocol/ci-toolchain-base:v3
#        mount-buildkite-agent: true
#        propagate-environment: true
#
# Below method is kept for documentaion purposes

function usage() {
  if [[ -n "$1" ]]; then
    echo -e "${RED}☞  $1${CLEAR}\n";
  fi
  echo "  DEBIANS                     The comma delimitered debian names. For example: 'Daemon,Archive' "
  echo "  DOCKERS                     The comma delimitered docker names. For example: 'Daemon,Archive' "
  echo "  CODENAMES                   The Debian codenames (Bullseye, Buster etc.)"
  echo "  FROM_VERSION                The Source Docker or Debian version "
  echo "  NEW_VERSION                 The new Debian version or new Docker tag"
  echo "  REMOVE_PROFILE_FROM_NAME    Should we remove profile suffix from debian name"
  echo "  PROFILE                     The Docker and Debian profile (Standard, Lightnet)"
  echo "  FROM_CHANNEL                Source debian channel"
  echo "  TO_CHANNEL                  Target debian channel"
  echo "  PUBLISH                     The Publish to docker.io flag. If defined, script will publish docker do docker.io. Otherwise it will still resides in gcr.io"
  echo ""
  exit 1
}

if [ -z "$DEBIANS" ] && [ -z "$DOCKERS"]; then usage "No Debians nor Dockers defined for promoting!"; fi;

DHALL_DEBIANS="([] : List (./buildkite/src/Constants/DebianPackage.dhall).Type)"


if [[ -n "$DEBIANS" ]]; then 
    if [[ -z "$CODENAMES" ]]; then usage "Codenames is not set!"; fi;
    if [[ -z "$PROFILE" ]]; then PROFILE="Standard"; fi;
    if [[ -z "$REMOVE_PROFILE_FROM_NAME" ]]; then REMOVE_PROFILE_FROM_NAME=0; fi;
    if [[ -z "$FROM_CHANNEL" ]]; then usage "'From channel' arg is not set!"; fi;
    if [[ -z "$TO_CHANNEL" ]]; then usage "'To channel' arg is not set!"; fi;
    if [[ -z "$FROM_VERSION" ]]; then usage "Version is not set!"; fi;
    if [[ -z "$NEW_VERSION" ]]; then NEW_VERSION=$VERSION; fi;
    

  arr_of_debians=(${DEBIANS//,/ })
  DHALL_DEBIANS=""
  for i in "${arr_of_debians[@]}"; do
    DHALL_DEBIANS="${DHALL_DEBIANS}, (./buildkite/src/Constants/DebianPackage.dhall).Type.${i}"
  done
  DHALL_DEBIANS="[${DHALL_DEBIANS:1}]"
fi


DHALL_DOCKERS="([] : List (./buildkite/src/Constants/Artifacts.dhall).Type)"

if [[ -n "$DOCKERS" ]]; then 
    if [[ -z "$NEW_VERSION" ]]; then usage "New Tag is not set!"; fi;
    if [[ -z "$VERSION" ]]; then usage "Version is not set!"; fi;
    if [[ -z "$PROFILE" ]]; then PROFILE="Standard"; fi;
  
  arr_of_dockers=(${DOCKERS//,/ })
  DHALL_DOCKERS=""
  for i in "${arr_of_dockers[@]}"; do
    DHALL_DOCKERS="${DHALL_DOCKERS}, (./buildkite/src/Constants/Artifacts.dhall).Type.${i}"
  done
  DHALL_DOCKERS="[${DHALL_DOCKERS:1}]"
fi

local __codenames=(${CODENAMES//,/ })
DHALL_CODENAMES=""
  for i in "${__codenames[@]}"; do
    DHALL_CODENAMES="${DHALL_CODENAMES}, (./buildkite/src/Constants/DebianVersions.dhall).DebVersion.${i}"
  done
  DHALL_CODENAMES="[${DHALL_CODENAMES:1}]"


echo '(./buildkite/src/Entrypoints/PromotePackage.dhall).promote_artifacts '"$DHALL_DEBIANS"' '"$DHALL_DOCKERS"' "'"${FROM_VERSION}"'" "'"${NEW_VERSION}"'" "amd64" (./buildkite/src/Constants/Profiles.dhall).Type.'"${PROFILE}"' '"${DHALL_CODENAMES}"' (./buildkite/src/Constants/DebianChannel.dhall).Type.'"${FROM_CHANNEL}"' (./buildkite/src/Constants/DebianChannel.dhall).Type.'"${TO_CHANNEL}"' "'"${TAG}"'" ' | dhall-to-yaml --quoted 
