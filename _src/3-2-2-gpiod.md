---
title:  Control de la GPIO desde lenguaje C 
author: Gastón Hugo Salazar Silva
layout: post
...

## Introducción

Para controlar a la interfaz GPIO de la Raspberry Pi es necesario poder acceder
a la memoria sin restricciones. Sin embargo, esto no puede ser así cuando se
utiliza un sistema operativo con [memoria
virtual](https://es.wikipedia.org/wiki/Memoria_virtual), tal como es
[GNU/Linux](https://es.wikipedia.org/wiki/GNU/Linux).

Existen diferentes formas de acceder a la GPIO bajo GNU/Linux. Sin embargo, el
método actualmente aprobado es por medio de la librería `libgpiod`. Este método
no sólo es más seguro sino, además, es más portable.

## Archivos: La interfaz universal de Unix (y GNU/Linux)

Antes de continuar, es importante notar que todos los dispositivos de una
computadora bajo Unix se modelan como si fueran archivos.

Los archivos se pueden visualizar como una lista de caracteres. La longitud de
la lista puede ser fija o variable.

Para leer un carácter de esa lista, se posiciona un puntero en la posición de la
lista donde se encuentra ese carácter y se accede su valor. Para escribir un
carácter, se posiciona el puntero en la posición requerida y se
modificas ese valor en la lista.

El sistema operativo cuenta con diferentes
[subrutinas](https://es.wikipedia.org/wiki/Subrutina) para posicionar el puntero
en la lista ([`lseek(2)`](https://man7.org/linux/man-pages/man2/lseek.2.html)),
y leer y escribir un carácter sobre esta lista
([`read(2)`](https://man7.org/linux/man-pages/man2/read.2.html) y
[`write(2)`](https://man7.org/linux/man-pages/man2/write.2.html)).

Sin embargo, no siempre es posible mapear todas las operaciones que se realizan
sobre el dispositivo como escrituras y lecturas. Para esas operaciones existen
subrutinas especializadas.

![Arquitectura de la interfaz `gpiod`.](../assets/figures/arquitectura-gpiod.svg)

En la figura anterior, podemos ver como funciona este sistema. Una aplicación
puede hacer las llamadas a sistema directamente o por medio de una librería
(`libgpiod`), como se muestra en la figura. Las llamadas a sistema operan por
medio del sistema de archivos del sistema operativo, que ofrece la interfaz
común de archivo y se conecta al controlador de dispositivo `gpiod`. El
controlador accede la dirección física del SoC Broadcom 2837 y escribe valores a
los registros adecuados de la GPIO, o lee los valores que se encuentran en esos
registros.
## Librería `libgpiod`

Existen diversas formas de acceder a la GPIO. Sin embargo, la forma sugerida
actualmente por los desarrolladores de Linux es por medio de la librería
`libgpiod`. Si uno instala el paquete `gpiod`, se incluyó el paquete de la
librería `libgpiod`.

Pero para poder desarrollar un programa en C, necesitamos además los archivos de
encabezado. Para ello instalaremos el paquete `libgpiod-dev` por medio de las
siguiente instrucción:

<<raspberry-install-gpiod.sh>>=
sudo apt install libgpiod-dev
@

Una vez instalada la librería es posible desarrollar un programa en C,
como vemos en el siguiente ejemplo.


## El programa `blink`


<script src="http://gist-it.appspot.com/https://github.com/ghsalazar/dsp-raspberrypi/raw/main/examples/blink.c"></script>

El código anterior puede parecer muy complicado para empezar a programar la GPIO
de la Raspberry Pi. Para ello partiremos el código en su diferentes secciones.
La primera sección consiste en simplemente un comentario.

<<blink.c>>=
/** Es un pequeño ejemplo de las funcionalidades del interfaz del GPIO  */
/** de la Raspberry Pi por medio de la librería libgpiod.               */
/**                                                                     */
/** Para compilar el programa, se debe utilizar el comando:             */
/**     gcc blink.c -lgpiod -o blink                                    */

@

Lo más importante del comentario es la última línea, que indica como se debe
compilar el ejemplo desde la línea de comando del Raspberry Pi OS. El
compilador de C utilizado es el
[`gcc`](https://iie.fing.edu.uy/~vagonbar/gcc-make/gcc.htm). Este compilador es
el más utilizado en el entorno de programación GNU/Linux. Este compilador tiene
un conjunto muy amplio de opciones.

En el comentario se manejan dos opciones. La primera opción (`-lgpiod`) indica
que el programa se debe enlazar a la librería `libgpiod`. La segunda opción (`-o
blink`) explicita cual nombre tendrá el programa final.

A continuación, se tiene la inclusión de dos archivos de encabezado.

<<blink.c>>=
#include <unistd.h>
#include <gpiod.h>

@

Cuando incluimos archivos de encabezado, se anexan declaraciones de funciones.
En el archivo [`unistd.h`](https://en.wikipedia.org/wiki/Unistd.h), tenemos la
declaración de la función
[usleep(3)](https://man7.org/linux/man-pages/man3/usleep.3.html), que suspende
la ejecución del programa por un intervalo medido en microsegundos (us).

Por otro lado, en el archivo `gpiod.h` tenemos las declaraciones de las
funciones que nos permiten acceder a la GPIO de la Raspberry Pi.

A continuación, tenemos el inicio de la definición de la función `main`.

<<blink.c>>=
int main()
{
@

Hay que recordar que en el lenguaje C, la función `main` es donde reside el
programa principal.

En el siguiente segmento de código tenemos la definición del primer objeto.

<<blink.c>>=
    struct gpiod_chip *chip;
@

En el lenguaje C, no tenemos objetos como tal; pero podemos agrupar una serie de
atributos por medio de estructuras. La estructura de datos que vamos a utilizar
es `gpiod_chip`. Dicha estructura está declarada en el archivo de encabezado
`gpiod.h`. El objeto ocupará un espacio en la memoria y utilizamos el
[puntero](https://es.wikipedia.org/wiki/Puntero_(inform%C3%A1tica)) `chip` para
almacenar la dirección de ese espacio de memoria.

A continuación, produciremos el objeto por medio de la siguiente línea.

<<blink.c>>=
    chip = gpiod_chip_open_by_name("gpiochip0");

@

La función `gpiod_chip_open_by_name` también se encuentra declarada en el
archivo de encabezado `gpiod.h` y definida el la librería `libgpiod`. La función
toma un espacio de memoria, le asigna valores determinados y regresa la
dirección del espacio de memoria.

A continuación, realizaremos la declaración para dos punteros más.

<<blink.c>>=
    struct gpiod_line *led;
    struct gpiod_line *button;

@

El puntero `led` se utilizará para localizar el objeto que se utilizará para
controlar un led. Por otro lado, `button` apuntará al objeto que estará
relacionado con la entrada de un botón.

Luego, se inicializarán ambos objetos.

<<blink.c>>=
    led    = gpiod_chip_get_line(chip, 24);
    button = gpiod_chip_get_line(chip, 6);

@

La función `gpiod_chip_get_line` sirve para asignar la memoria de ambos objetos
y regresa la dirección de memoria de cada objeto. El objeto en si está
relacionado con el pin físico de la GPIO que se desea utilizar. En el caso del
led, se utilizará el pin 24. Por otro lado, al botón se le asignará el pin 6.

Como `gpiod` esta embebido dentro del sistema operativo Linux, no se puede
acceder directamente al *hardware*. Hay que solicitar ese acceso. Recordemos que
una de las finciones de un sistema operativo es administrar el uso de recursos
por programas de aplicación.

<<blink.c>>=
    gpiod_line_request_output(led, "myLED", 0);
    gpiod_line_request_input(button, "button");

@

El programa se diseño fundamentalmente como un [autómata
temporizado](https://en.wikipedia.org/wiki/Timed_automaton). El automata tiene
dos estados posible y conmuta de uno a otro después que pasó un tiempo. 

<<blink.c>>=
    int state = 1;
@

Emplearemos otra variable, `input`, para almacenar el estado del interruptor.
Cuando el interruptor es presionado, se envía una señal de 0. Cuando no está
presionado, da 1.

<<blink.c>>=
    int input = 1;
@

Todo lo anterior fue para configurar el autómata. Equivaldría a lo que se hace
en la función `setup` del entorno Arduino. A continuación viene el ciclo
principal (*main loop*). De este ciclo se puede salir cuando se presiona el
interruptor.

<<blink.c>>=
    while (input == 1) {
@

Como ya se mencionó, el programa opera como un autómata temporizado. El cambio
de estado se da por medio de una operación XOR, que usa para [invertir el bit
menos
significativo](https://es.wikipedia.org/wiki/Operador_a_nivel_de_bits#Invirtiendo_bits_selectivamente)
de la variable. Es decir si la variable `state` tiene un valor de 1, pasa a 0, y
viceversa.

<<blink.c>>=
        state = state ^ 1;
@

La salida del programa es el led. Utilizamos la variable `state` para encender o
apagar el led. Para ello nos ayudamos de la función `gpiod_line_set_value`.

<<blink.c>>=
        gpiod_line_set_value(led, state);
@

Por otro lado, necesitamos leer el valor del pin que esta conectado al botón.
Esto lo hacemos por medio de la función `gpiod_line_get_value`.

<<blink.c>>=
        input = gpiod_line_get_value(button);
@

La última instrucción del ciclo es un temporizador que inactiva el proceso por
un tiempo de $500 000 \mu\textrm{s}$ o equivalentemente 0.5 s. La función usada
es `usleep(3)`.

<<blink.c>>=
        usleep(500000);
    }

@

Si presionamos el botón, el ciclo se rompe y el programa empieza a preparar lo
necesario para finalizar su ejecución. El primer paso es apagar el led. 

<<blink.c>>=
    gpiod_line_set_value(led, 1);
@

Así como solicitamos el uso de algunos de los pines de la GPIO, tenemos que
avisarle al sistema operativo que el programa ya no necesita esos pines. para
ello se utiliza la función `gpiod_line_release`.

<<blink.c>>=
    gpiod_line_release(led);
    gpiod_line_release(button);
@

Finalmente función `main` termina.

<<blink.c>>=
    return 0;
}
@

## Conclusiones

## Referencias