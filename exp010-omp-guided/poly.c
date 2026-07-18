/* exp010: poly kernel, schedule picked at runtime via OMP_SCHEDULE. build: see run.sh */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>

static void poly(double *a, const double *b, long n) {
  #pragma omp parallel for schedule(runtime)
  for (long i = 0; i < n; i++) {
    double x = b[i], acc = 0.0;
    for (int k = 0; k < 64; k++) acc = acc * x + 1.000000001;
    a[i] = acc;
  }
}

int main(int argc, char **argv) {
  if (argc != 3) { fprintf(stderr, "usage: %s n reps\n", argv[0]); return 1; }
  long n = atol(argv[1]);
  int reps = atoi(argv[2]);
  double *a = malloc(n * sizeof *a), *b = malloc(n * sizeof *b);
  for (long i = 0; i < n; i++) b[i] = 1.0 + 1e-9 * i;
  poly(a, b, n); /* warmup */
  double sum = 0.0, sq = 0.0;
  for (int r = 0; r < reps; r++) {
    double t0 = omp_get_wtime();
    poly(a, b, n);
    double ms = (omp_get_wtime() - t0) * 1e3;
    sum += ms; sq += ms * ms;
  }
  double mean = sum / reps, std = sqrt(fmax(0.0, sq / reps - mean * mean));
  const char *sched = getenv("OMP_SCHEDULE");
  printf("sched=%s threads=%d n=%ld reps=%d mean=%.3fms std=%.3fms gflops=%.1f\n",
         sched ? sched : "default", omp_get_max_threads(), n, reps,
         mean, std, 2.0 * 64 * n / (mean * 1e-3) / 1e9);
  return 0;
}
