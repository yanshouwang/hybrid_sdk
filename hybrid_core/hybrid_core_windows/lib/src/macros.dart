// ignore_for_file: type=lint

int LOBYTE(int w) => w & 0xff;
int HIBYTE(int w) => (w >> 8) & 0xff;
