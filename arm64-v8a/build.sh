#!/bin/bash

export ANDROID_NDK_HOME=~/Android/android-ndk-r16b
export CMAKE_HOME=~/Android/Sdk/cmake/3.6.4111459/bin
export NUMBER_OF_CORES=4
export PATH=$CMAKE_HOME:$PATH

ANDROID_CPU=arm64-v8a

if [[ “$@“ =~ "-d" ]];then
        echo "----------------------------cmake debug----------------------------"
cmake -DDEBUG=ON -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake \
      -DANDROID_NDK=$ANDROID_NDK_HOME \
      -DANDROID_ABI=$ANDROID_CPU \
      -DANDROID_TOOLCHAIN=clang \
      -DANDROID_PLATFORM=android-21 \
      -DANDROID_STL=gnustl_static \
	  ../../../source   
else      
        echo "----------------------------cmake release----------------------------"
cmake -DDEBUG=NO -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake \
      -DANDROID_NDK=$ANDROID_NDK_HOME \
      -DANDROID_ABI=$ANDROID_CPU \
      -DANDROID_TOOLCHAIN=clang \
      -DANDROID_PLATFORM=android-21 \
      -DANDROID_STL=gnustl_static \
	  ../../../source  
fi

sed -i 's/-lpthread/-pthread/' CMakeFiles/cli.dir/link.txt
sed -i 's/-lpthread/-pthread/' CMakeFiles/x265-shared.dir/link.txt
sed -i 's/-lpthread/-pthread/' CMakeFiles/x265-static.dir/link.txt

make
$ANDROID_NDK_HOME/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin/aarch64-linux-android-strip libx265.so
make DESTDIR=$(pwd)/build/$ANDROID_CPU install