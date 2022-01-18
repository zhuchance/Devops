**###

这个项目是用来收藏日常学习和工作常用的技巧

*SimpleInstall*目录是常用的快速安装脚本，目前添加了快速安装docker的shell脚本

*docker-images*是放常用docker镜像的

1. nginx
这个nginx基于alpine镜像，添加了busybox-extras使之可以执行常用的ping、telnet、curl、netstart，vi等；修改时区为Shanghai。
  ```bash
  ##hub #
  docker pull zhuchance/nginx:alpine
  ##aliyun #
  docker pull registry.cn-hangzhou.aliyuncs.com/cou/nginx
  ```
