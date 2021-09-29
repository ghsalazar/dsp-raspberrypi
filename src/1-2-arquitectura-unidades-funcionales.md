---
title: 1 3 Unidades funcionales del BCM2837
category: dsp, arquitectura
...


## VideoCore IV

<iframe width="560" height="315" src="https://www.youtube.com/embed/eZd0IYJ7J40" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Cortex-A53

Usar procesamiento-paralelo-cortex-a53.md

![Procesador Arm Cortex-A53](https://developer.arm.com/-/media/Arm%20Developer%20Community/Images/Block%20Diagrams/Cortex-A%20Processor/Cortex-A53.png?revision=1903cd57-7149-435d-ab9c-07946ddf0ef3&la=en&hash=FA7D6F6FD6091A432FB55CF45CA4E5B736EE1DC5)


## Memoria caché nivel 2

Se tiene en el BCM2837 una memoria caché nivel 2 (L2 cache), la cual se comparte
entre todas las unidades computacionales del VideoCore IV y el ARM Cortex-A53.

Una memoria caché es una memoria pequeña de acceso rápido que utilizan los CPU.
Este tipo de memoria se utiliza usualmente para almacenar temporalmente los
datos que se están procesando.

Esta memoria es de nivel 2, ya que todas las unidades computacionales del
VideoCore IV (*slices*) y los núcleos del ARM Cortex-A53 tienen su propias
memorias caché L1.

Esta memoria se utiliza además en el proceso de arranque del BCM2837.
## Memoria SDRAM

https://es.wikipedia.org/wiki/SDRAM

## Proceso de arranque


Al energizar el BCM2837, el estado inical es que el VideoCore IV está encendido, el ARM
Cortex-A53 está apagado y la memoria SDRAM está deshabilitada. 

El proceso de arranque es el siguiente:

1. El VideoCore IV ejecuta un programa de arranque a partir de una memoria de
   sólo lectura.
2. El programa de arranque habilita la lectura de la primera partición de la
   tarjeta SD.
3. El programa de arranque carga el archivo `bootcode.bin` a la memoria caché
   nivel 2 (*L2 cache*) desde la tarjeta micro SD.
4. El programa de arranque ejecuta el programa `bootcode.bin`.
5. El programa `bootcode.bin` habilita la memoria SDRAM.
6. El programa `bootcode.bin` carga a la memoria SDRAM el archivo `start.elf`
   desde la tarjeta micro SD.
7. El programa `bootcode.bin` ejecuta a `start.elf`.
8. El programa `start.elf` lee el archivo `config.txt`.
9. El programa `start.elf` carga el archivo `kernel7.img` a la memoria SDRAM
   correspondiente al ARM Cortex-A53.
10. El programa `start.elf` inicializa el ARM Cortex-A53.
11. El ARM Cortex ejecuta el núcleo `kernel7.img`.

El núcleo `kernel7.img` procederá a realizar más acciones y configuraciones

La tarjeta micro SD tiene al menos dos particiones. La primera partición es la
partición de arranque y tiene un sistema de archivos
[FAT32](https://en.wikipedia.org/wiki/File_Allocation_Table#FAT32). En esta
partición se encuentran los archivos `bootcode.bin`, `start.elf`, `config.txt` y
`kernel7.img`.

La segunda partición tiene un sistema de archivos
[ext4](https://es.wikipedia.org/wiki/Ext4), que es la que usa normalmente el
sistema operativo Linux.

## Para saber más

https://docs.broadcom.com/doc/12358545

http://meseec.ce.rit.edu/551-projects/spring2017/2-3.pdf

https://archive.fosdem.org/2017/schedule/event/programming_rpi3/attachments/slides/1475/export/events/attachments/programming_rpi3/slides/1475/bare_metal_rpi3.pdf

https://developer.arm.com/ip-products/processors/cortex-a/cortex-a53

https://www.raspberrypi.org/forums/viewtopic.php?t=6685

https://github.com/dwelch67/raspberrypi

https://www.radishlogic.com/raspberry-pi/sd-card-partitions-installing-raspbian-raspberry-pi/

https://www.raspberrypi.org/forums/viewtopic.php?f=2&t=3042

https://www.codedivine.org/2014/03/03/broadcom-videocore-iv-architecture-overview/