
#include <fcntl.h>
#include <stdint.h>
#include <stdio.h> // FILE
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/time.h>

#define FFI_PLUGIN_EXPORT

// access modes
#define V4L2_O_RDONLY O_RDONLY;
#define V4L2_O_WRONLY O_WRONLY;
#define V4L2_O_RDWR O_RDWR;
// file creation flags & file status flags
#define V4L2_O_APPEND O_APPEND;
#define V4L2_O_ASYNC O_ASYNC;
#define V4L2_O_CLOEXEC O_CLOEXEC;
#define V4L2_O_CREAT O_CREAT;
#define V4L2_O_DIRECT O_DIRECT;
#define V4L2_O_DIRECTORY O_DIRECTORY;
#define V4L2_O_DSYNC O_DSYNC;
#define V4L2_O_EXCL O_EXCL;
#define V4L2_O_LARGEFILE O_LARGEFILE;
#define V4L2_O_NOATIME O_NOATIME;
#define V4L2_O_NOCTTY O_NOCTTY;
#define V4L2_O_NOFOLLOW O_NOFOLLOW;
#define V4L2_O_NONBLOCK O_NONBLOCK;
#define V4L2_O_PATH O_PATH;
#define V4L2_O_SYNC O_SYNC;
#define V4L2_O_TMPFILE O_TMPFILE;
#define V4L2_O_TRUNC O_TRUNC;

#define V4L2_PROT_EXEC PROT_EXEC;
#define V4L2_PROT_READ PROT_READ;
#define V4L2_PROT_WRITE PROT_WRITE;
#define V4L2_PROT_NONE PROT_NONE;

#define V4L2_MAP_SHARED MAP_SHARED;
#define V4L2_MAP_PRIVATE MAP_PRIVATE;
#define V4L2_MAP_32BIT MAP_32BIT;
#define V4L2_MAP_ANONYMOUS MAP_ANONYMOUS;
#define V4L2_MAP_DENYWRITE MAP_DENYWRITE;
#define V4L2_MAP_EXECUTABLE MAP_EXECUTABLE;
#define V4L2_MAP_FILE MAP_FILE;
#define V4L2_MAP_FIXED MAP_FIXED;
#define V4L2_MAP_GROWSDOWN MAP_GROWSDOWN;
#define V4L2_MAP_HUGETLB MAP_HUGETLB;
#define V4L2_MAP_LOCKED MAP_LOCKED;
#define V4L2_MAP_NONBLOCK MAP_NONBLOCK;
#define V4L2_MAP_NORESERVE MAP_NORESERVE;
#define V4L2_MAP_POPULATE MAP_POPULATE;
#define V4L2_MAP_STACK MAP_STACK;
#define V4L2_MAP_UNINITIALIZED MAP_UNINITIALIZED;

FFI_PLUGIN_EXPORT struct v4l2_mapped_buffer {
  void *addr;
  size_t len;
};

FFI_PLUGIN_EXPORT struct v4l2_rgbx_buffer {
  uint8_t *addr;
  uint32_t width;
  uint32_t height;
};

FFI_PLUGIN_EXPORT int v4l2_open(char *file, int oflag);
FFI_PLUGIN_EXPORT int v4l2_close(int fd);
FFI_PLUGIN_EXPORT int v4l2_ioctl(int fd, unsigned long request, ...);
FFI_PLUGIN_EXPORT int v4l2_mmap(int fd, off_t offset, size_t len, int prot,
                                int flags, struct v4l2_mapped_buffer *buf);
FFI_PLUGIN_EXPORT int v4l2_munmap(struct v4l2_mapped_buffer *buf);
FFI_PLUGIN_EXPORT int v4l2_select(int fd, struct timeval *timeout);
FFI_PLUGIN_EXPORT struct v4l2_rgbx_buffer *
v4l2_mjpeg2rgbx(struct v4l2_mapped_buffer *buf);
FFI_PLUGIN_EXPORT void v4l2_free_rgbx(struct v4l2_rgbx_buffer *buf);