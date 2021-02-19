Muticore benchmark

```
docker run -ti --rm slabko/numpy-bench
```

Singliecore benchmark
```
docker run -ti --rm -e MKL_NUM_THREADS=1 -e MKL_DYNAMIC=FALSE slabko/numpy-bench
```
