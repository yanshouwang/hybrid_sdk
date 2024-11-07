
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/time.h>

#define FFI_PLUGIN_EXPORT

// access modes
#define HV_O_RDONLY O_RDONLY;
#define HV_O_WRONLY O_WRONLY;
#define HV_O_RDWR O_RDWR;
// file creation flags & file status flags
#define HV_O_APPEND O_APPEND;
#define HV_O_ASYNC O_ASYNC;
#define HV_O_CLOEXEC O_CLOEXEC;
#define HV_O_CREAT O_CREAT;
#define HV_O_DIRECT O_DIRECT;
#define HV_O_DIRECTORY O_DIRECTORY;
#define HV_O_DSYNC O_DSYNC;
#define HV_O_EXCL O_EXCL;
#define HV_O_LARGEFILE O_LARGEFILE;
#define HV_O_NOATIME O_NOATIME;
#define HV_O_NOCTTY O_NOCTTY;
#define HV_O_NOFOLLOW O_NOFOLLOW;
#define HV_O_NONBLOCK O_NONBLOCK;
#define HV_O_PATH O_PATH;
#define HV_O_SYNC O_SYNC;
#define HV_O_TMPFILE O_TMPFILE;
#define HV_O_TRUNC O_TRUNC;

#define HV_PROT_EXEC PROT_EXEC;
#define HV_PROT_READ PROT_READ;
#define HV_PROT_WRITE PROT_WRITE;
#define HV_PROT_NONE PROT_NONE;

#define HV_MAP_SHARED MAP_SHARED;
#define HV_MAP_PRIVATE MAP_PRIVATE;
#define HV_MAP_32BIT MAP_32BIT;
#define HV_MAP_ANON MAP_ANON;
#define HV_MAP_ANONYMOUS MAP_ANONYMOUS;
#define HV_MAP_DENYWRITE MAP_DENYWRITE;
#define HV_MAP_EXECUTABLE MAP_EXECUTABLE;
#define HV_MAP_FILE MAP_FILE;
#define HV_MAP_FIXED MAP_FIXED;
#define HV_MAP_GROWSDOWN MAP_GROWSDOWN;
#define HV_MAP_HUGETLB MAP_HUGETLB;
#define HV_MAP_LOCKED MAP_LOCKED;
#define HV_MAP_NONBLOCK MAP_NONBLOCK;
#define HV_MAP_NORESERVE MAP_NORESERVE;
#define HV_MAP_POPULATE MAP_POPULATE;
#define HV_MAP_STACK MAP_STACK;
#define HV_MAP_UNINITIALIZED MAP_UNINITIALIZED;

FFI_PLUGIN_EXPORT struct hv_memory {
  void *addr;
  size_t len;
};

FFI_PLUGIN_EXPORT int hv_open(char *file, int oflag);
FFI_PLUGIN_EXPORT int hv_close(int fd);
FFI_PLUGIN_EXPORT int hv_ioctl(int fd, unsigned long request, ...);
FFI_PLUGIN_EXPORT int hv_mmap(int fd, off_t offset, size_t len, int prot,
                              int flags, struct hv_memory *memory);
FFI_PLUGIN_EXPORT int hv_munmap(struct hv_memory *memory);
FFI_PLUGIN_EXPORT int hv_select(int fd, struct timeval *timeout);