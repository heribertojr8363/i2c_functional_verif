database -open waves -shm
probe -create tst_bench_top -depth all -all -memories -shm -database waves
run 18 ms -absolute
exit
