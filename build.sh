nasm boot.asm && cat boot > plaatos
nasm fs.asm && cat fs >> plaatos
nasm kernel.asm && cat kernel >> plaatos
nasm hello.asm && cat hello >> plaatos
nasm about.asm && cat about >> plaatos
qemu-system-i386 -drive format=raw,file=plaatos