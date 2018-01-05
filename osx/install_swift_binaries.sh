#!/bin/bash

##
# Copyright IBM Corporation 2016, 2018
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##

# This script installs the Swift binaries on OS X.

# If any commands fail, we want the shell script to exit immediately.
set -e

# Echo commands before executing them.
#set -o verbose

# Install OS X system level dependencies
brew update > /dev/null

XCODE=$(/usr/bin/xcodebuild -version)
XCODE_VERSION=$(echo ${XCODE} | sed -n 1p | cut -d' ' -f2)
SWIFT_VERSION=$(cut -d '-' -f 2- <<< "swift-4.0.3-RELEASE" | tr -d '[:space:]')

# Travis only supports 9.2, 9.1, 9.0, 8.3.3, 8.3, 7.3, and 6.4
([ "${XCODE_VERSION}" == "9.2" ] && [ ${SWIFT_VERSION} == "4.0.3-RELEASE" ]) && alreadyDownloaded=1
([ "${XCODE_VERSION}" == "9.1" ] && [ ${SWIFT_VERSION} == "4.0.2-RELEASE" ]) && alreadyDownloaded=1
([ "${XCODE_VERSION}" == "9.0" ] && [ ${SWIFT_VERSION} == "4.0-RELEASE" ]) && alreadyDownloaded=1
([ "${XCODE_VERSION}" == "8.3.3" ] && [ ${SWIFT_VERSION} == "3.1.1-RELEASE" ]) && alreadyDownloaded=1
([ "${XCODE_VERSION}" == "8.3.2" ] && [ ${SWIFT_VERSION} == "3.1.1-RELEASE" ]) && alreadyDownloaded=1
([ "${XCODE_VERSION}" == "8.3" ] && [ ${SWIFT_VERSION} == "3.1-RELEASE" ]) && alreadyDownloaded=1
([ "${XCODE_VERSION}" == "8.2" ] && [ ${SWIFT_VERSION} == "3.0.2-RELEASE" ]) && alreadyDownloaded=1
([ "${XCODE_VERSION}" == "8.1" ] && [ ${SWIFT_VERSION} == "3.0.1-RELEASE" ]) && alreadyDownloaded=1
([ "${XCODE_VERSION}" == "8.0" ] && [ ${SWIFT_VERSION} == "3.0-RELEASE" ]) && alreadyDownloaded=1
([ "${XCODE_VERSION}" == "7.3.1" ] && [ ${SWIFT_VERSION} == "2.2.1-RELEASE" ]) && alreadyDownloaded=1
([ "${XCODE_VERSION}" == "7.3" ] && [ ${SWIFT_VERSION} == "2.2-RELEASE" ]) && alreadyDownloaded=1

if [ ${alreadyDownloaded} ] ; then
  echo "Swift ${SWIFT_SNAPSHOT} compatible with Xcode ${XCODE_VERSION}"
else
  # Install curl
  brew install wget > /dev/null || brew outdated wget > /dev/null || brew upgrade wget > /dev/null

  # Install Swift binaries
  # See http://apple.stackexchange.com/questions/72226/installing-pkg-with-terminal
  wget https://swift.org/builds/$SNAPSHOT_TYPE/xcode/$SWIFT_SNAPSHOT/$SWIFT_SNAPSHOT-osx.pkg
  sudo installer -pkg $SWIFT_SNAPSHOT-osx.pkg -target /
  export PATH=/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin:"${PATH}"
  rm $SWIFT_SNAPSHOT-osx.pkg
fi
