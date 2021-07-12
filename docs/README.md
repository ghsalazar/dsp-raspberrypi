# Procesamiento de señales digitales con la Raspberry Pi 

Una de las aplicaciones más importantes de los sistemas embebidos es el
procesamiento digital de señales.

Si bien se disponen de procesadores digitales de señales, usualmente no se
dispone de tarjetas lo suficientemenete económicas o accesibles para poder
experimentar con ellas. Por eso se escogió el [sistema en
chip](https://es.wikipedia.org/wiki/System_on_a_chip) [Broadcom
BCM2837](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bcm2837/README.md).
Este sistema en chip (SoC, por sus siglas en inglés) tiene varias
características que son adecuadas para el procesamiento digital de señales. Una
tarjeta muy accesible que cuenta con este SoC es la Raspberry Pi 3A+.

## Contenido

A continuación se muestra un índice propuesto del contenido. Por el momento,
este índice refleja realidad el programa propuesto por la UPIITA-IPN para el
procesador uitilizado en el curso. Sin embargo, eventualmente convergerá al SoC
Broadcom BCM2837.

* Primeros pasos con el SoC Broadcom 2837 (¿blink?)
    * Arquitectura
        * Unidades funcionales
        * Registros
        * Modos de direccionamiento (Directo, indirecto, circular)
    * Procesamiento en paralelo
        * Procesamiento de Suma de Multiplicaciones Aditivas (MAC's )
    * Uso y mapeo de memoria interna/externa
        * Manejo de memoria Flash
        * Vector de interrupciones
* Llamadas al sistema operativo Linux con el SoC Broadcom BCM2837
    * Introducción al IDE del DSP
        * Opciones de compilación
        * Opciones de ligado.
    * Lenguaje ensamblador y directivas de ensamblador.
        * Lista de instrucciones.
        * Llamada a funciones.
        * Consideraciones de memoria.
    * DSP/BIOS.
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