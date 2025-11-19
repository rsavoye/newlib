/* Linux system call interface.
 * Permission to use, copy, modify, and distribute this software
 * is freely granted, provided that this notice is preserved.
 */

#include <errno.h>
#include <stdint.h>
#include <sys/wait.h>
#include <unistd.h>

extern char _end[];
static void *curbrk = _end;

typedef int  pid_t;

extern void *_brk(void *addr);
void *_sbrk (long int);
extern int _reboot(int magic, int magic2, int flag, void *arg);
//extern pid_t wait4(pid_t pid, int *_Nullable wstatus, int options,
//                   struct rusage *_Nullable rusage);
extern pid_t wait(int *_Nullable wstatus);
extern void *_brk(void *addr);
extern pid_t _wait4(pid_t pid, int *status, int options, struct rusage *rusage);
extern int brk(void *addr);

/* This gets defined if using I/O functuions like printf, but not if just
   using systcalls.
*/
int *__attribute__((weak)) __errno (void) {}

pid_t wait(int *status)
{
        return _wait4(-1, status, 0, NULL);
}

pid_t waitpid(pid_t pid, int *status, int options)
{
        return _wait4(pid, status, options, NULL);
}

int brk(void *addr)
{
  void *newbrk;
  if (curbrk == addr)
    return 0;
  newbrk = _brk(addr);
  curbrk = newbrk;
  if (newbrk < addr) {
    errno = ENOMEM;
    return -1;
  }
  return 0;
}

void *_sbrk(intptr_t incr)
{
  void *oldbrk = curbrk;
  if (brk(oldbrk + incr) == -1)
    return (void *)-1;
  return oldbrk;
}
void *sbrk(intptr_t incr) __attribute__((alias("_sbrk")));

int _set_errno(int n)
{
  if (n < 0) {
    errno = -n;
    return -1;
  }
  return n;
}

// FIXME: These are needed for libgloss to link for AARCH64 Android
int _isatty(int flag)
{
  //return _reboot(0xfee1dead, 0x28121969, flag, NULL);
}

int _getentropy(int flag)
{
  //return _reboot(0xfee1dead, 0x28121969, flag, NULL);
}

int _open(int flag)
{
  //return _reboot(0xfee1dead, 0x28121969, flag, NULL);
}

extern int _reboot(int magic, int magic2, int flag, void *arg);

/* int reboot(int flag) */
/* { */
/*         return _reboot(0xfee1dead, 0x28121969, flag, NULL); */
/* } */
