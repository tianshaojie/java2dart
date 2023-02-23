## java2dart.sh
>这是一个帮助把Java转成Dart的脚本程序，利用[Java和Dart语法映射规则](https://skyui.cn/blog/java-to-dart-common-rules.html)替换文件内容。

## 包括：
- 自动把Java语法替换成Dart语法
- 指定单个文件
- 指定文件夹（会自动寻找文件夹下的所有.java文件）
- 后缀重命名.java -> .dart

## 运行：

```
./java2dart.sh file
./java2dart.sh folder
```

## 注意：
脚本不能100%把Java转成Dart，目的是帮助减少人工重复劳动，若碰到需要完善的地方
- 可以通过Issues提交新的规则需求
- 可以提交Pull Requests
- 可以Fork添加自己的规则
