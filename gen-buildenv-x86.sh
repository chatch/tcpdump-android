#!/bin/bash

# --------------------------------------
#
#     Title: build-tcpdump
#    Author: Loic Poulain, loic.poulain@gmail.com
#
#   Purpose: download & build tcpdump for arm android platform
#
# You have to define your android NDK directory before calling this script
# example:
# $ export NDK=/home/Workspace/android-ndk-r10e
# $ sh build-tcpdump
#
# --------------------------------------

# default, edit versions
android_api_def=21
toolchain=x86-4.9
topdir=$(pwd)
buildenv_sh=$topdir/.buildenv.sh


ndk_dir_def=android-ndk-r10e

#-------------------------------------------------------#



if [ ${NDK} ]
then
	ndk_dir=${NDK}
else
	ndk_dir=${ndk_dir_def}
fi

ndk_dir=`readlink -f ${ndk_dir}`

if [ ${ANDROID_API} ]
then
	android_api=${ANDROID_API}
else
	android_api=${android_api_def}
fi

echo "_______________________"
echo ""
echo "NDK - ${ndk_dir}"
echo "Android API: ${android_api}"
echo "_______________________"


exit_error()
{
	echo " _______"
	echo "|       |"
	echo "| ERROR |"
	echo "|_______|"
	exit 1
}

{
	if [ $# -ne 0 ]
	then
		if [ -d $1 ]
		then
			cd $1
		else
			echo directory $1 not found
			exit_error
		fi
	else
		mkdir tcpdumpbuild
		cd tcpdumpbuild
	fi
}



# create env
{
	echo " ____________________"
	echo "|                    |"
	echo "| CREATING TOOLCHAIN |"
	echo "|____________________|"

	if [ -d toolchain ]
	then
		echo Toolchain already exist! Nothing to do.
	else
		echo Creating toolchain... ${toolchain}
		mkdir toolchain
		bash ${ndk_dir}/build/tools/make-standalone-toolchain.sh   --arch=x86 --toolchain=${toolchain} --platform=android-${android_api} --install-dir=toolchain
		
		if [ $? -ne 0 ]
		then
			rm -fr toolchain
#			exit_error
		fi
	fi

        echo "..."
        cross=$(find $topdir/tcpdumpbuild/toolchain/ -name "*-gcc" |awk -F '/' \
          '{printf("%s\n", $(NF))}' | sed -e 's/-gcc//' \
          )
        echo   export CC=${cross}-gcc > $buildenv_sh
        echo   export CXX=${cross}-g++ > $buildenv_sh
        echo   export AS=${cross}-as >> $buildenv_sh
        echo   export CFLAGS="\"-fPIE -pie\"" >> $buildenv_sh
	echo   export RANLIB=${cross}-ranlib >> $buildenv_sh
	echo   export AR=${cross}-ar >> $buildenv_sh
	echo   export LD=${cross}-ld >> $buildenv_sh
	echo   export STRIPE=${cross}-stripe >> $buildenv_sh
	echo   export PATH=`pwd`/toolchain/bin:$PATH >> $buildenv_sh
}


