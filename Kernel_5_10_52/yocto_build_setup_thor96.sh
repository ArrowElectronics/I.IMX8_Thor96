#!/bin/bash


#----------------------------------------------------------------------------------------------------------------
#  Yocto setup build script
#----------------------------------------------------------------------------------------------------------------
#  The script will create Yocto environment which is require to build the system.
#
#----------------------------------------------------------------------------------------------------------------

YOCTO_DIR="$(pwd)"
SOURCE_DIR="$(pwd)/imx-yocto-bsp/sources"
SD_CARD_IMG="$(pwd)/imx-yocto-bsp/build-xwayland-thor96/tmp/deploy/images/imx8mqthor96/imx-image-full-imx8mqthor96.wic.bz2"
red=`tput setaf 1`
green=`tput setaf 2`
bold=`tput bold`
reset=`tput sgr0`

meta_qt5_head=a00af3eae082b772469d9dd21b2371dd4d237684
meta_imx_head=426311a3f4e6936125c0599a34d8f6133dd2460d
meta_openembedded_head=5a4b2ab29d38c02535f24d5308cc40615739f557
meta_browser_head=8be1d3a0ba0cf32e61144900597207af5698c10d

# Required packages to build
# Install all the required build HOST packages
prerequisite()
{
	echo "###################################################################################"
	echo "Checking for required host packages and if not installed then install it..."
	echo "###################################################################################"

	sudo apt-get install repo gcc g++ gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat cpio python python3 libsdl1.2-dev xterm sed cvs subversion coreutils texi2html docbook-utils python3-pip python3-pexpect python3-jinja2 python3-git python-pip python-pysqlite2 xz-utils debianutils iputils-ping help2man make desktop-file-utils libgl1-mesa-dev libglu1-mesa-dev mercurial autoconf automake groff curl lzop asciidoc u-boot-tools libegl1-mesa pylint3 -y

	if [ $? -ne 0 ]
	then
		echo "[ERROR] : Failed to get required HOST packages. Please correct error and try again."
		exit -1
	fi

	git lfs > /dev/null
	if [ $? -ne 0 ]
	then
		curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
		sudo apt-get install git-lfs -y
		git lfs install
	fi
	echo "###################################################################################"
	echo "Required HOST packages successfully installed."
	echo "###################################################################################"
}


# To get the BSP you need to have `repo` installed.
# Install the `repo` utility. (only need to do this once)
create_repo()
{
	# create ~/bin if not there
	mkdir -p ~/bin

	echo "###################################################################################"
	echo "Creating repo..."
	echo "###################################################################################"
	curl https://storage.googleapis.com/git-repo-downloads/repo  > ~/bin/repo

	sudo chmod a+x ~/bin/repo
	export PATH=~/bin:$PATH
}


# Download the Yocto Project Environment into your directory
download_imx_repo()
{
	echo "###################################################################################"
	echo "Creating yocto setup..."
	echo "###################################################################################"
	mkdir $YOCTO_DIR/imx-yocto-bsp
	cd $YOCTO_DIR/imx-yocto-bsp
	if [ -d .repo ];
	then
		echo "Yocto imx repo is already setup. No need to do anything."
	else
		echo "###################################################################################"
		echo "Download the yocto repo"
		echo "###################################################################################"
		repo init -u https://source.codeaurora.org/external/imx/imx-manifest -b imx-linux-hardknott -m imx-5.10.52-2.1.0.xml
		echo "###################################################################################"
		echo "Sync downloaded repo. Please wait..."
		echo "###################################################################################"
		repo sync
		if [[ $? -eq 0 ]]; then
			echo "repo sync sucessfull..."
		else
			echo "${red}Error in repo sync. Please correct the error manually and try again.${reset}"
			sudo rm -r .repo
			exit -1
		fi
	fi
}

setup_ml_data_models()
{
	wget https://github.com/ArrowElectronics/meta-einfochips/releases/download/v4.0-imx/ML-data-models_v4.zip
	if [ $? -ne 0 ]
	then
		echo "###################################################################################"
		echo "${red}Error during download the ML-data-models.zip${reset}"
		echo "###################################################################################"
		exit 1
	fi
	unzip ML-data-models_v4.zip > /dev/null
	if [ $? -ne 0 ]
	then
		echo "###################################################################################"
		echo "${red}Error during extract the ML-data-models.zip${reset}"
		echo "###################################################################################"
		exit 1
	fi
	cp -r $SOURCE_DIR/ML-data-models/*.whl $SOURCE_DIR/meta-einfochips/recipes-extended/ml-sdk/files/
	cp -r $SOURCE_DIR/ML-data-models/armnn $SOURCE_DIR/meta-einfochips/recipes-extended/ml-sdk/files/
	cp -r $SOURCE_DIR/ML-data-models/recipes-qt5/examples/videohmiapp/ $SOURCE_DIR/meta-einfochips/recipes-qt5/examples/
	cp -r $SOURCE_DIR/ML-data-models/ARROW_DEMOS/ai-crowd_count/demo/* $SOURCE_DIR/meta-einfochips/recipes-extended/ml-sdk/files/ARROW_DEMOS/ai-crowd_count/demo/
	cp -r $SOURCE_DIR/ML-data-models/ARROW_DEMOS/crowd-counting-using-tensorflow/* $SOURCE_DIR/meta-einfochips/recipes-extended/ml-sdk/files/ARROW_DEMOS/crowd-counting-using-tensorflow/
	cp -r $SOURCE_DIR/ML-data-models/ARROW_DEMOS/face_recognition/* $SOURCE_DIR/meta-einfochips/recipes-extended/ml-sdk/files/ARROW_DEMOS/face_recognition/
	cp -r $SOURCE_DIR/ML-data-models/ARROW_DEMOS/real-time-object-detection/* $SOURCE_DIR/meta-einfochips/recipes-extended/ml-sdk/files/ARROW_DEMOS/real-time-object-detection/
	cp -r $SOURCE_DIR/ML-data-models/ARROW_DEMOS/TFLite-armnn/handwritten_char_rec_demo/* $SOURCE_DIR/meta-einfochips/recipes-extended/ml-sdk/files/ARROW_DEMOS/TFLite-armnn/handwritten_char_rec_demo/
}
# Apply patches
apply_patch()
{
	cd $SOURCE_DIR
	echo "###################################################################################"
	echo "Download meta-einfochips layer please wait..."
	echo "###################################################################################"

	if [ ! -d meta-einfochips ]
	then
		git clone https://github.com/ArrowElectronics/meta-einfochips.git -b thor96-linux-5.10
		if [ $? -ne 0 ]
		then
			echo "###################################################################################"
			echo "${red}Error during git clone the meta-einfochips${reset}"
			echo "###################################################################################"
			sudo rm -r meta-einfochips
			exit 1
		fi
		setup_ml_data_models
	fi

	if [ ! -d meta-quectel-community ]
	then
		cp -r $YOCTO_DIR/Thor96_L5_10_52_Rel_4_4_1_patches/meta-quectel-community/ .
		if [ $? -ne 0 ]
		then
			echo "###################################################################################"
			echo "${red}Error during apply the patch in meta-quectel-community"
			echo "Please verify Thor96_L5_10_52_Rel_4_4_1_patches directory${reset}"
			echo "###################################################################################"
			exit 1
		fi
	fi

        if [ ! -d meta-einfochips-ap1302 ]
        then
                cp -r $YOCTO_DIR/Thor96_L5_10_52_Rel_4_4_1_patches/meta-einfochips-ap1302/ .
                if [ $? -ne 0 ]
                then
                        echo "###################################################################################"
                        echo "${red}Error during apply the patch in meta-einfochips-ap1302"
                        echo "Please verify Thor96_L5_10_52_Rel_4_4_1_patches directory${reset}"
                        echo "###################################################################################"
                        exit 1
                fi
        fi

	# Apply patches
	cd $SOURCE_DIR/meta-imx/
	git apply --check -R $YOCTO_DIR/Thor96_L5_10_52_Rel_4_4_1_patches/meta-imx-patch/00* 2>/dev/null
	if [ $? -ne 0 ]
	then
		echo "###################################################################################"
		echo "Apply the patch in meta-imx"
		echo "###################################################################################"
		git checkout -f $meta_imx_head
		git am --whitespace=fix $YOCTO_DIR/Thor96_L5_10_52_Rel_4_4_1_patches/meta-imx-patch/00*
		if [ $? -ne 0 ]
		then
			echo "###################################################################################"
			echo "${red}Error during apply the patch in meta-imx"
			echo "Please verify Thor96_L5_10_52_Rel_4_4_1_patches directory${reset}"
			echo "###################################################################################"
			git format-patch $meta_imx_head
			exit 1
		fi
	fi

	# Apply patches
	cd $SOURCE_DIR/meta-qt5/
	git apply --check -R $YOCTO_DIR/Thor96_L5_10_52_Rel_4_4_1_patches/meta-qt5-patch/00* 2>/dev/null
	if [ $? -ne 0 ]
	then
		echo "###################################################################################"
		echo "Apply the patch in meta-qt5"
		echo "###################################################################################"
		git checkout -f $meta_qt5_head
		git am --whitespace=fix $YOCTO_DIR/Thor96_L5_10_52_Rel_4_4_1_patches/meta-qt5-patch/00*
		if [ $? -ne 0 ]
		then
			echo "###################################################################################"
			echo "${red}Error during apply the patch in meta-qt5"
			echo "Please verify Thor96_L5_10_52_Rel_4_4_1_patches directory${reset}"
			echo "###################################################################################"
			git format-patch $meta_qt5_head
			exit 1
		fi
	fi

	cd $SOURCE_DIR/meta-openembedded
	git apply --check -R $YOCTO_DIR/Thor96_L5_10_52_Rel_4_4_1_patches/meta-openembedded-patch/00* 2>/dev/null
	if [ $? -ne 0 ]
	then
		echo "###################################################################################"
		echo "Apply the patch in meta-openembedded"
		echo "###################################################################################"
		git checkout -f $meta_openembedded_head
		git am --whitespace=fix $YOCTO_DIR/Thor96_L5_10_52_Rel_4_4_1_patches/meta-openembedded-patch/00* 2>/dev/null
		if [ $? -ne 0 ]
		then
			echo "###################################################################################"
			echo "${red}Error during apply the patch in meta-openembedded"
			echo "Please verify Thor96_L5_10_52_Rel_4_4_1_patches directory${reset}"
			echo "###################################################################################"
			git format-patch $meta_openembedded_head
			exit 1
		fi
	fi

	cd $SOURCE_DIR/meta-browser
	git apply --check -R $YOCTO_DIR/Thor96_L5_10_52_Rel_4_4_1_patches/meta-browser-patch/00* 2>/dev/null
	if [ $? -ne 0 ]
	then
		echo "###################################################################################"
		echo "Apply the patch in meta-browser"
		echo "###################################################################################"
		git checkout -f $meta_browser_head
		git am --whitespace=fix $YOCTO_DIR/Thor96_L5_10_52_Rel_4_4_1_patches/meta-browser-patch/00*
		if [ $? -ne 0 ]
		then
			echo "###################################################################################"
			echo "${red}Error during apply the patch in meta-browser"
			echo "Please verify Thor96_L5_10_52_Rel_4_4_1_patches directory${reset}"
			echo "###################################################################################"
			git format-patch $meta_browser_head
			exit 1
		fi
	fi
}

# Build an image
build_image()
{
	cd $YOCTO_DIR/imx-yocto-bsp/

	# Run Yocto setup
	# [MACHINE=<machine>] [DISTRO=fsl-imx-<backend>] source ./fsl-setup-release.sh -b bld-<backend>
	EULA=1 DISTRO=fsl-imx-xwayland MACHINE=imx8mqthor96 source imx-setup-release.sh -b build-xwayland-thor96

	echo "${green}###################################################################################"
	echo "Starting SD card image build now. If the image is build first time then It will take a long time (approx 7 to 8 hrs) to finish."
	echo "***Build time may vary base on your HOST PC configurations"
	echo "***Build log show on console"
	echo "###################################################################################${reset}"
	bitbake imx-image-full
	if [ $? -ne 0 ];then
		echo "${red}[ERROR] : Error in building the image. Please see the error log for resolution.${reset}"
		bitbake imx-image-full -c cleansstate
		exit 1
	else
		echo "${green}${bold}###################################################################################"
		echo "SD card image build successfully"
		echo "You can find imx-image-full-imx8mqthor96.wic.bz2 image at below location"
		echo "$(pwd)/tmp/deploy/images/imx8mtho96/"
		echo "###################################################################################${reset}"
	fi
}

#--------------------------
# Main execution starts here
#---------------------------

echo "${green}${bold}########### Yocto setup script used to setup environment automatically ############"
echo "NOTE:: It's one time setup script if you want to change and build any package(i.e kernel,uboot...) after the setup"
echo "       Please do this manually by refering the board user guide"
echo "###################################################################################${reset}"
sleep 5
if [ -f "$SD_CARD_IMG" ]
then
	echo "${green}###################################################################################"
	echo "SD card image imx-image-full-imx8mqthor96.wic.bz2 exists. Your yocto setup is already up to date"
	echo "###################################################################################${reset}"
else
	# Check prerequisite
	prerequisite

	# create repo
	create_repo
	sync

	# Setup Yocto environment
	download_imx_repo
	sync

	# Apply patches
	apply_patch

	# Build an image
	build_image

	echo "${green}${bold}########## Build script ended successfully ##########${reset}"
fi
