cd ../boot
nasm bootsec.s -f bin -o bootsec.bin

cd ../kernel
nasm kernel.s -f bin -o kernel.bin
ls -lh ./*.bin

cd ..
cat boot/bootsec.bin kernel/kernel.bin 1,44mb.img> tmp.img
dd if=tmp.img of=OS.img bs=512 count=2880

rm -f tmp.img
rm -f ./kernel/kernel.bin
rm -f ./boot/boot.bin

cd ./lmake