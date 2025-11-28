/*
 * Linux system call interface for the AARCH64 processor.
 *
 * Permission to use, copy, modify, and distribute this software
 * is freely granted, provided that this notice is preserved.
 */

/* This defines all the syscall numnbers*/	
#include "linux-syscalls.h"
	
#define FUNC(name) .type name, %function; name:
#define SET .set
#define GLOBAL(name) .globl name; FUNC(name)
#define SIZE(name) .size name, .-name


# define SYSCALL(name) \
    GLOBAL(_ ## name); \
    mov x8, #SYS_ ## name; \
    svc #0; \
    cmn x0, #0x1, lsl #12; \
    cneg x0, x0, hi; \
    b.hi _set_errno; \
    ret

SYSCALL(openat)
SYSCALL(fchown)
SYSCALL(fchmod)
SYSCALL(unlinkat)

#ifdef FILESYSTEMS
SYSCALL(dup)
SYSCALL(dup2)
SYSCALL(link)
SYSCALL(lstat)
SYSCALL(mkdir)
SYSCALL(mknod)
SYSCALL(readlink)
SYSCALL(rmdir)
SYSCALL(fcntl)
SYSCALL(ftruncate)
SYSCALL(symlink)
SYSCALL(lchown)
SYSCALL(chdir)
SYSCALL(sync)
SYSCALL(truncate)
#endif

/* This is the minimum set required for Hello World! */
SYSCALL(write)
SYSCALL(reboot)
SYSCALL(wait4)
SYSCALL(brk)
SYSCALL(getpid)
SYSCALL(kill)
SYSCALL(fstat)
SYSCALL(exit)
SYSCALL(read)
SYSCALL(close)
SYSCALL(lseek)

/* These are for networking */
SYSCALL(socket)
SYSCALL(accept)
SYSCALL(connect)
SYSCALL(bind)
SYSCALL(listen)
SYSCALL(socketpair)
SYSCALL(shutdown);
SYSCALL(recvfrom);
SYSCALL(recvmsg);
SYSCALL(sendmsg);
SYSCALL(sendto);
SYSCALL(getsockopt);
SYSCALL(getsockname);
SYSCALL(getpeername);

/* These are for process syscalls */
SYSCALL(execve)
SYSCALL(getegid)
SYSCALL(geteuid)
SYSCALL(getgid)
SYSCALL(getgroups)
SYSCALL(getpgid)
SYSCALL(getuid)
SYSCALL(gettimeofday)
SYSCALL(nanosleep)
SYSCALL(setpgid)
SYSCALL(setgid)
SYSCALL(setsid)
SYSCALL(setuid)
SYSCALL(times)
SYSCALL(umask)
SYSCALL(uname)
SYSCALL(ioctl)
SYSCALL(sysinfo)

#define ALIAS(name) .globl name; SET name, _ ## name

ALIAS(alarm)
ALIAS(chdir)
ALIAS(chmod)
ALIAS(chown)
ALIAS(dup)
ALIAS(dup2)
ALIAS(ftruncate)
ALIAS(getdents)
ALIAS(getegid)
ALIAS(geteuid)
ALIAS(getgid)
ALIAS(getgroups)
ALIAS(getpgid)
ALIAS(getpgrp)
ALIAS(getuid)
ALIAS(ioctl)
ALIAS(lchown)
ALIAS(lstat)
ALIAS(mkdir)
ALIAS(mknod)
ALIAS(nanosleep)
ALIAS(pause)
ALIAS(pipe)
ALIAS(readlink)
ALIAS(rmdir)
ALIAS(select)
ALIAS(setgid)
ALIAS(setpgid)
ALIAS(setsid)
ALIAS(setuid)
ALIAS(sigprocmask)
ALIAS(stime)
ALIAS(symlink)
ALIAS(sync)
ALIAS(sysinfo)
ALIAS(truncate)
ALIAS(umask)
ALIAS(uname)
ALIAS(utime)
ALIAS(vfork)
ALIAS(wait4)
ALIAS(reboot)
ALIAS(socket)
ALIAS(connect)
ALIAS(accept)
ALIAS(bind)
ALIAS(listen)
ALIAS(socketpair)
ALIAS(shutdown);
ALIAS(recvfrom);
ALIAS(recvmsh);
ALIAS(sendmsg);
ALIAS(sendto);
ALIAS(getsockopt);
ALIAS(getsockname);
ALIAS(getpeername);
ALIAS(fchown)
ALIAS(unlinkat)
ALIAS(fchmod)
