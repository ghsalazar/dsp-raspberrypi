---
title:      Interfaces de comunicación serial de la Raspberry Pi
author:     Gastón Hugo Salazar Silva
date:       2021-06-08
tags:       DSP, raspberry-pi
layout:     post
lang:       es
usemathjax: true
...

Por comunicación serial, entendemos que es la transmisión y recepción de datos por medio de una secuencia de bits, transmitiendo un bit la vez por medio del mismo cable o canal.

Preferimos utilizar la comunicación serial sobre la paralela en sistemas de comunicación a larga distancia, donde se vuelve difícil utilizar la comunicación paralela debido a los problemas de  sincronización, [diafonía](https://es.wikipedia.org/wiki/Diafon%C3%ADa) y costo del cable o del medio.

La tarjeta Raspberry Pi tiene varias interfaces físicas de comunicación serial, tales como:

* Comunicación asíncrona serial,
* Interfaz de periféricos serie, y
* Circuito inter-integrado.

## Comunicación serial

La función de la comunicación es el envío de un mensaje de un transmisor a un
receptor. Los mensajes son listas de símbolos. En comunicaciones digitales los
símbolos se componen de una serie de bits.

Se tienen dos tipos de comunicación digital: paralela y serial. En la
comunicación en paralelo, todos los bits de cada símbolo se envían
simultáneamente y, por lo tanto, debe haber al menos tantas líneas de
comunicación como bits de el símbolo a transmitir. La comunicación paralela
puede ser muy rápida, pero surgen varios problemas cuando se transmiten en
paralelo una gran cantidad de bits, como interferencias o problemas de
desincronización.

En cuanto a la comunicación serial, cada símbolo se envía de un bit a la vez, de
forma secuencial, a través de un canal o bus de comunicación. Una ventaja de la
comunicación serial es que requiere menos líneas de transmisión que la
comunicación en paralelo que lleva la misma información.

Con la misma frecuencia de transmisión, la comunicación paralela tiene un
rendimiento superior. La comunicación serial debe compensar esta desventaja con
una frecuencia de transmisión mayor.

## Comunicación asíncrona serial

La [comunicación asíncrona
serial](https://en.wikipedia.org/wiki/Asynchronous_serial_communication) es un
sistema de comunicación que no utiliza una señal de reloj *común* al transmisor
y al receptor.

En lugar de utilizar un mismo reloj, se utiliza un símbolo de inicio y un
símbolo de parada para sincronizar al transmisor y al receptor.

La comunicación asíncrona serial tiene su origen en el telégrafo eléctrico. En
un sistema telegráfico, todos  los telégrafos se conectaban en serie, y el
transmisor de cada uno de ellos siempre estaba
cortocircuitado. Cuando se iba a transmitir un mensaje, se ponía el transmisor
en circuito abierto, lo cual era la indicación de inicio de transmisión. Cuando
se detenía la transmisión, se volvía a cortocircuitar el transmisor. 

Este sistema se replicó en los
[teletipos](https://es.wikipedia.org/wiki/Teletipo). Mientras la clave Morse usa
un [código de longitud
variable](https://es.wikipedia.org/wiki/C%C3%B3digo_de_longitud_variable#:~:text=Se%20conoce%20como%20c%C3%B3digo%20de,mucho%20m%C3%A1s%20probable%20que%20se),
los teletipos usan un [código de longitud
fija](https://www.encyclopedia.com/computing/dictionaries-thesauruses-pictures-and-press-releases/fixed-length-code);
esto permite simplificar el problema de sincronización.

Para poder realizar la comunicación, debemos de tener varios parámetros
establecidos con anticipación en el transmisor y receptor. Los parámetros más
frecuentes son:

* Tipo de operación: [dúplex o semidúplex](https://es.wikipedia.org/wiki/D%C3%BAplex_(telecomunicaciones)).
* El número de bits por carácter: 5, 6, 7 u 8.
* Número de símbolos por segundo o [baudios](https://es.wikipedia.org/wiki/Baudio): 57600 por ejemplo.
* El tipo de [paridad](https://es.wikipedia.org/wiki/Bit_de_paridad) utilizada: par, impar o ninguna.
* El número de bits de parada: 1, 1.5 o 2.

| ![](https://upload.wikimedia.org/wikipedia/commons/4/47/Puerto_serie_Rs232.png) |
|:---:|
| **Figura 1**. Diagrama de la trama de datos usada en la comunicación asíncrona serial (*fuente: [Wikimedia]()*). |

Otros parámetros los usamos de manera implícita o, rara vez, de forma explícita:

* El ordenamiento de los bits, que se conoce como
  [*endianness*](https://es.wikipedia.org/wiki/Endianness).
* La definición de los símbolos de marca y espacio, es decir cuando un bit es 0
  y cuando es 1.

En la actualidad, usamos un dispositivo llamado [transmisor--receptor asíncrono
universal](https://es.wikipedia.org/wiki/Universal_Asynchronous_Receiver-Transmitter) (UART,
por sus siglas en inglés) para la comunicación asíncrona serial.

En el siguiente video se muestra las bases de la comunicación serial y en
particular la comunicación asíncrona.

<iframe width="560" height="315" src="https://www.youtube.com/embed/u1pKHLy4yxk" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Interfaz de periféricos serie

La [interfaz de periféricos
serie](https://es.wikipedia.org/wiki/Serial_Peripheral_Interface) (SPI, por sus
siglas en inglés) es un sistema de [comunicación serial
síncrona](https://en.wikipedia.org/wiki/Synchronous_serial_communication). Por
comunicación síncrona se entiende que existe una señal de reloj común entre el
transmisor y el receptor, la cual se envía por un cable o canal separado.

La utilizamos fundamentalmente para la comunicación entre un procesador y uno o varios
periféricos a corta distancia.

La arquitectura de la SPI es
[cliente--servidor](https://es.wikipedia.org/wiki/Cliente-servidor) y una
topología tipo [bus](https://es.wikipedia.org/wiki/Red_en_bus). La operación es
[dúplex](https://es.wikipedia.org/wiki/D%C3%BAplex_(telecomunicaciones)).

Es importante remarcar que puede haber varios clientes; pero sólo
puede haber un servidor.

| ![](https://upload.wikimedia.org/wikipedia/commons/thumb/f/fc/SPI_three_slaves.svg/363px-SPI_three_slaves.svg.png) |
|:---:|
| **Figura 2**. Un maestro y varios esclavos sobre un bus SPI (*fuente: [Wikimedia](https://commons.wikimedia.org/wiki/File:SPI_three_slaves.svg)*). |

Un ejemplo de aplicación puede ser el uso del convertidor analógico--digital
[MCP3008](https://learn.adafruit.com/raspberry-pi-analog-to-digital-converters/mcp3008)
con la Raspberry Pi.

<iframe width="560" height="315" src="https://www.youtube.com/embed/Qgazac5v8P8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


## Circuito inter-integrado

El circuito inter-integrado (I2C, por sus siglas en inglés) es un sistema de
comunicación síncrona, cliente--servidor, con [conmutación de
paquetes](https://es.wikipedia.org/wiki/Conmutaci%C3%B3n_de_paquetes) y
topología de bus.

Es importante remarcar, que a diferencia de la SPI, I2C puede tener múltiples
servidores.

Se utiliza para la comunicación entre microprocesadores y periféricos.

| ![](https://upload.wikimedia.org/wikipedia/commons/thumb/3/3e/I2C.svg/425px-I2C.svg.png) |
|:---:|
| **Figura 3**. Ejemplo de un bus I2C con servidor y múltiples clientes (*fuente: [Wikimedia](https://commons.wikimedia.org/wiki/File:I2C.svg)*). |

Un ejemplo con la Raspberry Pi es [la comunicación con una tarjeta
Arduino](https://blog.330ohms.com/2020/07/07/como-conectar-arduino-y-raspberry-pi-por-comunicacion-i2c/).

<iframe width="560" height="315" src="https://www.youtube.com/embed/mi24IxXEqzA" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


## Historia de la comunicación serial

En el siguiente video podemos ver como se implementaba electromecánicamente una
interfaz asíncrona serial. Como ya mencionamos, los teletipos fueron unos de los
precursores de la comunicación asíncrona serial.

<div style="position:relative;padding-bottom:56.25%;height:0;overflow:hidden;"> <iframe style="width:100%;height:100%;position:absolute;left:0px;top:0px;overflow:hidden" frameborder="0" type="text/html" src="https://www.dailymotion.com/embed/video/x4971bc" width="100%" height="100%" allowfullscreen > </iframe> </div>


## Conclusiones

La tarjeta Raspberry Pi tiene varias interfaces para la comunicación serial;
como son la comunicación asíncrona serial, la interfaz de periféricos serie y el
circuito inter-integrado.

La comunicación serial se prefiere a la paralela en sistemas de comunicación a
larga distancia, donde la comunicación paralela puede presentar problemas de
sincronización, [diafonía](https://es.wikipedia.org/wiki/Diafon%C3%ADa) y el
costo del cable.

