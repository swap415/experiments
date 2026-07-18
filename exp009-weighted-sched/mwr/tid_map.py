"""MWR: map workqueue pool threads to /proc/self/task TIDs and divisions."""
import ctypes, os, threading
import numpy as np
import llvmlite.binding as ll

libc = ctypes.CDLL(None)
ll.add_symbol('ext_gettid', ctypes.cast(libc.gettid, ctypes.c_void_p).value)
ll.add_symbol('ext_getcpu', ctypes.cast(libc.sched_getcpu, ctypes.c_void_p).value)

from numba import njit, prange, types, get_num_threads
from numba.np.ufunc import parallel

main_tid = threading.get_native_id()
before = set(int(t) for t in os.listdir('/proc/self/task'))
parallel._launch_threads()
after = set(int(t) for t in os.listdir('/proc/self/task'))
pool_tids = sorted(after - before)

ext_gettid = types.ExternalFunction('ext_gettid', types.int32())
ext_getcpu = types.ExternalFunction('ext_getcpu', types.int32())

@njit(parallel=True)
def who(tid, cpu):
    for i in prange(tid.shape[0]):
        tid[i] = ext_gettid()
        cpu[i] = ext_getcpu()

n = get_num_threads()
tid = np.zeros(n, dtype=np.int32)
cpu = np.zeros(n, dtype=np.int32)
who(tid, cpu)   # compile + first run
who(tid, cpu)   # warm pool, steady state
final = set(int(t) for t in os.listdir('/proc/self/task'))

print('num_threads:', n)
print('main_tid:', main_tid, '(pid: %d)' % os.getpid())
print('pool_tids (sorted):', pool_tids)
print('division i -> tid:', list(tid))
print('division i -> cpu:', list(cpu))
print('n_pool_tids:', len(pool_tids))
print('main executes a division:', main_tid in tid)
print('division i == pool_tids[i] for all i:', all(tid[i] == pool_tids[i] for i in range(n)))
print('threads created after pool launch:', sorted(final - after))
