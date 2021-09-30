---
title:  Llamadas a sistema en ensamblador para la Raspberry Pi
author: Gastón Hugo Salazar Silva
...

Los sistemas operativos se diseñaron para simplificar la vida de los
programadores de aplicaciones. Proveen rutinas para tareas como el manejo de
hardware, el control de procesos y la comunicación entre procesos. El simple
hecho de imprimir un mensaje en la pantalla requiere del manejo de *hardware*.

El [sistema operativo que utiliza la Raspberry
Pi](https://es.wikipedia.org/wiki/Raspberry_Pi_OS) es una distribución que
utiliza el [núcleo Linux](https://es.wikipedia.org/wiki/N%C3%BAcleo_Linux), el cual a
su vez se basa en el [núcleo
Unix](https://www.cs.miami.edu/home/burt/learning/Csc322.052/notes/wiu.html).

Para acceder a estas rutinas del núcleo de Linux, se hace a través del mecanismo
de [llamadas a
sistema](https://www.tutorialspoint.com/system-calls-in-unix-and-windows#:~:text=System%20calls%20in%20Unix%20are,control%20from%20the%20user%20process.).
Estás llamadas a sistema se implementan para poder ser realizadas a muy bajo
nivel, aunque la rutina de servicio de la llamada sea implementada a alto nivel.
Las llamadas a sistema se parecen a llamadas a subrutinas. Son diferentes a
llamar una rutina en el sentido de que el proceso de usuario le cede el control
de flujo al sistema operativo.
      
## "Hola, mundo!" con llamadas a sistema, versión en C

Si bien, buscamos entender cómo realizar una llamada a sistema en ensamblador,
podemos beneficiarnos de revisar rápidamente la versión en C. El siguiente
listado muestra un programa muy sencillo que escribe en la pantalla (salida
estándar) el mensaje "Hola, mundo!".

~~~
#include <unistd.h>

#define MENSAJE "Hola, mundo!\n"

int main()
{
    write(1, MENSAJE, 13);
}
~~~

Primero que nada, en el archivo de encabezado `unistd.h` se encuentra las
declaraciones necesarias para realizar llamadas a sistema desde C. La librería
estándar de C ofrece el código necesario para envolver una llamada a sistema en
una función de C. Por ejemplo, la llamada a sistema `write` se encuentra ahí
declarada como:

~~~
ssize_t write(int fd, const void *buf, size_t nbytes);
~~~

donde el primer argumento, `fd`, contiene el [descriptor de
archivo](https://es.wikipedia.org/wiki/Descriptor_de_archivo) (*file
descriptor*, en inglés), que para el caso de la salida estándar es 1. El segundo
argumento, `buf`, es un puntero que se utiliza para indicar en qué lugar de la
memoria está el mensaje, usualmente codificado como una cadena de caracteres. El
tercer argumento, `nbytes`, indica la longitud del arreglo de caracteres en
número de *bytes*. 

## "Hola, mundo!" con llamadas a sistema, versión en ensamblador

El siguiente ejemplo no es exactamente la traducción del código en C a
ensamblador, pero es una buena aproximación.

~~~
.data

MENSAJE:    .asciz  "Hola, mundo!\n"

.text

.global main
main:
    push {R7, LR}

    mov R0, #1
    ldr R1, =MENSAJE
    mov R2, #13

    mov R7, #4
    svc 0

    pop {R7, LR}
    bx  LR
~~~

A continuación describimos el código.

Primero que nada, este código se ensambla por medio por medio del compilador de
C; esto nos simplifica por ahorita algunas cosas, pero implica algunos detalles.
Por ejemplo, se utiliza como punto de entrada al programa la dirección de la
etiqueta `main`.

En segundo lugar, se va a transferir el flujo de control al sistema operativo; y
por ello necesitamos preservar parte del estado de la computación. Cuando
escribimos un programa en lenguaje C, el compilador hace eso por nosotros en
cualquier llamada a función, con ayuda de la pila; sin embargo, en ensamblador
esta acción se tiene que hacer manualmente. Los componentes requeridos para
salvar son los registros `R7` y `LR`. El registro `LR` contiene la dirección a
donde, una vez ejecutada la rutina main, el programa debe regresar. En cuanto a
la razón de salvar el registro `R7`, se explicará más adelante. Para salvar el
contenido de ambos registros se utiliza la instrucción `push`.

Como ya se vio en el caso del programa de C, la llamada a sistemas necesita
varios argumentos. Los valores de estos argumentos se almacenan en los registros
`R0`, `R1` y `R2`. En el registro `R0` se almacena el descriptor de archivo, que
para el caso de la salida estándar es 1. En el registro `R1` se almacena el
puntero del arreglo de caracteres que se va a imprimir. En el registro `R2` se
almacena la longitud en *bytes* del arreglo de caracteres.

En cuanto a la llamada a sistema, a nivel de lenguaje ensamblador se utiliza la
instrucción `svc` para realizar la llamada. La llamada específica a ejecutarse
se almacena en el registro `R7`. Para escribir un texto en un archivo se utiliza
la llamada a sistema `write`; esto se indica por el parámetro 4. Una tabla con
las llamadas a sistema se encuentra
[aquí](https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md#arm-32_bit_EABI).

Ya casi para terminar, necesitamos recuperar el estado de la computación
almacenado al principio. Para ello, se utiliza la instrucción `pop`.

Finalmente, como utilizamos la infraestructura del compilador de C, se espera que
`main` sea una subrutina y por lo tanto necesita regresar al punto donde fue
llamada. Para ello se utiliza la instrucción `bx LR` al final de la subrutina.

## Para saber más

* https://s-matyukevich.github.io/raspberry-pi-os/
* https://archive.fosdem.org/2017/schedule/event/programming_rpi3/attachments/slides/1475/export/events/attachments/programming_rpi3/slides/1475/bare_metal_rpi3.pdf
