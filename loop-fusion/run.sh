if [ "$1" == "--clean" ]
then
  make clean
  rm -rf klee-* *.gcno *.gcda *.gcov ex? ex?? loop-fusion-before loop-fusion-after
else
  make
  for PROGRAM in loop-fusion-before loop-fusion-after
  do
    echo ${PROGRAM}
    # compile program with gcov profiling
    gcc -L ../../../Release+Asserts/lib ${PROGRAM}.c -lkleeRuntest -fprofile-arcs -ftest-coverage -o ${PROGRAM}

    # run klee without optimization flag
    klee-original --libc=uclibc --use-cache=false --use-cex-cache=false ${PROGRAM}.bc
    klee-stats --print-all klee-last
    # run all generated test cases
    TEST=$(find ./klee-last/ -name *.ktest)
    rm -rf ${PROGRAM}.gcda
    for test_case in ${TEST}
    do
      KTEST_FILE=${test_case} ./${PROGRAM}
    done
    gcov -b -c ${PROGRAM}
  done
fi
