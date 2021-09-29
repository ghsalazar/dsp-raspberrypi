---
title:  Periféricos básicos de la Raspberry 
author: Gastón Hugo Salazar Silva
...

## Introducción

La tarjeta Raspberry Pi 3B+ dispone de un conector especial de 40 pines a una
interfaz de [entrada--salida de propósito
general](https://www.raspberrypi.org/documentation/usage/gpio/) (GPIO, por sus
siglas en inglés). Esta interfaz permite controlar *hardware* externo al
procesador de la Raspberry Pi y que podemos usar en programas de aplicación. En
la figura 1, podemos ver el diagrama del conector utilizado por la GPIO.

![**Figura 1**: Diagrama del conector de la interfaz de
GPIO [@RaspberryPiFoundation2020]](https://www.raspberrypi.org/documentation/computers/images/GPIO-Pinout-Diagram-2.png){width=50%}

Los pines de la interfaz de GPIO pueden cumplir una gran variedad de funciones
[@RaspberryPiFoundation2020], como por ejemplo:

* Entrada
* Salida
* [Modulación de ancho de
  pulso](https://es.wikipedia.org/wiki/Modulaci%C3%B3n_por_ancho_de_pulsos)
  (PWM, por sus siglas en inglés) por *software*.

Además, algunos pines tienen funciones especiales; tales como:

* PWM en *hardware*.
* [Interfaz serie para
  periféricos](https://es.wikipedia.org/wiki/Serial_Peripheral_Interface) (SPI,
  por sus siglas en inglés) (SPI0 y SPI1).
* [Circuito inter-integrado](https://es.wikipedia.org/wiki/I%C2%B2C) (I^2^C, por
  sus siglas en inglés).
* [Puerto serie](https://es.wikipedia.org/wiki/Puerto_serie)

Existen varios programas y librerías para utilizar la GPIO de la Raspberry Pi;
sin embargo, no todos son recomendados por el fabricante y otros se han vuelto
obsoletos. Uno de los recomendados por el fabricante es
[`gpiod`](https://kernel.googlesource.com/pub/scm/libs/libgpiod/libgpiod/+/refs/heads/master/README)
[@Golaszewski2021].

El sistema `gpiod` consiste en dos componentes. El primer componente es la
librería `libgpiod`. La librería permite desarrollar programas en C y C++.
Revisaremos la librería más adelante.

El segundo componente son un conjunto de programas que permiten acceder a la
interfaz de GPIO, así como modificar o consultar valores de los pines, desde la
línea de comando.

## Material, equipo y *software*.

### Material

* Resistencia de 220 Ohm.
* Led rojo.
* Cables *jump* macho--macho.

### Equipo

* Raspberry Pi 3B+ con conexión a Internet.
* Computadora PC con conexión a Internet.

### Software

* Raspbian OS en tarjeta microSSD.

## Actividad: Comando `pinout`

En la Raspberry Pi, podemos consultar la disposición de las terminales del
conector de la interfaz GPIO, por medio del comando `pinout`
[@RaspberryPiFoundation2020].
    
![**Figura 3**: Resultado de la ejecución del comando `pinout`
[@RaspberryPiFoundation2020]](https://www.raspberrypi.org/documentation/computers/images/gpiozero-pinout.png){width=50%}


## Actividad: Instalar `gpiod`

Para instalar los programas de `gpiod`, empezaremos por actualizar el sistema de
paquetes del Raspeberry Pi OS y después realizar la instalación como tal,
utilizando la línea de comando de la Raspberry. Podemos ver las instrucciones en
el siguiente listado:

<<raspberry-install-gpiod.sh>>=
sudo apt update
sudo apt -y install gpiod
@

## Actividad: Visualizar el estado de la GPIO

Ya que tenemos instalada la librería y los programas, podemos usar comandos
para manipular la interfaz de GPIO. Por ejemplo, el comando `gpiodetect` muestra
los diferentes interfaces de la GPIO:

~~~{.sh}
gpiodetect
~~~

![Resultado del comando
`gpiodetect`](https://raw.githubusercontent.com/ghsalazar/dsp-images/main/images/raspberry-pi-gpiodetect.png){width=50%}

Podemos ver el resultado del comando en la figura, donde se muestran tres
interfaces diferentes. La interfaz que nos interesa es `gpiochip0`. La siguiente
operación será ver que líneas o pines tiene disponible la interfaz. Esto lo
hacemos por medio de siguiente comando

~~~{.sh}
gpioinfo gpiochip0
~~~

![Resultado del comando `gpioinfo`](https://github.com/ghsalazar/dsp-images/raw/main/images/raspberry-pi-gpioinfo.png){width=50%}


## Actividad: Manipulando la GPIO desde la línea de comando

![**Figura**. Ensamble el circuito de la figura.](https://github.com/ghsalazar/dsp-images/raw/main/images/raspberry-pi-gpio-led.png)

Existen otros dos comandos importantes. El primero es `gpioset`. Este comando
convierte una línea o pin en salida y le da un valor especificado. Por ejemplo,

~~~{.sh}
gpioset gpiochip0 24=1
~~~

le indica a la interfaz `gpiochip0` que convierta en salida a la línea 24 o
`GPIO24` y le asigne un valor de 1. Por otro lado

~~~{.sh}
gpioset gpiochip0 24=0
~~~

hace lo mismo, pero le asigna a GPIO24 el valor de 0. El comando gpioset tiene
más capacidades y se recomienda leer su
[manual](https://manpages.debian.org/experimental/gpiod/gpioset.1.en.html).

El otro comando es `gpioget`. Este comando convierte una línea o pin en entrada
y lee el valor que tiene. Por ejemplo

~~~{.sh}
gpioget gpiochip0 24
~~~

le indica a la interfaz `gpiochip0` que convierta en entrada a la línea 24 o
`GPIO24` y lea el valor que tiene.

A continuación, se tiene un ejemplo completo, aprovechando el comando gpioinfo.
También se utiliza el comando [grep](https://es.wikipedia.org/wiki/Grep) para
filtrar los resultados.

~~~{.sh}
gpioinfo gpiochip0 | grep 24
gpioset gpiochip0 24=0
gpioinfo gpiochip0 | grep 24
gpioget gpiochip0 24
gpioinfo gpiochip0 | grep 24
~~~

![Resultados de ejecutar `gpioset` y `gpioget` sobre
GPIO24.](https://github.com/ghsalazar/dsp-images/raw/main/images/raspberry-pi-gpioset-gpioget.png){width=50%}


## Aplicaciones con `libgpiod`

El uso de programas en el espacio de usuario puede permitir acelerar el
desarrollo de una aplicación; sin embargo, este tipo de programas pueden
alentar un proceso. Por lo tanto, conviene normalmente utilizar un lenguaje
compilado para asegurar un mejor desempeño.

Al instalar los programas en el espacio del usuario, se incluyó el paquete
de la librería `libgpio`; pero para poder desarrollar un programa en C
se necesita además los archivos de encabezado. Para ello instalaremos el paquete
`libgpio-dev` por medio de las siguientes instrucciones

<<raspberry-install-gpiod.sh>>=
sudo apt install libgpiod-dev
@

Una vez instalada la librería es posible desarrollar un programa en C,
como el del ejemplo del siguiente listado.


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