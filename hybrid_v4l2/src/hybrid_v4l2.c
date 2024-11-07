#include "hybrid_v4l2.h"

#include <errno.h>
#include <fcntl.h>
#include <stdarg.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/select.h>
#include <sys/time.h>
#include <unistd.h>

FFI_PLUGIN_EXPORT int hv_open(char *file, int oflag) {
  return open(file, oflag, 0);
}

FFI_PLUGIN_EXPORT int hv_close(int fd) { return close(fd); }

FFI_PLUGIN_EXPORT int hv_ioctl(int fd, unsigned long request, ...) {
  void *arg;
  va_list ap;

  va_start(ap, request);
  arg = va_arg(ap, void *);
  va_end(ap);

  return ioctl(fd, request, arg);
}

FFI_PLUGIN_EXPORT int hv_mmap(int fd, off_t offset, size_t len, int prot,
                              int flags, struct hv_memory *memory) {
  void *addr = mmap(NULL, len, prot, flags, fd, offset);
  if (MAP_FAILED == addr) {
    return -1;
  }
  memory->addr = addr;
  memory->len = len;
  return 0;
}

FFI_PLUGIN_EXPORT int hv_munmap(struct hv_memory *memory) {
  return munmap(memory->addr, memory->len);
}

FFI_PLUGIN_EXPORT int hv_select(int fd, struct timeval *timeout) {
  while (1) {
    fd_set fds;

    FD_ZERO(&fds);
    FD_SET(fd, &fds);

    int r = select(fd + 1, &fds, NULL, NULL, timeout);
    if (-1 == r && EINTR == errno) {
      continue;
    }
    return r;
  }
}
