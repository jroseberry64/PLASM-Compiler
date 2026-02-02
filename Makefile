build_kernal:
	./plasm X16Kernal_IO.pl0 X16Kernal_IO

build_vera:
	./plasm X16_VERA.pl0 X16_VERA

build_string:
	./plasm String.pl0 String 

build_tst1:
	./plasm test1.pl0 test1

build_tst2:
	./plasm test2.pl0 test2

output_x16prg:
	ca65 test1.asm -o test1.o -t cx16
	cl65 -o main.prg -u __EXEHDR__ -t cx16 -C cx16-asm.cfg test1.o
