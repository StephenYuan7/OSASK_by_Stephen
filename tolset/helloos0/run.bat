# 应该是把helloos复制到qemu能启动的文件中
copy helloos.img ..\z_tools\qemu\fdimage0\bin
# 用make启动qemu模拟器
..\z_tools\make.exe -C ../z_tools/qemu