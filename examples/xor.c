#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

// void xor_abc(char* abc)
//{
//     for (int i=0; i < 3; i++)
//     {
//         abc[i] ^= 10;
//     }
// }

// #ifndef HEXDUMP_COLS
// #define HEXDUMP_COLS 16
// #endif

// void hexdump(void *mem, unsigned int len)
// {
//         unsigned int i, j;

//         for(i = 0; i < len + ((len % HEXDUMP_COLS) ? (HEXDUMP_COLS - len % HEXDUMP_COLS) : 0); i++)
//         {
//                 /* print offset */
//                 if(i % HEXDUMP_COLS == 0)
//                 {
//                         printf("0x%06x: ", i);
//                 }

//                 /* print hex data */
//                 if(i < len)
//                 {
//                         printf("%02x ", 0xFF & ((char*)mem)[i]);
//                 }
//                 else /* end of block, just aligning for ASCII dump */
//                 {
//                         printf("   ");
//                 }

//                 /* print ASCII dump */
//                 if(i % HEXDUMP_COLS == (HEXDUMP_COLS - 1))
//                 {
//                         for(j = i - (HEXDUMP_COLS - 1); j <= i; j++)
//                         {
//                                 if(j >= len) /* end of block, not really printing */
//                                 {
//                                         putchar(' ');
//                                 }
//                                 else if(isprint(((char*)mem)[j])) /* printable char */
//                                 {
//                                         putchar(0xFF & ((char*)mem)[j]);
//                                 }
//                                 else /* other char */
//                                 {
//                                         putchar('.');
//                                 }
//                         }
//                         putchar('\n');
//                 }
//         }
// }

char *
encode_alloc(char *data, size_t data_size, char *key, size_t key_size)
{
    char *out = malloc(data_size);
    for (int i = 0; i < data_size; i++)
    {
        unsigned char ch = (unsigned char)data[i];
        out[i] = ch == 0 ? 0 : ch ^ key[i % key_size];
    }

    return out;
}

int main()
{
    //    char *abc = "abc";
    char key[] = {0x1, 0x20, 0x34};
    //    char *out = malloc(4);
    //
    //    xor(abc, key, out);
    //
    //    hexdump((void *)abc, 4);
    //    hexdump((void *)key, 3);
    //    hexdump((void *)out, 4);
    //
    //    free(out);

    char * data = "[do_nothing] made something[do_nothing] made nothing";

    char * out = encode_alloc(data, strlen(data), key, sizeof(key));

    printf("%s\n", out);

    //     hexdump(out, 28 * 2);
    return 0;
}
