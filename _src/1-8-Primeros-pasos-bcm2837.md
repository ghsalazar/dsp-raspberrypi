---
title: Primeros pasos con el SoC Broadcom
...

(*usar powershell*) 

- Instalar chocolatey
- choco install gcc-arm-embedded
- choco install qemu

<<blink.s>>=
/****************************************
    @author   Gastón Hugo Salazar Silva
    @date     2021.07.20 
*****************************************/
@

<<blink.s>>=
    .cpu    cortex-a53
@

<<blink.s>>=
    .equ    GPIO_BASE,  0x3f200000      @ Dirección base a los registros del GPIO 
@

<<blink.s>>=
    .equ    GPFSEL2,    0x08            @ Registro a las funciones de los pines GPIO2x
@

<<blink.s>>=
    .equ    FSEL21,     0x03            @ Funciones del GPIO21
@
<<blink.s>>=
    .equ    FOUTPUT,    0x01            @ Función como salida

@

<<blink.s>>=
    .equ    GPSET0,     0x1c            @ Registro para encender los pines GPIO0-GPIO31
@

<<blink.s>>=
    .equ    SET21,      21              

@

<<blink.s>>=
    .equ    GPCLR0,     0x28            @ Registro para apagar los pines GPIO0-GPIO31
@
<<blink.s>>=
    .equ    CLR21,      21              @ Bit para activar GPIO21

@

<<blink.s>>=
    .equ    TIME,       0xf0000

@

<<blink.s>>=
    .org    0x8000                      @ Dirección donde empieza el programa
@

<<blink.s>>=
    .global _start
@

<<blink.s>>=
_start:
@

<<blink.s>>=
    ldr r0, =GPIO_BASE          @ ro = GPIO_BASE

@

<<blink.s>>=
    mov r1, #FOUTPUT            @ r1 = FOUTPUT
@

<<blink.s>>=
    lsl r1, #FSEL21             @ r1 = r1 << FSEL21
@

<<blink.s>>=
    str r1, [r0, #GPFSEL2]      @ GPIO_BASE[GPFSEL2] = r1

@

<<blink.s>>=
loop:
@

<<blink.s>>=
    mov r1, #1
    lsl r1, #SET21          
    str r1, [r0, #GPSET0]       

@

<<blink.s>>=
    ldr r2, =TIME
    delay1:
        subs r2, r2, #1
        bne delay1

@

<<blink.s>>=
    mov r1, #1
    lsl r1, #CLR21       
    str r1, [r0, #GPCLR0]       

@

<<blink.s>>=
    ldr r2, =TIME
    delay2:
        subs r2, r2, #1
        bne delay2
@

<<blink.s>>=
    b loop
@

## Ensamblado y enlazado del programa

~~~
arm-none-eabi-as -g -o dsp-blink.o dsp-blink.s
arm-none-eabi-ld dsp-blink.o -o dsp-blink.elf
arm-none-eabi-objcopy dsp-blink.elf -O binary kernel7.img
~~~

## Ejecución del programa

## Para saber más

- https://cs140e.sergio.bz/docs/BCM2837-ARM-Peripherals.pdf
- https://www.instructables.com/Bare-Metal-Raspberry-Pi-3Blinking-LED/
- http://web.eece.maine.edu/~vweaver/classes/ece598/ece598_hw2.pdf
- https://gist.github.com/imjacobclark/77c68039ae006e674a01
- http://wiki.osdev.org/Raspberry_Pi_Bare_Bones
- https://bob.cs.sonoma.edu/IntroCompOrg-RPi/sec-gpio-pins.html
- http://classweb.ece.umd.edu/enee447.S2019/baremetal_boot_code_for_ARMv8_A_processors.pdf