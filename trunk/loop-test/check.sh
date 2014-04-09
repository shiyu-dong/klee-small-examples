./clean.sh
for PROGRAM in loop-fusion-before loop-fusion-after
do
  echo ${PROGRAM}" cache off"
	llvm-gcc -I ../../include -emit-llvm -c -g -std=c99 ${PROGRAM}.c
  klee --use-cache=false --use-cex-cache=false ${PROGRAM}.o
  klee-stats --print-all klee-last

  echo ${PROGRAM}" optimized by klee cache off"
  klee --use-cache=false --use-cex-cache=false --optimize ${PROGRAM}.o
  klee-stats --print-all klee-last

  echo ${PROGRAM}" optimized by klee-test cache off"
  klee-test --use-cache=false --use-cex-cache=false --optimize ${PROGRAM}.o
  klee-stats --print-all klee-last
  
  echo ""
done

./clean.sh
for PROGRAM in loop-unrolling-before loop-unrolling-after

do
  echo "PROGRAM: "${PROGRAM} 
	llvm-gcc -I ../../include -emit-llvm -c -g -std=c99 ${PROGRAM}.c
  echo "klee without optimization with cache off"
  klee --use-cache=false --use-cex-cache=false ${PROGRAM}.o
  klee-stats --print-all klee-last
  echo "klee with optimizaiton with cache off"
  klee --use-cache=false --use-cex-cache=false --optimize ${PROGRAM}.o
  klee-stats --print-all klee-last
  echo "klee test with optimization with cache off"
  klee-test --use-cache=false --use-cex-cache=false --optimize ${PROGRAM}.o
  klee-stats --print-all klee-last
done

#for PROGRAMOP in loop-unrolling-before loop-unrolling-after
#do
#  echo "PROGRAM: "${PROGRAMOP}" optimized"
#	llvm-gcc -O3 -I ../../include -emit-llvm -c -g -std=c99 ${PROGRAMOP}.c
#  klee ${PROGRAMOP}.o
#  klee-stats --print-all klee-last
#done

./clean.sh
for PROGRAM in simple-loop-1 simple-loop-2

do
  echo "PROGRAM: "${PROGRAM}"cache off"
	llvm-gcc -I ../../include -emit-llvm -c -g -std=c99 ${PROGRAM}.c
  klee --use-cache=false --use-cex-cache=false ${PROGRAM}.o
  klee-stats --print-all klee-last
  echo "PROGRAM: "${PROGRAM}"cache on"
  klee ${PROGRAM}.o
  klee-stats --print-all klee-last
done

for PROGRAMOP in simple-loop-1 simple-loop-2
do
  echo "PROGRAM: "${PROGRAMOP}" optimized by klee cache off"
  klee --use-cache=false --use-cex-cache=false --optimize ${PROGRAMOP}.o
  klee-stats --print-all klee-last
  echo "PROGRAM: "${PROGRAMOP}" optimized by klee cache on"
  klee --optimize ${PROGRAM}.o
  klee-stats --print-all klee-last
done

for PROGRAMOP in simple-loop-1 simple-loop-2
do
  echo "PROGRAM: "${PROGRAMOP}" optimized by klee-test cache off"
  klee-test --use-cache=false --use-cex-cache=false --optimize ${PROGRAMOP}.o
  klee-stats --print-all klee-last
  echo "PROGRAM: "${PROGRAMOP}" optimized by klee-test cache on"
  klee-test --optimize ${PROGRAM}.o
  klee-stats --print-all klee-last
done
#for PROGRAMOP in simple-loop-1 simple-loop-2
#do
#  echo "PROGRAM: "${PROGRAMOP}" optimized by -O3 cache off"
#	llvm-gcc -O3 -I ../../include -emit-llvm -c -g -std=c99 ${PROGRAMOP}.c
#  klee --use-cache=false --use-cex-cache=false --optimize ${PROGRAMOP}.o
#  klee-stats --print-all klee-last
#  echo "PROGRAM: "${PROGRAMOP}" optimized by -O3 cache on"
#  klee ${PROGRAM}.o
#  klee-stats --print-all klee-last
#done

max=51
#compare different program for no-optimization
rm -rf *.o *.out
echo NO Optimization
for PROGRAM in loop-unrolling-with-input-before loop-unrolling-with-input-after
do
  gcc -w -std=c99 ${PROGRAM}.c -o ${PROGRAM}.o
done

for i in `seq -1 $max`
do
  for j in `seq -1 $max`
  do
    for PROGRAM in loop-input loop-lr-input
    do
      ./${PROGRAM}.o $i $j > ${PROGRAM}.out
    done

    for file in ./*.out
    do
      diff "$file" loop-input.out
    done

  done
done

#compare different program for different-optimizations, one at a time
for OPT in -O1 -O2 -O3
do
  echo ${OPT}
  for PROGRAM loop-unrolling-with-input-before loop-unrolling-with-input-after
  do
    gcc ${OPT} -w -std=c99 ${PROGRAM}.c -o ${PROGRAM}.o
  done

  for i in `seq -1 $max`
  do
    for j in `seq -1 $max`
    do
      for PROGRAM in loop-input loop-lr-input
      do
        ./${PROGRAM}.o $i $j > ${PROGRAM}.out
      done
      for file in ./*.out
      do
        diff "$file" loop-input.out
      done
    done
  done
done
rm -rf *.o *.out
