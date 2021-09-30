---
title: Un primer programa en ensamblador para el ARM Cortex-A53
author: Gastón H. Salazar-Silva
layout: post
categories: dsp, embedded systems
...

El programar en lenguaje ensamblador es una competencia muy importante para
programar sistemas embebidos, sobre todo en aplicaciones de procesamiento de
señales.

Una ventaja de la tarjeta Raspberry Pi es que incluye todo un entorno de
desarrollo en el sistema operativo. Además, permite el interfaz entre el
lenguaje C y el ensamblador de una manera muy natural.

Implementaremos un programa extremadamente sencillo en ensamblador con la
tarjeta Raspberry Pi en una configuración *head-less*.

## Antes de empezar

Primero requerimos una tarjeta Raspberry Pi 3B+, o similar, con su fuente de
poder.

También necesitamos una tarjeta de memoria micro SD de al menos 16 GB con el
sistema operativo Raspberry Pi OS. El sistema operativo debe estar configurado
para operar sin monitor ni teclado. En la publicación [How to Set Up a Headless
Raspberry Pi, Without Ever Attaching a
Monitor](https://www.tomshardware.com/reviews/raspberry-pi-headless-setup-how-to,6028.html),
se muestra como realizar esto. Asumiremos que realizamos las actividades de esta
publicación en todo lo que sigue.

En segundo lugar, ocupamos una computadora PC con el sistema operativo Windows 10.
Se puede utilizar otro tipo de equipo y sistema operativo; sin embargo, sólo
consideraremos el caso para una computadora PC con Windows 10.  En ésta
necesitamos instalar:
* un cliente para el protocolo SSH, como por ejemplo [PuTTY](https://www.putty.org/), y
* el programa [Bonjour Print Services para
  Windows](https://support.apple.com/kb/DL999?locale=es_ES).

Además, nos hará falta un [cable Ethernet
cruzado](https://xxxamin1314.medium.com/t568a-vs-t568b-cu%C3%A1l-es-la-diferencia-entre-el-cable-directo-y-el-cable-cruzado-3da883c1bb62)
para conectar directamente la PC a la tarjeta por medio del interfaz Ethernet,
sin necesidad de un conmutador o concentrador de red. Si disponemos de un
concentrador o conmutador, podemos usar un cable directo.

# Conexión por medio de SSH

Primero que nada, hay que insertar la tarjeta micro SD en la tarjeta
Raspberry Pi. En esta tarjeta de memoria ya tenemos instalado el sistema
operativo en configuración *head-less*. Encendemos la tarjeta Raspberry Pi.

Conectamos la tarjeta Raspberry Pi y la computadora PC por medio del cable
Ethernet cruzado.

Iniciamos el cliente de SSH y configuramos para conectarse a la tarjeta Raspberry
Pi por medio del nombre `raspberrypi.local`.

Una vez iniciada la conexión, iniciamos la sesión (*log in*) en la Raspberry Pi.

## Escribiendo el programa

Para escribir el programa en la Raspberry Pi, utilizaremos el [editor
`nano`](https://es.wikipedia.org/wiki/GNU_Nano). Este editor es lo
suficientemente simple para poder empezar.

Para iniciar el editor `nano`, en la línea de comando de la Raspberry insertamos el
siguiente comando:

~~~
pi@raspberrypi:~ $ nano programa1.s
~~~

Deberá aparecer el editor nano en la terminal PuTTY

| ![Editor `nano`](/assets/images/raspberry-nano.png) |
|:-----:|
| Figura: Editor `nano`. |

Utilizando el editor `nano`, insertamos el siguiente código

~~~{asm}
.global main

main:
    mov r0, #42
    bx lr
~~~

El resultado se puede ver en la siguiente figura.

| ![Programa en el editor `nano`](/assets/images/raspberry-nano-programa1-s.png) |
|:-----:|
| Figura: Programa en el editor `nano`. |

Para salvar el programa, presionamos el conjunto de teclas `Ctrl-O` (*Write Out*). Se
debe ver una pantalla como en la siguiente figura.

| ![Salvando el programa en el editor `nano`](/assets/images/raspberry-nano-program1-s-write-out.png) |
|:-----:|
| Figura: Salvando el programa en el editor `nano`. |

Entonces presionamos la tecla `Enter` para completar el proceso de salvar el
archivo.

Finalmente, para salir del editor `nano`, presionamos las teclas `Ctrl-X`.

## Explicación del programa

A continuación explicaremos renglón por renglón el código. Primero que nada,
para ensamblar el código utilizaremos la infraestructura del compilador de C
para la Raspberry Pi. Esto nos permite simplificar mucho el desarrollo del
código, pero introduce ciertas obligaciones.

La primera obligación viene de que el compilador de C espera que exista una
función llamada `main`. En ensamblador, las funciones se llaman subrutinas.
Entonces debemos tener una subrutina con el símbolo `main`. Pero además, el
símbolo `main` debe ser global. Esto es similar a las declaraciones en el
lenguaje C. Para ello usamos la directiva `.global`, como se ve en el listado
siguiente.

~~~{asm}
.global main
~~~

A continuación viene la definición del símbolo `main` como la dirección de
inicio de la subrutina. Para ello, simplemente lo indicamos usando el signo
ortográfico de dos puntos, `:`, después del símbolo. Cuando veamos un símbolo
seguido de `:`, le llamamos etiqueta.

~~~{asm}
main:
~~~

En siguiente renglón tenemos la instrucción `mov`. Esta instrucción permite
cargar a un registro un valor literal o inmediato. En este caso, lo que estamos
haciendo es cargar el [número
42](https://es.wikipedia.org/wiki/El_sentido_de_la_vida,_el_universo_y_todo_lo_dem%C3%A1s)
en el registro `r0`. Es importante ponerle al número el prefijo `#`.

~~~{asm}
    mov r0, #42
~~~

Finalmente, la instrucción `bx` permite saltar a una dirección que esté almacenada
en un registro. El símbolo `lr` representa al registro `r15`, que se utiliza para
almacenar la dirección de retorno cuando se llama a una subrutina. 

~~~{asm}
    bx lr
~~~

## Ensamblado

Como ya mencionamos, el compilador de C tiene la capacidad de ensamblar
programas. Para ello deben de tener la extensión `.s`. El compilador llamará al
ensamblador y al enlazador. El resultado será el programa `a.out`. Entonces
ejecutamos el compilador de C con la siguiente línea de comando.

~~~
pi@raspberrypi:~ $ gcc programa1.s                                                                           
~~~

Para ver el archivo `a.out`, ejecutamos en la línea de comando la siguiente
instrucción.

~~~
pi@raspberrypi:~ $ ls a.out                                                                           
~~~

El resultado deberá ser como en la figura siguiente.

| ![Revisando el archivo `a.out`](/assets/images/raspberry-ls-a-out.png) |
|:-----:|
| Figura: Revisando el archivo `a.out`. |


Finalmente, ejecutamos el programa que se ensambló utilizando la siguiente
instrucción.

~~~
pi@raspberrypi:~ $ ./a.out
~~~

Es importante colocar el el punto y la diagonal al principio. No deberá verse
respuesta, ya que el programa como tal no tiene capacidad de imprimir el
resultado. Para visualizar el resultado, tecleamos la siguiente instrucción.

~~~
pi@raspberrypi:~ $ echo $?
~~~

Deberá imprimirse el [número
42](https://es.wikipedia.org/wiki/El_sentido_de_la_vida,_el_universo_y_todo_lo_dem%C3%A1s).

## Para saber más

* [How to Set Up a Headless Raspberry Pi, Without Ever Attaching a
  Monitor](https://www.tomshardware.com/reviews/raspberry-pi-headless-setup-how-to,6028.html).
* [Setting up a Raspberry Pi for a robot – Headless by Default
  [Tutorial]](https://hub.packtpub.com/setting-up-a-raspberry-pi-for-a-robot-headless-by-default-tutorial/).
* [How to emulate a Raspbian OS in QEMU on Windows
  10](https://dominoc925.blogspot.com/2019/09/how-to-emulate-raspbian-os-in-qemu-on.html).
* [Raspberry Pi Emulator for Windows 10](https://www.instructables.com/Raspberry-Pi-Emulator-for-Windows-10/).
* [Learn Linux with Raspberry Pi](https://learn.adafruit.com/series/learn-linux-with-raspberry-pi).
* [ARM assembler in Raspberry Pi](https://thinkingeek.com/arm-assembler-raspberry-pi/).
* https://www.raspberrypi.org/documentation/configuration/boot_folder.md
* https://buildroot.uclibc.org/
* https://www.yoctoproject.org/