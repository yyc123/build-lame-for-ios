#!/bin/sh

# 1. 【关键】修改为你的 lame-3.100 源码目录的绝对路径
YOUR_LOCAL_PATH="/Users/yueyongchao/Desktop/项目/lame-3.100"

# 2. 定义要编译的架构，arm64用于真机，x86_64用于模拟器
ARCHS="arm64 x86_64"

# 3. 定义编译配置
CONFIGURE_FLAGS="--disable-shared --disable-frontend"
CWD=`pwd`
THIN_DIR="$CWD/thin-lame"
FAT_DIR="$CWD/fat-lame"

# 4. 开始循环编译各个架构
for ARCH in $ARCHS
do
    echo "========== 开始编译架构: $ARCH =========="
    
    # 创建临时工作目录
    mkdir -p "$THIN_DIR/$ARCH"
    cd "$THIN_DIR/$ARCH"

    # 根据架构类型设置不同的编译参数
    if [ "$ARCH" = "x86_64" ]
    then
        # 模拟器 (Simulator)
        PLATFORM="iphonesimulator"
        MIN_VERSION="-mios-simulator-version-min=11.0"
        HOST="x86_64-apple-darwin"
    else
        # 真机 (Device)
        PLATFORM="iphoneos"
        MIN_VERSION="-miphoneos-version-min=11.0"
        HOST="arm-apple-darwin"
    fi

    # 设置编译器
    CC="xcrun -sdk $PLATFORM clang -arch $ARCH"
    CFLAGS="-arch $ARCH $MIN_VERSION"
    LDFLAGS="$CFLAGS"

    # 执行配置、编译和安装
    "$YOUR_LOCAL_PATH/configure" \
        $CONFIGURE_FLAGS \
        --host=$HOST \
        --prefix="$THIN_DIR/$ARCH" \
        CC="$CC" CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS"

    make clean
    make -j8
    make install
    
    cd $CWD
done

# 5. 合并架构，生成通用的 Fat 静态库
echo "========== 开始合并架构 =========="
mkdir -p "$FAT_DIR/lib"
cp -rf "$THIN_DIR/arm64/include" "$FAT_DIR"

# 使用 lipo 工具合并 .a 文件
lipo -create \
    "$THIN_DIR/arm64/lib/libmp3lame.a" \
    "$THIN_DIR/x86_64/lib/libmp3lame.a" \
    -output "$FAT_DIR/lib/libmp3lame.a"

echo "========== 编译完成 =========="
echo "最终产物位于: $FAT_DIR"
echo "请将 $FAT_DIR/include 目录和 $FAT_DIR/lib/libmp3lame.a 文件导入你的 Xcode 项目中。"
