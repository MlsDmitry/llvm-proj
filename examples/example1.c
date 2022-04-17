#include <stdio.h>
#include <stdlib.h>

const char key[] = { 0x1, 0x2, 0x3 };

//__attribute__ ((optnone))
char *
encode_alloc(void *data, size_t data_size, void *key, size_t key_size)
{
    
    char *out = malloc(data_size);
    for (int i = 0; i < data_size; i++)
    {
        unsigned char ch = *(unsigned char *)(data + i);
        out[i] = ch == 0 ? 0 : ch ^ *(unsigned char *)(key + (i % key_size));
    }

    return out;
}

void
encode_free(char *data)
{
    free(data);
}

void say_meow(int i)
{
    printf("%d Meow...\n", i);
}

void do_nothing(int i)
{
    char *dec;
    char *dec2;

    if ((i * 100 / 21 + 40) * 32 > 300) {
        dec = encode_alloc((void *)"[do_nothing] made something\n", 29, (void *)key, sizeof(key));
        printf("%s\n", dec);
        dec2 = encode_alloc((void *)dec, 29, (void *)key, sizeof(key));
        printf("%s\n", dec2);
    } else 
        printf("[do_nothing] made nothing\n");
}

int main(int argc, char ** argv)
{
    for (int i = 0; i < 100; i++) {
        if (i % 2 == 0)
            say_meow(i);
        else
            do_nothing(i);
        
//        switch(i) {
//            case 0:
//                printf("0\n");
//                break;
//            case 1:
//                printf("1\n");
//                break;
//            case 2:
//                printf("2\n");
//                break;
//            case 3:
//                printf("3\n");
//                break;
//            case 4:
//                printf("4\n");
//                break;
//            case 5:
//                printf("5\n");
//                break;
//            case 6:
//                printf("6\n");
//                break;
//            case 7:
//                printf("7\n");
//                break;
//            case 8:
//                printf("8\n");
//                break;
//            case 9:
//                printf("9\n");
//                break;
//            case 10:
//                printf("10\n");
//                break;
//            default:
//                printf("default\n");
//                break;
//        }
    }
    
    return 0;
}

// int foo(int a) {
//   return a * 2;
// }

// // int bar(int a, int b) {
// //   return (a + foo(b) * 2);
// // }

// // int fez(int a, int b, int c) {
// //   return (a + bar(a, b) * 2 + c * 3);
// // }

// int main(int argc, char **argv) {

//   ret += foo(a);
// //   ret += bar(a, ret);
// //   ret += fez(a, ret, 123);

//   return 0;
// }
