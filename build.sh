#!/bin/bash

# Cleanup the terminal
clear

# Export files paths
IMAGE=$(pwd)/out/arch/arm64/boot/Image.lz4
DTBO=$(pwd)/out/arch/arm64/boot/dts/google/dtbo.img
DTB=$(pwd)/dtb

# Store the current directory
CURRENT_DIR=$(pwd)

# Store the current clang version
CLANG_VERSION=llvm-17.0.1

# We use LLVM
export LLVM=1

if [ -e $CURRENT_DIR/${CLANG_VERSION} ]; then
    echo "Clang is already there, nothing to do"
    export LLVM_PATH=$CURRENT_DIR/${CLANG_VERSION}/bin/
else
    # Download and extract aosp-clang
    wget -q https://mirrors.edge.kernel.org/pub/tools/llvm/files/${CLANG_VERSION}-x86_64.tar.xz

    # Extract it
    tar -xf ${CLANG_VERSION}-x86_64.tar.xz

    # Rename it
    mv ${CLANG_VERSION}-x86_64 ${CLANG_VERSION}

    # Cleanup
    rm -rf ${CLANG_VERSION}-x86_64
    rm -rf ${CLANG_VERSION}-x86_64.tar.xz

    export LLVM_PATH=$CURRENT_DIR/${CLANG_VERSION}/bin/

    # Cleanup the terminal
    clear
fi

# Cleanup the terminal
clear

echo "==========================================================="
echo "                                                           "
echo "                Menu for LineageNeogen kernel                 "
echo "                                                           "
echo "==========================================================="
echo "                                                           "
echo "                    Select your options                    "
echo "                                                           "
echo "==========================================================="
echo "                                                           "
echo " 1.KernelSU                                                "
echo " 2.Magisk                                                  "
echo " 3.exit                                                    "
echo "                                                           "
echo "==========================================================="

# Select the options that you want
echo "Type your choise:"
read options
options=$options

# Execute the option kernelsu
if [ "$options" = "1" ]; then
    cd anykernel3
    # Cleanup previous compilation
    rm -rf *.zip
    rm -rf dtb && rm -rf dtbo.img && rm -rf Image.lz4
    cd ..
    # Export options
    export OPTIONS=kernelsu
    # Export zip name
    export ZIP_NAME=LineageNeogen-${OPTIONS}.zip
    curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -
    echo "CONFIG_KSU=y" >> $(pwd)/arch/arm64/configs/cloudripper_gki_defconfig
    make O=out cloudripper_gki_defconfig
    make O=out -kj$(nproc --all) -l$(nproc --all) V=$VERBOSE 2>&1 | tee error.log
    git restore arch/arm64/configs/cloudripper_gki_defconfig
fi

# Execute the option magisk
if [ "$options" = "2" ]; then
    cd anykernel3
    # Cleanup previous compilation
    rm -rf *.zip
    rm -rf dtb && rm -rf dtbo.img && rm -rf Image.lz4
    cd ..
    # Export options
    export OPTIONS=magisk
    # Export zip name
    export ZIP_NAME=LineageNeogen-${OPTIONS}.zip
    make O=out cloudripper_gki_defconfig
    make O=out -kj$(nproc --all) -l$(nproc --all) V=$VERBOSE 2>&1 | tee error.log
fi

# Execute the option exit
if [ "$options" = "3" ]; then
    exit 1
fi

echo "Compression start..."

if ! [ -a "$IMAGE" ];
    then
        echo "Build gives some errors"
        echo "Please check error.log for more informations"
        exit 1
    else
        cat out/arch/arm64/boot/dts/google/*.dtb > dtb
        mv $IMAGE anykernel3
        mv $DTBO anykernel3
        mv $DTB anykernel3
        cd anykernel3
        zip -r9 ${ZIP_NAME} *
        MD5CHECK=$(md5sum "$ZIP_NAME" | cut -d' ' -f1)
        echo "Compression is done"
        echo "Please check on anykernel3 for found your zip"
        cd ..
        # cleanup
        git reset --hard
        rm -rf out && rm -rf KernelSU && rm -rf drivers/kernelsu && rm -rf dtb && rm -rf error.log
fi
