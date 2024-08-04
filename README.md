# matting-flutter-demo

![模拟器运行截图](screenshot.png)

## 编译运行

iOS需先下载[opencv-4.10.0-ios-framework.zip](https://github.com/opencv/opencv/releases/download/4.10.0/opencv-4.10.0-ios-framework.zip)文件，解压缩得`opencv2.framework`文件，将它移动到`/matting_plugin/ios/libs`中去。后续常规编译运行`/matting`Flutter项目。

在下面iOS开发环境中编译运行成功：
1. Intel Mac with macOS 13.6.3
2. Xcode 15.2 with iOS 17.2 模拟器
3. Flutter 3.22.3

Android也是类似，JNI调用OpenCV C++代码，因家庭电脑存储空间不足，未安装配置相应开发环境进行实现。

最好维护同一套OpenCV C++代码，供插件的双端原生调用。
