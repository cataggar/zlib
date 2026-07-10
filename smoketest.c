#include <stdio.h>
#include <string.h>
#include "zlib.h"

int main(void) {
    const char *msg = "Hello, zlib compiled with zig cc for real cross-compilation!";
    uLong srclen = (uLong)strlen(msg) + 1;
    Bytef compressed[256];
    uLongf complen = sizeof(compressed);
    Bytef decompressed[256];
    uLongf decomplen = sizeof(decompressed);
    int rc;

    rc = compress(compressed, &complen, (const Bytef *)msg, srclen);
    if (rc != Z_OK) {
        printf("compress failed: %d\n", rc);
        return 1;
    }

    rc = uncompress(decompressed, &decomplen, compressed, complen);
    if (rc != Z_OK) {
        printf("uncompress failed: %d\n", rc);
        return 1;
    }

    if (decomplen != srclen || memcmp(decompressed, msg, srclen) != 0) {
        printf("round-trip mismatch\n");
        return 1;
    }

    printf("OK: '%s' compressed %lu -> %lu bytes, round-trip matches. zlibVersion()=%s\n",
           msg, (unsigned long)srclen, (unsigned long)complen, zlibVersion());
    return 0;
}
