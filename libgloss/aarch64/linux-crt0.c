/** Linux startup code for the AARCH64 processor.

 */

#include <stdlib.h>
#include <unistd.h>
#include <errno.h>

/* forward declaration */
int main(int argc, char *argv[]);
static int _main(int argc, char *argv[]) __attribute__((noreturn));
extern void _exit(int status);

char *hi = "Hello World!\n";
char *ih = "World Hello!\n";

void _start(void)
{
  register int *sp asm("sp");
  _main(*sp, (char **)(sp + 1));
}

static int _main(int argc, char *argv[])
{
  // environ = argv + argc + 1;
  _exit(main(argc, argv));
}
