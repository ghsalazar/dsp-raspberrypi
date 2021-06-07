/*
---
title:  Comunicación con la Raspberry Pi
author: Gastón Hugo Salazar Silva
date:   2021-06-07
...
*/

// Los ejemplos están a muy bajo nivel

/// @file   serial.c
/// @author Gastón Hugo Salazar Silva
/// @date   2021-06-07
/// @brief  Ejemplo de la comunicación serial con la Raspberry Pi

#include <stdio.h>

int main()
{
    // Setup
    FILE*   input;
    input = fopen("serial.c", "r");
    int bye = 0;
    int state = 3;
    int c;

    printf("\nOk > ");
    while (state != 0) {
        c = fgetc(input);

        if (c == 'b' && state == 3)
            state--;
        else if (c == 'y' && state == 2)
            state--;
        else if (c == 'e' && state == 1)
            state--;
        else
            state = 3;

        if (c == EOF)
            state = 0;
        else if (c == '\n') 
            printf("\nOk > ");
        else
            printf("%c", c);
    }
    
    fclose(input);
    return 0;
}