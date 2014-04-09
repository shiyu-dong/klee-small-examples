if [ "$1" == "--clean" ]
then
  rm -rf *.o klee-out-* klee-last
else
  rm -rf *.o klee-out-* klee-last

  llvm-gcc -I ../../include -emit-llvm -c -g -std=c99 *.c

  # without optimization
  echo "=============================================="
  echo "No Optimization "
  echo "=============================================="
  klee *.o
  klee-stats --print-all klee-last

  # with optimization but no flag
  echo "=============================================="
  echo "Empty Optimization, no flag"
  echo "=============================================="
  klee --optimize *.o
  klee-stats --print-all klee-last

  #compare different optimizations for one program
  for OPT in \
    AggressiveDCE \
    ArgumentPromotion \
    CFGSimplification \
    CondPropagation \
    ConstantMerge \
    DeadArgElimination \
    DeadStoreElimination \
    DeadTypeElimination \
    FunctionAttrs \
    FunctionInlining \
    GlobalDCE \
    GlobalOptimizer \
    GVN \
    IndVarSimplify \
    InstructionCombining \
    IPConstantPropagation \
    JumpThreading \
    LICM \
    LoopDeletion \
    LoopIndexSplit \
    LoopRotate \
    LoopUnroll \
    LoopUnswitch \
    MemCpyOpt \
    PromoteMemoryToRegister \
    PruneEH \
    RaiseAllocation \
    Reassociate \
    ScalarReplAggregates \
    SCCP \
    SimplifyLibCalls \
    StripDeadPrototypes \
    TailCallElimination
  do
    echo "=============================================="
    echo "Optimization with flag: "${OPT}
    echo "=============================================="
    klee --optimize -opt-flag=${OPT} *.o
    klee-stats --print-all klee-last
  done
fi
