---
layout: page
title: Registros del procesador ARM Cortex-A53
...

Si bien los datos se alamcenan en memoria, un procesador no realiza operaciones
directamente en la memoria. Para poder operar los datos, estos deben ser
cargados en los registros del procesador.

Un registro es un espacio de memoria que está directamente construido en el
procesador y opera a la misma velocadad que este. 

Existen diferentes tipos de registros en el procesador ARM Cortex-A53.
## Registros de uso general

Los registros de uso general son aquellos que el programador puede modificar
directamente. Por ejemplo, si se desea realizar una suma de dos números, el
proceso es cargar a estos registros los dos operandos, realizar la operación y
guardar en memoria el valor alamacenado en el registro de resultado.  


| Registro | Alias  | Aplicación convencional |
|:--------:|:------:|:------------------------|
| r15      | PC     | Contador de programa |
| r14      | LR     | Registro de enlace |
| r13      | SP     | Puntero de pila |
| r12      | IP     | Registro para valores intermedios dentro de llamadas a procedimientos |
| r11      | v8, FP | Puntero al registro de activación, variable 8 |
| r10      | v7     | Variable 7 |
| r9       | v6     | Variable 6 |
| r8       | v5     | Variable 5 |
| r7       | v4     | Variable 4 |
| r6       | v3     | Variable 3 |
| r5       | v2     | Variable 2 |
| r4       | v1     | Variable 1 |
| r3       | a4     | Argumento o registro para valores intermedios 4 |
| r2       | a3     | Argumento o registro para valores intermedios 3 |
| r1       | a2     | Argumento, registro para resultados o valores intermedios 2 |
| r0       | a1     | Argumento, registro para resultados o valores intermedios 1 |


### Contador de programa

### Registro de enlace

### Puntero de pila

### Puntero al registro de activación

Se conoce como [registro de
activación](http://diccionario.raing.es/es/lema/registro-de-activaci%C3%B3n) al
espacio que se reserva en la pila para enviar parametros y definir variables
locales, entre otras cosas.
## Registros especiales

## Bancos de registros

## Para saber más


* https://developer.arm.com/documentation/ihi0042/latest/

