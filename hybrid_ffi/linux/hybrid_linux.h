
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/time.h>

#define FFI_PLUGIN_EXPORT

// access modes
#define HYBRID_O_RDONLY O_RDONLY;
#define HYBRID_O_WRONLY O_WRONLY;
#define HYBRID_O_RDWR O_RDWR;
// file creation flags & file status flags
#define HYBRID_O_APPEND O_APPEND;
#define HYBRID_O_ASYNC O_ASYNC;
#define HYBRID_O_CLOEXEC O_CLOEXEC;
#define HYBRID_O_CREAT O_CREAT;
#define HYBRID_O_DIRECT O_DIRECT;
#define HYBRID_O_DIRECTORY O_DIRECTORY;
#define HYBRID_O_DSYNC O_DSYNC;
#define HYBRID_O_EXCL O_EXCL;
#define HYBRID_O_LARGEFILE O_LARGEFILE;
#define HYBRID_O_NOATIME O_NOATIME;
#define HYBRID_O_NOCTTY O_NOCTTY;
#define HYBRID_O_NOFOLLOW O_NOFOLLOW;
#define HYBRID_O_NONBLOCK O_NONBLOCK;
#define HYBRID_O_PATH O_PATH;
#define HYBRID_O_SYNC O_SYNC;
#define HYBRID_O_TMPFILE O_TMPFILE;
#define HYBRID_O_TRUNC O_TRUNC;

#define HYBRID_PROT_EXEC PROT_EXEC;
#define HYBRID_PROT_READ PROT_READ;
#define HYBRID_PROT_WRITE PROT_WRITE;
#define HYBRID_PROT_NONE PROT_NONE;

#define HYBRID_MAP_SHARED MAP_SHARED;
#define HYBRID_MAP_PRIVATE MAP_PRIVATE;
#define HYBRID_MAP_32BIT MAP_32BIT;
#define HYBRID_MAP_ANON MAP_ANON;
#define HYBRID_MAP_ANONYMOUS MAP_ANONYMOUS;
#define HYBRID_MAP_DENYWRITE MAP_DENYWRITE;
#define HYBRID_MAP_EXECUTABLE MAP_EXECUTABLE;
#define HYBRID_MAP_FILE MAP_FILE;
#define HYBRID_MAP_FIXED MAP_FIXED;
#define HYBRID_MAP_GROWSDOWN MAP_GROWSDOWN;
#define HYBRID_MAP_HUGETLB MAP_HUGETLB;
#define HYBRID_MAP_LOCKED MAP_LOCKED;
#define HYBRID_MAP_NONBLOCK MAP_NONBLOCK;
#define HYBRID_MAP_NORESERVE MAP_NORESERVE;
#define HYBRID_MAP_POPULATE MAP_POPULATE;
#define HYBRID_MAP_STACK MAP_STACK;
#define HYBRID_MAP_UNINITIALIZED MAP_UNINITIALIZED;

FFI_PLUGIN_EXPORT struct hybrid_mapped_buffer {
  void *addr;
  size_t len;
};

FFI_PLUGIN_EXPORT int hybrid_open(char *file, int oflag);
FFI_PLUGIN_EXPORT int hybrid_close(int fd);
FFI_PLUGIN_EXPORT int hybrid_ioctl(int fd, unsigned long request, ...);
FFI_PLUGIN_EXPORT int hybrid_mmap(int fd, off_t offset, size_t len, int prot,
                                  int flags, struct hybrid_mapped_buffer *buf);
FFI_PLUGIN_EXPORT int hybrid_munmap(struct hybrid_mapped_buffer *buf);
FFI_PLUGIN_EXPORT int hybrid_select(int fd, struct timeval *timeout);