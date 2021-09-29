/****************************************
    @author   Gastón Hugo Salazar Silva
    @date     2021.07.20 
*****************************************/
    .cpu    cortex-a53
    .equ    GPIO_BASE,  0x3f200000      @ Dirección base a los registros del GPIO 
    .equ    GPFSEL2,    0x08            @ Registro a las funciones de los pines GPIO2x
    .equ    FSEL21,     0x03            @ Funciones del GPIO21
    .equ    FOUTPUT,    0x01            @ Función como salida

    .equ    GPSET0,     0x1c            @ Registro para encender los pines GPIO0-GPIO31
    .equ    SET21,      21              

    .equ    GPCLR0,     0x28            @ Registro para apagar los pines GPIO0-GPIO31
    .equ    CLR21,      21              @ Bit para activar GPIO21

    .equ    TIME,       0xf0000

    .org    0x8000                      @ Dirección donde empieza el programa
    .global _start
_start:
    ldr r0, =GPIO_BASE          @ ro = GPIO_BASE

    mov r1, #FOUTPUT            @ r1 = FOUTPUT
    lsl r1, #FSEL21             @ r1 = r1 << FSEL21
    str r1, [r0, #GPFSEL2]      @ GPIO_BASE[GPFSEL2] = r1

loop:
    mov r1, #1
    lsl r1, #SET21          
    str r1, [r0, #GPSET0]       

    ldr r2, =TIME
    delay1:
        subs r2, r2, #1
        bne delay1

    mov r1, #1
    lsl r1, #CLR21       
    str r1, [r0, #GPCLR0]       

    ldr r2, =TIME
    delay2:
        subs r2, r2, #1
        bne delay2
    b loop
