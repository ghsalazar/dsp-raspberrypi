---
layout: page
...

Una de las aplicaciones más importantes de los sistemas embebidos es el
procesamiento digital de señales.

Si bien se disponen de procesadores digitales de señales, usualmente no se
dispone de tarjetas lo suficientemenete económicas o accesibles para poder
experimentar con ellas. Por eso se escogió el [sistema en
chip](https://es.wikipedia.org/wiki/System_on_a_chip) [Broadcom
BCM2837](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bcm2837/README.md).
Este sistema en chip (SoC, por sus siglas en inglés) tiene varias
características que son adecuadas para el procesamiento digital de señales. Una
tarjeta muy accesible que cuenta con este SoC es la tarjeta [Raspberry Pi
3A+](https://www.raspberrypi.org/products/raspberry-pi-3-model-a-plus/).

Para seguir el contenido del curso, se asume que ya se tiene conocimiento básico
de arquitectura de procesadores y lenguaje ensamblador, aunque sea en otro
procesador, como el [ATmega328p](https://arduino.cl/arduino-uno/). Un curso
introductorio de ensamblador para el SoC BCM2837 lo puede encontrar
[aquí](https://thinkingeek.com/arm-assembler-raspberry-pi/). 


## Contenido

A continuación se muestra un índice propuesto del contenido. Por el momento,
este índice refleja en realidad el programa propuesto por la UPIITA-IPN para el
procesador uitilizado en el curso. Sin embargo, eventualmente convergerá al SoC
Broadcom BCM2837.

* Arquitectura del SoC Broadcom 2837 (¿blink?)
    * Unidades funcionales
    * Registros
    * Modos de direccionamiento (Directo, indirecto, circular)
    * Procesamiento en paralelo
        * Procesamiento de Suma de Multiplicaciones Aditivas (MAC's )
    * Uso y mapeo de memoria interna/externa
        * Manejo de memoria Flash
        * Vector de interrupciones
    * Actividad: Primeros pasos con el SoC Broadcom 2837 (¿blink?)
* Programación del SoC Broadcom BCM2837
    * Introducción al IDE del DSP
        * Opciones de compilación
        * Opciones de ligado.
    * Lenguaje ensamblador y directivas de ensamblador.
        * Lista de instrucciones.
        * Llamada a funciones.
        * Consideraciones de memoria.
    * Sistema operativo Linux
    * Lenguaje C/C++
        * Depuración de código
* Periféricos Básicos del SoC Broadcom BCM2837
    * Codificador/Decodificador (Codec)
    * Temporizadores
    * Puerto General de Entradas/Salidas (GPIO)
* Comunicaciones con el SoC Broadcom BCM2837
    * Integrados Interconectados (12C)
    * Interface de Puerto Serie (SPI)
* Periféricos Avanzados del SoC Broadcom BCM2837
    * Acoplador Multicanal de Puerto Serie (MCBSP)
    * Puerto serie asíncrono multicanal (MCASP)
    * Acceso directo a Memoria Enriquecida (EDMA)
    * Interface Servidor - Puerto
* Ambientes de programación alternativos para el SoC Broadcom BCM2837DSP
* Implementación Filtros Digitales con el SoC Broadcom BCM2837
    * FIR
    * IIR
    * Adaptable.
* Implementacion de una RNA con el SoC Broadcom BCM2837

## Colofón

La estructura que se seguirá para el curso será similar a la propuesta de
[Sergey Matyukevich para su curso
raspberry-pi-os](https://s-matyukevich.github.io/raspberry-pi-os/).