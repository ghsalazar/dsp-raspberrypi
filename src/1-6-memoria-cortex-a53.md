---
title: Memoria del procesador BCM2837
layout: post
...

De acuerdo a la [documentación de la Raspberry Pi](), las tarjetas Raspberry Pi
3 utilizan el procesador Broadcom BCM2837. Este procesador tiene como base un
procesador ARM Cortex-A53 de 4 núcleos.

Es importante notar que el mapa de memoria de este procesador es idéntico al
procesador [Broadcom BCM2836](https://datasheets.raspberrypi.org/bcm2836/bcm2836-peripherals.pdf).

## Mapa de memoria

El procesador Broadcom BCM2837 cuenta con un solo espacio de memoria, pero
disponemos de tres representaciones distintas de ella (**figura**): el mapa de
memoria del procesador Broadcom Video Core, el correspondiente al procesador ARM
Cortex y el mapa de memoria virtual.

| ![](https://i.stack.imgur.com/Js3yh.png) |
|:---:|
| **Figura**. Mapa de memoria del procesador Broadcom BCM2835 (*fuente: [Understanding BCM2835 memory map](https://www.raspberrypi.org/forums/viewtopic.php?t=262747)*). |

El primer mapa de memoria corresponde al procesador Broadcom
[VideoCore IV](https://en.wikipedia.org/wiki/VideoCore), el cual es es un
procesador multimedia de baja potencia para aplicaciones móbiles.
Es importante entender que el Broadcom VideoCore es el [procesador principal de
la Raspberry Pi
3](https://www.raspberrypi.org/forums/viewtopic.php?t=84118#p595463) y no el
procesador ARM Cortex-A53.

El segundo mapa de memoria representa a la memoria del procesador VideoCore IV
vista desde la perspectiva del direccionamiento físico del ARM Cortex-A53, a
traves de su [unidad de gestión de
memoria](https://es.wikipedia.org/wiki/Unidad_de_gesti%C3%B3n_de_memoria) (MMU,
por sus siglas en ingles).

El tercer mapa es el espacio de [memoria
virtual](https://es.wikipedia.org/wiki/Memoria_virtual), que es el espacio de
memoria que puede ver el usuario.

## Memoria física

* Es importante notar que la memoria del SoC está conectada al procesador
  VideoCore IV.
* El procesador ARM Cortex-A53 se monta sobre esa memoria, vía la [unidad de
  gestión de
  memoria](https://es.wikipedia.org/wiki/Unidad_de_gesti%C3%B3n_de_memoria)
  (MMU, por sus siglas en inglés). 
* Es importante notar que el SoC BCM2837 se basa en el BCM2835, pero la
  [dirección base para los periféricos es
  0x3F000000](https://github.com/enricorov/Pinterrupt), mientras que en el
  BCM2835 es 0x7E000000.


## Unidades de gestión de memoria

* El BCM2837 tiene dos unidades de gestión de memoria
* [unidad de gestión de
  memoria](https://es.wikipedia.org/wiki/Unidad_de_gesti%C3%B3n_de_memoria)
  (MMU, por sus siglas en inglés).

## Direccionamiento físico en el procesador ARM Cortex-A53


## Memoria virtual

https://s-matyukevich.github.io/raspberry-pi-os/docs/lesson06/rpi-os.html


## Conclusiones

* Se tienen dos mapas de memoria y pueden llegar a ser tres:
  * El mapa de memoria física, la cual está asociada al procesador VideoCore IV.
  * El mapa de direccionamiento del procesador ARM Cortex-A53.
  * El mapa de memoria virtual, en el caso de usar el sistema operativo Linux.
* Esto produce que un mismo espacio de memoria pueda tener tres diferentes
  direcciones; por ejemplo para el caso de la dirección base de los periféricos
  se tienen:

|    | Memoria física | Direccionamiento en el ARM Cortex-A53 | Memoria virtual |
|:--:|:--------------:|:-------------------------------------:|:---------------:|
| Base de memoria SDRAM | 0xC0000000 | 0x00000000 | 0xC0000000 |
| Base de periféricos   | 0x3F000000 | 0x20000000 | 0xF2000000 |

## Para saber más

* Gay, Warren W. (2014). *Raspberry Pi Hardware Reference*.
  https://doi-org.www.bibliotecadigital.ipn.mx/10.1007/978-1-4842-0799-4

* https://docs.broadcom.com/doc/12358545

* https://github.com/hermanhermitage/videocoreiv/wiki/VideoCore-IV-Programmers-Manual

* https://s-matyukevich.github.io/raspberry-pi-os/


https://cseweb.ucsd.edu/classes/wi17/cse237A-a/handouts/03.mem.pdf
https://developer.arm.com/documentation/ddi0500/d/ch09s02s01
https://www.macs.hw.ac.uk/~hwloidl/Courses/F28HS/Docu/DEN0013D_cortex_a_series_PG.pdf **
https://developer.arm.com/documentation/den0013/d/ARM-Architecture-and-Processors **

https://www.raspberrypi.org/app/uploads/2012/02/BCM2835-ARM-Peripherals.pdf#page=5 *******
https://www.raspberrypi.org/forums/viewtopic.php?t=84118 ****
