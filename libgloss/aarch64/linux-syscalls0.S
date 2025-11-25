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


# define SYSCALL4(name) \
    GLOBAL(_ ## name); \
    mov x8, #SYS_ ## name; \
    svc #0; \
    cmn x0, #0x1, lsl #12; \
    cneg x0, x0, hi; \
    b.hi _set_errno; \
    ret

#define SYSCALL0(name) SYSCALL3(name)
#define SYSCALL3(name) SYSCALL4(name)
#define SYSCALL1(name) SYSCALL3(name)
#define SYSCALL2(name) SYSCALL3(name)
#define SYSCALL5(name) SYSCALL4(name)


SYSCALL3(openat)
// SYSCALL2(fstat) uneeded
// SYSCALL3(lseek) uneeded
// SYSCALL2(fstat) uneeded
// SYSCALL2(stat)

SYSCALL3(fchown)
SYSCALL3(fchmod)
SYSCALL1(unlinkat)

#ifdef FILESYSTEMS
SYSCALL1(dup)
SYSCALL2(dup2)
SYSCALL2(link)
SYSCALL2(lstat)
SYSCALL2(mkdir)
SYSCALL3(mknod)
SYSCALL3(readlink)
SYSCALL1(rmdir)
SYSCALL3(fcntl)
SYSCALL2(ftruncate)
SYSCALL2(symlink)
SYSCALL3(lchown)
SYSCALL1(chdir)
SYSCALL1(sync)
SYSCALL2(truncate)
#endif

/* This is the minimum set required for Hello World! */
SYSCALL4(write)
SYSCALL4(reboot)
SYSCALL4(wait4)
SYSCALL1(brk)
SYSCALL0(getpid)
SYSCALL2(kill)
SYSCALL2(fstat)
SYSCALL1(exit)
SYSCALL3(read)
SYSCALL1(close)
SYSCALL3(lseek)

SYSCALL2(socket)
SYSCALL2(accept)
SYSCALL2(connect)
SYSCALL2(bind)
SYSCALL2(listen)
SYSCALL2(socketpair)
SYSCALL2(shutdown);
SYSCALL2(recvfrom);
SYSCALL2(recvmsg);
SYSCALL2(sendmsg);
SYSCALL2(sendto);
SYSCALL2(getsockopt);
SYSCALL2(getsockname);
SYSCALL2(getpeername);

/* FIXME: These come up as undefined in newlib
// SYSCALL0(getpgrp)
// SYSCALL3(getdents)
// SYSCALL0(pause)
// SYSCALL1(pipe)
// SYSCALL3(sigprocmask)
// SYSCALL1(stime)
// SYSCALL2(utime)
// SYSCALL0(vfork)

/* These all appear to work */
SYSCALL3(execve)
SYSCALL0(getegid)
SYSCALL0(geteuid)
SYSCALL0(getgid)
SYSCALL2(getgroups)
SYSCALL1(getpgid)
SYSCALL0(getuid)
SYSCALL2(gettimeofday)
SYSCALL2(nanosleep)
SYSCALL2(setpgid)
SYSCALL1(setgid)
SYSCALL0(setsid)
SYSCALL1(setuid)
SYSCALL1(times)
SYSCALL1(umask)
/* FIXME: unsupported by newlib ??*/
SYSCALL1(uname)
SYSCALL3(ioctl)
SYSCALL1(sysinfo)

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

#if 0
SOCKETCALL4(recv, RECV)
SOCKETCALL4(send, SEND)
#endif
