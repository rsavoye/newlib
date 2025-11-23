/*
  This file is use to test the syscall support on Android
 */
#include <unistd.h>
#define __USE_ATFILE 1
#include <fcntl.h>
#include <sys/stat.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/times.h>
#include <sys/time.h>
#include <time.h>
#include <stdlib.h>

// FIXME: newlib can't find these
// #include <sys/utsname.h>
// #include <sys/sysinfo.h>
// #include <sys/ioctl.h>
// #include <dejagnu.h>

void test_out(const char *msg);

bool io_test(void);
bool pid_test(void);
bool gid_tests(void);
bool mem_tests(void);

int
main(int argc, char *argv[])
{
  io_test();
  pid_test();
  gid_tests();

  mode_t ret = umask(S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
  if (ret > 0) {
    test_out("PASS: umask()\n");
  } else {
    test_out("FAIL: umask()\n");
  }
  
  struct tms tms;
  clock_t cret = times(&tms);
  if (tms.tms_utime == 0) {
    test_out("PASS: times()\n");
  } else {
    test_out("FAIL: times()\n");
  }
  struct timeval tval;
  struct timezone tz;
  gettimeofday(&tval, &tz);
  if (tval.tv_sec > 0) {
    test_out("PASS: gettimeofday()\n");
  } else {
    test_out("FAIL: gettimeofday()\n");
  }

  uid_t uid = getuid();
  if (uid == 0) {
    test_out("PASS: getuid()\n");
  } else {
    test_out("FAIL: getuid()\n");
  }

  gid_t groups[5];
  int grps = getgroups(5, groups);
  if (grps == 0) {
    test_out("PASS: getgroups()\n");
  } else {
    test_out("FAIL: getgroups()\n");
  }


  // FIXME: nanosleep undefined
  // struct timespec remaining, request = { 5, 100 };
  // int nan = nanosleep(&request, &remaining);
  // FIXME: fork() and wait() undefined
  // execve("hi", argv, argv);
  mem_tests();
}

void test_out(const char *msg) {
  write(1, msg, strlen(msg));
}

bool mem_tests(void) {
  char *mem = (char *)malloc(10);
  *mem = 0x1;
  if (*mem == 0x1) {
    test_out("PASS: malloc()\n");
  } else {
    test_out("FAIL: malloc()\n");
  }

  free(mem);
  // FIXME: this isn't really accurate
  if ((long)mem > 0) {
    test_out("PASS: free()\n");
  } else {
    test_out("FAIL: free()\n");
  }

  char *mem2 = (char *)calloc(1, 10);
  if (*mem2 == 0x0) {
    test_out("PASS: calloc()\n");
  } else {
    test_out("FAIL: calloc()\n");
  }

  char *mem3 = (char *)realloc(mem2, 15);
  mem3[12] = 0x2;
  if (mem3[12] == 0x2) {
    test_out("PASS: realloc()\n");
  } else {
    test_out("FAIL: realloc()\n");
  }

  return false;
}

bool io_test(void) {
#if 0
  int foo = write(1, "Hello World!\n", 13);
  int fd = open("foo.log", O_CREAT);
  write(fd, "World Hello!\n", 13);
  int fd1 = open("ndk.log", O_RDONLY);
  char buf[100];
  read(fd1, buf, 20);
  // chmod("ndk.log", 0777);
#endif
  return true;
}

bool pid_test(void) {
  int ret = getpid();
  if (ret > 0) {
    test_out("PASS: getpid()\n");
    return true;
  }
  test_out("FAIL: getpid()\n");
  return false;
}

bool gid_tests(void) {
  pid_t ret = 0;
  // pid_t ret = getegid();
  ret = getgid();
  if (ret == 0) {
    test_out("PASS: getgid()\n");
  }
  ret = getpgid(getpid());
  if (ret > 0) {
    test_out("PASS: getpgid()\n");
  }
  ret = setpgid(getpid(), ret);
  if (ret == 0) {
    test_out("PASS: setpgid()\n");
  }
  ret = setgid(getgid());

  return false;
}
