build_kernal:
	./plasm X16Kernal_IO.pl0 X16Kernal_IO

build_vera:
	./plasm X16_VERA.pl0 X16_VERA

build_string:
	./plasm String.pl0 String 

build_tst:
	./plasm test1.pl0 test1

output_x16prg:
	ca65 main.asm -o main.o -t cx16
	cl65 -o main.prg -u __EXEHDR__ -t cx16 -C cx16-asm.cfg main.o