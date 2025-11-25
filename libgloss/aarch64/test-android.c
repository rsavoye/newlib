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
#include <stdio.h>
#include <pthread.h>
#include <signal.h>
#include <netinet/in.h>
#include <sys/socket.h>

// FIXME: newlib can't find these
// #include <sys/utsname.h>
// #include <sys/sysinfo.h>
// #include <sys/ioctl.h>
// #include <dejagnu.h>

void test_out(const char *msg);

bool file_io_tests(void);
bool pid_test(void);
bool gid_tests(void);
bool mem_tests(void);
bool str_tests(void);
bool net_tests(void);

int
main(int argc, char *argv[])
{
  mem_tests();
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

  file_io_tests();

  // FIXME: nanosleep undefined
  // struct timespec remaining, request = { 5, 100 };
  // int nan = nanosleep(&request, &remaining);
  // FIXME: fork() and wait() undefined
  // execve("hi", argv, argv);

  str_tests();
  net_tests();
}

void test_out(const char *msg) {
  write(1, msg, strlen(msg));
}

#define PORT 8888
bool net_tests(void)
{
  int fd,bid, lid, aid;
  struct sockaddr_in server, client;
  // Creating socket file descriptor
  if ((fd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
    test_out("FAIL: socket()\n");
  } else {
    test_out("PASS: socket()\n");
  }
  server.sin_family = AF_INET;
  server.sin_port = 8888;
  server.sin_addr.s_addr = htonl(INADDR_ANY);
  // server.sin_addr.s_addr = inet_add
  if ((bid = bind(fd, (struct sockaddr *)&server, sizeof(server))) < 0) {
      test_out("FAIL: bind()\n");
    } else {
      test_out("PASS: bind()\n");
    }
// We don't always aant to wait for an incoming connection, this is just to
// sure networking works.
#ifdef NETWORKING
  if ((lid = listen(fd, 1)) < 0) {
      test_out("FAIL: listen()\n");
    } else {
      test_out("PASS: listen()\n");
    }
  socklen_t slen = sizeof(client);
  if ((aid = accept(fd, (struct sockaddr *)&client, &slen)) < 0) {
      test_out("FAIL: accept()\n");
    } else {
      test_out("PASS: accept()\n");
    }
#endif
  // accept
  // bind
  // connect
}

    int server_fd, new_socket;
bool str_tests(void)
{
  char buf[100];
  memset(buf, 0, 100);
  int test = 0x777;
  sprintf(buf, "FIXME: %d", test);
  if (buf[0] > 0) {
    test_out("PASS: sprintf()\n");
    int server_fd, new_socket;
  } else {
    test_out("FAIL: sprintf()\n");
  }

  // printf("Fooby!\n");
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

bool file_io_tests(void) {
  // int foo = write(1, "Hello World!\n", 13);
  int fd = open("./foo.log", O_WRONLY | O_CREAT, 0644);
  if (fd > 0) {
    struct stat data;
    int ret = stat("./foo.log", &data);
    if (ret > 0 || data.st_size <= 0) {
      test_out("FAIL: create disk file after opening()\n");
    } else {
      test_out("PASS: create disk file()\n");
      write(fd, "Hello World !\n", 13);
    }
  } else {
    test_out("FAIL: create disk file()\n");
  }
  close(fd);

  // read inlut file
  int fd1 = open("./ndk.log", O_RDONLY);
  char buf[10];
  memset(buf, 0, 10);
  read(fd1, buf, 10);
  // write(1, buf, 10);
  if (buf[0] != 0) {
    test_out("PASS: read disk file()\n");
  } else {
    test_out("FAIL: read disk file()\n");
  }
  // chmod("ndk.log", 0777);

  struct stat data;
  int ret = stat("./ndk.log", &data);
  if (data.st_size > 0) {
    test_out("PASS: stat()\n");
  } else {
    test_out("FAIL: stat()\n");
  }

  off_t off = lseek(fd1, 0x2, SEEK_SET);
  if (off > 0) {
    test_out("PASS: lseek()\n");
  } else {
    test_out("FAIL: lseek()\n");
  }
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
