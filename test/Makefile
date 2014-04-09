all: compile
	klee --optimize -opt-flag=RaiseAllocation,CFGSimplification,InstructionCombining *.o
	klee-stats --print-all klee-last

compile:
	llvm-gcc -I ../../include -emit-llvm -c -g -std=c99 *.c

disable-all-cache: compile
	klee --use-cache=false --use-cex-cache=false *.o
	klee-stats --print-all klee-last

disable-cache-only: compile
	klee --use-cache=false *.o
	klee-stats --print-all klee-last

disable-cex-cache-only: compile
	klee --use-cex-cache=false *.o
	klee-stats --print-all klee-last

clean:
	rm -rf klee* *.o
