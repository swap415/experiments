/* exp022: C mirrors of the corpus kernels — semantics, constants and
 * loop structure identical to the numba builders (exp013/exp018).
 * Build: clang-18 -O3 -march=native -ffast-math -shared -fPIC */

void saxpy(double *a, const double *b, long n) {
    for (long i = 0; i < n; i++)
        a[i] = 2.0 * b[i] + a[i];
}

void poly96(double *a, const double *b, long n) {
    for (long i = 0; i < n; i++) {
        double x = b[i], acc = 0.1;
        for (int j = 0; j < 96; j++)
            acc = acc * x + 1.0001;
        a[i] = acc;
    }
}

void poly112(double *a, const double *b, long n) {
    for (long i = 0; i < n; i++) {
        double x = b[i], acc = 0.1;
        for (int j = 0; j < 112; j++)
            acc = acc * x + 1.0001;
        a[i] = acc;
    }
}

double reduction64(const double *b, long n) {
    double s = 0.0;
    for (long i = 0; i < n; i++) {
        double x = b[i], acc = 0.3;
        for (int j = 0; j < 64; j++)
            acc = acc * x + 1.0001;
        s += acc;
    }
    return s;
}

void stencil64(double *a, const double *b, const double *w, long n) {
    for (long i = 0; i < n - 64; i++) {
        double acc = 0.0;
        for (int k = 0; k < 64; k++)
            acc = acc + b[i + k] * w[k];
        a[i] = acc;
    }
}

void gather64(double *a, const double *b, const long *idx, const double *w,
              long n) {
    for (long i = 0; i < n; i++) {
        double acc = 0.0;
        for (int k = 0; k < 64; k++)
            acc = acc + b[idx[k] + (i & 7)] * w[k];
        a[i] = acc;
    }
}
