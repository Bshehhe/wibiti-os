#include <stdint.h>

char keyboard_getchar(void);

static volatile uint16_t *video = (uint16_t *)0xB8000;
static int cursor = 0;

void putchar(char c)
{
    if (c == '\n') {
        cursor = ((cursor / 80) + 1) * 80;
        return;
    }

    video[cursor++] = (uint16_t)c | (0x0F << 8);

    if (cursor >= 80 * 25)
        cursor = 0;
}

void print(const char *text)
{
    while (*text)
        putchar(*text++);
}

void kernel_main(void)
{
    char login[5] = {0};
    char password[5] = {0};

    print("WIBITI OS\n");
    print("LOGIN SYSTEM\n\n");
    print("Login: ");

    for (int i = 0; i < 4; i++) {
        login[i] = keyboard_getchar();
        putchar(login[i]);
    }

    print("\nPassword: ");

    for (int i = 0; i < 4; i++) {
        password[i] = keyboard_getchar();
        putchar('*');
    }

    print("\n");

    int valid = 1;

    for (int i = 0; i < 4; i++) {
        if (login[i] != '1' || password[i] != '1')
            valid = 0;
    }

    if (valid)
        print("Access granted! Welcome!");
    else
        print("Access denied!");

    while (1)
        __asm__ volatile ("hlt");
}
