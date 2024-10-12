#include "hybrid_v4l2.h"

#include <errno.h>
#include <fcntl.h>
#include <jpeglib.h>
#include <setjmp.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h> // FILE
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/select.h>
#include <sys/time.h>
#include <unistd.h>

#define V4L2_COPY_HUFF_TABLE(dinfo, tbl, name)                   \
  do                                                             \
  {                                                              \
    if (dinfo->tbl == NULL)                                      \
      dinfo->tbl = jpeg_alloc_huff_table((j_common_ptr)dinfo);   \
    memcpy(dinfo->tbl->bits, name##_len, sizeof(name##_len));    \
    memset(dinfo->tbl->huffval, 0, sizeof(dinfo->tbl->huffval)); \
    memcpy(dinfo->tbl->huffval, name##_val, sizeof(name##_val)); \
  } while (0)

struct v4l2_error_mgr
{
  struct jpeg_error_mgr super;
  jmp_buf jmp;
};

static void v4l2_error_exit(j_common_ptr dinfo)
{
  struct v4l2_error_mgr *myerr = (struct v4l2_error_mgr *)dinfo->err;
#ifndef NDEBUG
  (*dinfo->err->output_message)(dinfo);
#endif
  longjmp(myerr->jmp, 1);
}

/* ISO/IEC 10918-1:1993(E) K.3.3. Default Huffman tables used by MJPEG UVC
   devices which don't specify a Huffman table in the JPEG stream. */
static const unsigned char dc_lumi_len[] = {0, 0, 1, 5, 1, 1, 1, 1, 1,
                                            1, 0, 0, 0, 0, 0, 0, 0};
static const unsigned char dc_lumi_val[] = {0, 1, 2, 3, 4, 5,
                                            6, 7, 8, 9, 10, 11};

static const unsigned char dc_chromi_len[] = {0, 0, 3, 1, 1, 1, 1, 1, 1,
                                              1, 1, 1, 0, 0, 0, 0, 0};
static const unsigned char dc_chromi_val[] = {0, 1, 2, 3, 4, 5,
                                              6, 7, 8, 9, 10, 11};

static const unsigned char ac_lumi_len[] = {0, 0, 2, 1, 3, 3, 2, 4, 3,
                                            5, 5, 4, 4, 0, 0, 1, 0x7d};
static const unsigned char ac_lumi_val[] = {
    0x01, 0x02, 0x03, 0x00, 0x04, 0x11, 0x05, 0x12, 0x21, 0x31, 0x41, 0x06,
    0x13, 0x51, 0x61, 0x07, 0x22, 0x71, 0x14, 0x32, 0x81, 0x91, 0xa1, 0x08,
    0x23, 0x42, 0xb1, 0xc1, 0x15, 0x52, 0xd1, 0xf0, 0x24, 0x33, 0x62, 0x72,
    0x82, 0x09, 0x0a, 0x16, 0x17, 0x18, 0x19, 0x1a, 0x25, 0x26, 0x27, 0x28,
    0x29, 0x2a, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3a, 0x43, 0x44, 0x45,
    0x46, 0x47, 0x48, 0x49, 0x4a, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59,
    0x5a, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6a, 0x73, 0x74, 0x75,
    0x76, 0x77, 0x78, 0x79, 0x7a, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89,
    0x8a, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98, 0x99, 0x9a, 0xa2, 0xa3,
    0xa4, 0xa5, 0xa6, 0xa7, 0xa8, 0xa9, 0xaa, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6,
    0xb7, 0xb8, 0xb9, 0xba, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7, 0xc8, 0xc9,
    0xca, 0xd2, 0xd3, 0xd4, 0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda, 0xe1, 0xe2,
    0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9, 0xea, 0xf1, 0xf2, 0xf3, 0xf4,
    0xf5, 0xf6, 0xf7, 0xf8, 0xf9, 0xfa};
static const unsigned char ac_chromi_len[] = {0, 0, 2, 1, 2, 4, 4, 3, 4,
                                              7, 5, 4, 4, 0, 1, 2, 0x77};
static const unsigned char ac_chromi_val[] = {
    0x00, 0x01, 0x02, 0x03, 0x11, 0x04, 0x05, 0x21, 0x31, 0x06, 0x12, 0x41,
    0x51, 0x07, 0x61, 0x71, 0x13, 0x22, 0x32, 0x81, 0x08, 0x14, 0x42, 0x91,
    0xa1, 0xb1, 0xc1, 0x09, 0x23, 0x33, 0x52, 0xf0, 0x15, 0x62, 0x72, 0xd1,
    0x0a, 0x16, 0x24, 0x34, 0xe1, 0x25, 0xf1, 0x17, 0x18, 0x19, 0x1a, 0x26,
    0x27, 0x28, 0x29, 0x2a, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3a, 0x43, 0x44,
    0x45, 0x46, 0x47, 0x48, 0x49, 0x4a, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58,
    0x59, 0x5a, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69, 0x6a, 0x73, 0x74,
    0x75, 0x76, 0x77, 0x78, 0x79, 0x7a, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
    0x88, 0x89, 0x8a, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98, 0x99, 0x9a,
    0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7, 0xa8, 0xa9, 0xaa, 0xb2, 0xb3, 0xb4,
    0xb5, 0xb6, 0xb7, 0xb8, 0xb9, 0xba, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7,
    0xc8, 0xc9, 0xca, 0xd2, 0xd3, 0xd4, 0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda,
    0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9, 0xea, 0xf2, 0xf3, 0xf4,
    0xf5, 0xf6, 0xf7, 0xf8, 0xf9, 0xfa};

static inline void v4l2_insert_huff_tables(j_decompress_ptr dinfo)
{
  V4L2_COPY_HUFF_TABLE(dinfo, dc_huff_tbl_ptrs[0], dc_lumi);
  V4L2_COPY_HUFF_TABLE(dinfo, dc_huff_tbl_ptrs[1], dc_chromi);
  V4L2_COPY_HUFF_TABLE(dinfo, ac_huff_tbl_ptrs[0], ac_lumi);
  V4L2_COPY_HUFF_TABLE(dinfo, ac_huff_tbl_ptrs[1], ac_chromi);
}

FFI_PLUGIN_EXPORT int v4l2_open(char *file, int oflag)
{
  return open(file, oflag, 0);
}

FFI_PLUGIN_EXPORT int v4l2_close(int fd) { return close(fd); }

FFI_PLUGIN_EXPORT int v4l2_ioctl(int fd, unsigned long request, ...)
{
  void *arg;
  va_list ap;

  va_start(ap, request);
  arg = va_arg(ap, void *);
  va_end(ap);

  return ioctl(fd, request, arg);
}

FFI_PLUGIN_EXPORT int v4l2_mmap(int fd, off_t offset, size_t len, int prot,
                                int flags, struct v4l2_mapped_buffer *buf)
{
  void *addr = mmap(NULL, len, prot, flags, fd, offset);
  if (MAP_FAILED == addr)
  {
    return -1;
  }
  buf->addr = addr;
  buf->len = len;
  return 0;
}

FFI_PLUGIN_EXPORT int v4l2_munmap(struct v4l2_mapped_buffer *buf)
{
  return munmap(buf->addr, buf->len);
}

FFI_PLUGIN_EXPORT int v4l2_select(int fd, struct timeval *timeout)
{
  while (1)
  {
    fd_set fds;

    FD_ZERO(&fds);
    FD_SET(fd, &fds);

    int r = select(fd + 1, &fds, NULL, NULL, timeout);
    if (-1 == r && EINTR == errno)
    {
      continue;
    }
    return r;
  }
}

FFI_PLUGIN_EXPORT struct v4l2_rgbx_buffer *
v4l2_mjpeg2rgbx(struct v4l2_mapped_buffer *buf)
{
  struct jpeg_decompress_struct dinfo;
  struct v4l2_error_mgr jerr;

  dinfo.err = jpeg_std_error(&jerr.super);
  jerr.super.error_exit = v4l2_error_exit;

  if (setjmp(jerr.jmp))
  {
    jpeg_destroy_decompress(&dinfo);
    return NULL;
  }

  jpeg_create_decompress(&dinfo);
  jpeg_mem_src(&dinfo, buf->addr, buf->len);
  jpeg_read_header(&dinfo, TRUE);

  if (dinfo.dc_huff_tbl_ptrs[0] == NULL)
  {
    // This frame is missing the Huffman tables: fill in the standard ones
    v4l2_insert_huff_tables(&dinfo);
  }

  dinfo.out_color_space = JCS_EXT_RGBX;
  dinfo.dct_method = JDCT_IFAST;

  struct v4l2_rgbx_buffer *rgbx = malloc(sizeof(*rgbx));
  rgbx->addr = malloc(dinfo.image_width * dinfo.image_height * 4);
  rgbx->width = dinfo.image_width;
  rgbx->height = dinfo.image_height;

  jpeg_start_decompress(&dinfo);

  while (dinfo.output_scanline < dinfo.output_height)
  {
    uint8_t *scanlines = rgbx->addr + dinfo.output_scanline * rgbx->width * 4;
    jpeg_read_scanlines(&dinfo, &scanlines, 1);
  }

  jpeg_finish_decompress(&dinfo);
  jpeg_destroy_decompress(&dinfo);

  return rgbx;
}

FFI_PLUGIN_EXPORT void v4l2_free_rgbx(struct v4l2_rgbx_buffer *buf)
{
  free(buf->addr);
  free(buf);
}
