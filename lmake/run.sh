cd ..
clear
qemu-system-x86_64 -drive id=disk,file=OS.img,if=none -device ahci,id=ahci -device ide-hd,drive=disk,bus=ahci.0 -cpu max -m 4G -monitor stdio
cd ./lmake 