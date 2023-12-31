#!/bin/bash
# SPDX-License-Identifier: GPL-2.0
BUILD_AOSP_KERNEL=0 \
BUILD_STAGING_KERNEL=1 \
GKI_KERNEL_DIR=aosp-staging \
GKI_KERNEL_REMOTE=partner-common \
GKI_KERNEL_BRANCH=`repo info aosp-staging | grep "Manifest revision" | sed 's/Manifest revision: //g'` \
BUILD_SCRIPT="./build_slider.sh" \
DEVICE_KERNEL_BUILD_CONFIG=private/gs-google/build.config.slider \
private/gs-google/update_symbol_list.sh "$@"
