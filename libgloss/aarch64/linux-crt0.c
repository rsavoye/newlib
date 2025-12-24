/** Linux startup code for the AARCH64 processor.

 */

#include <stdlib.h>
#include <unistd.h>
#include <errno.h>

/* forward declaration */
int main(int argc, char *argv[]);
static int _main(int argc, char *argv[]) __attribute__((noreturn));
extern void _exit(int status);

extern void __libc_init_array (void);
extern void __libc_fini_array (void);

void _start(void)
{
  register int *sp asm("sp");
  _main(*sp, (char **)(sp + 1));
}

static int _main(int argc, char *argv[])
{
  __libc_init_array();		/* needed for C++ constructors */
  // environ = argv + argc + 1;
  __libc_fini_array();
  _exit(main(argc, argv));
}
