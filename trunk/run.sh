if [ "$1" == "--clean" ]
then
  make clean
  rm -rf klee-* *.gcno *.gcda *.gcov ex? ex??
else
  make
  for PROGRAM in instcomb
  do
    echo ${PROGRAM}
    # compile program with gcov profiling
    gcc -L ../../Release+Asserts/lib ${PROGRAM}.c -lkleeRuntest -fprofile-arcs -ftest-coverage -o ${PROGRAM}

    # run klee without optimization flag
    if [ "$1" == "--print" ]
    then
      klee-original --print-before-all --libc=uclibc -use-query-log=solver:smt2 ${PROGRAM}.bc &> output-before.txt
    else
      klee-original --libc=uclibc -use-query-log=solver:smt2 ${PROGRAM}.bc
    fi
    klee-stats --print-all klee-last
    # run all generated test cases
    TEST=$(find ./klee-last/ -name *.ktest)
    rm -rf ${PROGRAM}.gcda
    for test_case in ${TEST}
    do
      KTEST_FILE=${test_case} ./${PROGRAM}
    done
    gcov -b -c ${PROGRAM}

    ## run klee with original optimization
    #if [ "$1" == "--print" ]
    #then
    #  klee-original --optimize --print-after-all --libc=uclibc ${PROGRAM}.bc
    #else
    #  klee-original --optimize --libc=uclibc ${PROGRAM}.bc
    #fi
    #klee-stats --print-all klee-last
    ## run all the generated test cases
    #TEST=$(find ./klee-last/ -name *.ktest)
    #rm -rf ${PROGRAM}.gcda
    #for test_case in ${TEST}
    #do
    #  KTEST_FILE=${test_case} ./${PROGRAM}
    #done
    #gcov -b -c ${PROGRAM}


    # run klee with single optimization flag
    if [ "$1" == "--print" ]
    then
      klee-flag --optimize -opt-flag=InstructionCombining  --print-after-all --libc=uclibc -use-query-log=solver:smt2 ${PROGRAM}.bc &> output-after.txt
      #klee-flag --optimize -opt-flag=PromoteMemoryToRegister,IndVarSimplify --print-after-all --libc=uclibc ${PROGRAM}.bc &> output-after.txt
    else
      #klee-flag --optimize -opt-flag=PromoteMemoryToRegister,IndVarSimplify --libc=uclibc ${PROGRAM}.bc
      klee-flag --optimize -opt-flag=InstructionCombining  --libc=uclibc -use-query-log=solver:smt2 ${PROGRAM}.bc
    fi

    #klee-flag --optimize -opt-flag=InstructionCombining  --libc=uclibc ${PROGRAM}.bc
    klee-stats --print-all klee-last
    # run all the generated test cases
    TEST=$(find ./klee-last/ -name *.ktest)
    rm -rf ${PROGRAM}.gcda
    for test_case in ${TEST}
    do
      KTEST_FILE=${test_case} ./${PROGRAM}
    done
    gcov -b -c ${PROGRAM}
  done
fi
