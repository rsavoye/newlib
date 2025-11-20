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
/* #define SYSCALL5(name) SYSCALL6(name) */

#if 1
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
      // SYSCALL3(open)
#else
SYSCALL1(alarm)
SYSCALL1(brk)
SYSCALL1(chdir)
SYSCALL2(chmod)
SYSCALL3(chown)
SYSCALL1(close)
SYSCALL1(dup)
SYSCALL2(dup2)
SYSCALL3(execve)
SYSCALL1(exit)
SYSCALL3(fcntl)
SYSCALL2(fstat)
SYSCALL2(ftruncate)
SYSCALL3(getdents)
SYSCALL0(getegid)
SYSCALL0(geteuid)
SYSCALL0(getgid)
SYSCALL2(getgroups)
SYSCALL1(getpgid)
SYSCALL0(getpgrp)
SYSCALL0(getpid)
SYSCALL0(getuid)
SYSCALL2(gettimeofday)
SYSCALL3(ioctl)
SYSCALL2(kill)
SYSCALL3(lchown)
SYSCALL2(link)
SYSCALL3(lseek)
SYSCALL2(lstat)
SYSCALL2(mkdir)
SYSCALL3(mknod)
SYSCALL2(nanosleep)
SYSCALL3(open)
SYSCALL0(pause)
SYSCALL1(pipe)
SYSCALL3(read)
SYSCALL3(readlink)
SYSCALL4(reboot)
SYSCALL1(rmdir)
/* SYSCALL5(select) */
SYSCALL2(setpgid)
SYSCALL1(setgid)
SYSCALL0(setsid)
SYSCALL1(setuid)
SYSCALL3(sigprocmask)
SYSCALL2(socketcall)
SYSCALL2(stat)
SYSCALL1(stime)
SYSCALL2(symlink)
SYSCALL1(sync)
SYSCALL1(sysinfo)
SYSCALL1(times)
SYSCALL2(truncate)
SYSCALL1(umask)
SYSCALL1(uname)
SYSCALL1(unlink)
SYSCALL2(utime)
SYSCALL0(vfork)
SYSCALL4(wait4)
SYSCALL3(write)
#endif

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

#if 0
# define SOCKETCALL(name, NAME) \
	GLOBAL(name); \
	push { r0 - r3 }; \
	mov r0, #SYS_ ## NAME; \
	b _socketcall_tail; \
	SIZE(name)

FUNC(_socketcall_tail)
	mov r1, sp
	push { lr }
	bl _socketcall
	pop { r3 }
	add sp, #16

#define SOCKETCALL2(name, NAME) SOCKETCALL(name, NAME)
#define SOCKETCALL3(name, NAME) SOCKETCALL(name, NAME)
#define SOCKETCALL4(name, NAME) SOCKETCALL(name, NAME)
#define SOCKETCALL5(name, NAME) SOCKETCALL(name, NAME)
#define SOCKETCALL6(name, NAME) SOCKETCALL(name, NAME)

SOCKETCALL3(accept, ACCEPT)
SOCKETCALL3(bind, BIND)
SOCKETCALL3(connect, CONNECT)
SOCKETCALL3(getpeername, GETPEERNAME)
SOCKETCALL3(getsockname, GETSOCKNAME)
SOCKETCALL5(getsockopt, GETSOCKOPT)
SOCKETCALL2(listen, LISTEN)
SOCKETCALL4(recv, RECV)
SOCKETCALL6(recvfrom, RECVFROM)
SOCKETCALL3(recvmsg, RECVMSG)
SOCKETCALL4(send, SEND)
SOCKETCALL3(sendmsg, SENDMSG)
SOCKETCALL6(sendto, SENDTO)
SOCKETCALL5(setsockopt, SETSOCKOPT)
SOCKETCALL2(shutdown, SHUTDOWN)
SOCKETCALL3(socket, SOCKET)
SOCKETCALL4(socketpair, SOCKETPAIR)
#endif

