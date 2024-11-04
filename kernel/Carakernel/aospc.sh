AOSP_REPO="https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+/refs/heads/master"
AOSP_ARCHIVE="https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/master"
WORKSPACE_DIR="${PWD%/*}"
GCC_DIR="$WORKSPACE_DIR/gcc"
GCC64_DIR="$WORKSPACE_DIR/gcc64"
AC_DIR="$WORKSPACE_DIR/aospclang"

CURRENT_CLANG=$(curl $AOSP_REPO | grep -oE "clang-r[0-9a-f]+" | sort -u | tail -n1)
echo -e "\nINFO: Latest clang version: $CURRENT_CLANG"
# CURRENT_CLANG=clang-stable
if [ ! -d "$AC_DIR" ]; then
    echo -e "\nINFO: AOSP Clang not found! Cloning to $AC_DIR..."
    if ! curl -LSsO "$AOSP_ARCHIVE/$CURRENT_CLANG.tar.gz"; then
        echo -e "\nERROR: Cloning failed! Aborting..."
        exit 1
    fi
    mkdir -p $AC_DIR && tar -xf ./*.tar.gz -C $AC_DIR && rm ./*.tar.gz && rm -rf clang
    touch $AC_DIR/bin/aarch64-linux-gnu-elfedit && chmod +x $AC_DIR/bin/aarch64-linux-gnu-elfedit
    touch $AC_DIR/bin/arm-linux-gnueabi-elfedit && chmod +x $AC_DIR/bin/arm-linux-gnueabi-elfedit
    echo $CURRENT_CLANG > $WORKSPACE_DIR/aospclang_ver
else
    echo -e "\nINFO: Installed clang version: $(cat $WORKSPACE_DIR/aospclang_ver)"
    echo -e "\nINFO: AOSP Clang found! Checking for an update $AC_DIR..."
    if [ ! "$(cat $WORKSPACE_DIR/aospclang_ver)" = "$CURRENT_CLANG" ]; then
        echo -e "\nINFO: New version found! Cloning to $AC_DIR..."
        rm -rf $AC_DIR
        if ! curl -LSsO "$AOSP_ARCHIVE/$CURRENT_CLANG.tar.gz"; then
            echo -e "\nERROR: Cloning failed! Aborting..."
            exit 1
        fi
        mkdir -p $AC_DIR && tar -xf ./*.tar.gz -C $AC_DIR && rm ./*.tar.gz && rm -rf clang
        touch $AC_DIR/bin/aarch64-linux-gnu-elfedit && chmod +x $AC_DIR/bin/aarch64-linux-gnu-elfedit
        touch $AC_DIR/bin/arm-linux-gnueabi-elfedit && chmod +x $AC_DIR/bin/arm-linux-gnueabi-elfedit
    else
        echo -e "\nINFO: Clang is up-to-date!"
    fi
fi

# Clone gcc binutils if needed
if ! [ -d "$GCC_DIR" ]; then
    echo -e "\nINFO: GCC not found! Cloning to $GCC_DIR..."
    if ! git clone -q -b lineage-19.1 --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9 $GCC_DIR; then
        echo -e "\nERROR: Cloning failed! Aborting..."
        exit 1
    fi
fi

if ! [ -d "$GCC64_DIR" ]; then
    echo -e "\nINFO: GCC64 not found! Cloning to $GCC64_DIR..."
    if ! git clone -q -b lineage-19.1 --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9 $GCC64_DIR; then
        echo -e "\nERROR: Cloning failed! Aborting..."
        exit 1
    fi
fi