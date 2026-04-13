# build-lame-for-ios
将 LAME 源码编译为 iOS 可用的静态库

## 测试版本：lame-3.100
## 将 build-lame-for-ios.sh 脚本放入源码根目录下,修改脚本中第4行实际路径
## 打开终端 运行脚本：
```
chmod +x build-lame-for-ios.sh

./build-lame-for-ios.sh
```

脚本执行成功后，会在 lame-3.100 目录下生成一个 fat-lame 文件夹。你只需要将这个文件夹里的内容集成到你的 Xcode 项目中即可：
头文件: fat-lame/include/lame.h
静态库: fat-lame/lib/libmp3lame.a

## 可实现功能：将opus解码为pcm的数据转为mp3格式
