---
title: Procesamiento en paralelo en ARM Cortex-A53
author: Gastón H. Salazar-Silva
layout: post
categories: dsp, embedded systems
...

https://bob.cs.sonoma.edu/IntroCompOrg-RPi/sec-gpio-pins.html
        .cpu    cortex-a53
        .fpu    neon-fp-armv8

Recordemos inicialmente que los procesadores digitales de señales se
especializan en transformar señales discretas. Un ejemplo típico es la
implementación del filtro de respuesta finita al impulso (FIR), que se puede
expresar de la siguiente forma

$$y[n]=\sum_{k=0}^{N}b_k x[n]$$

donde la señal $x$ es la entrada al filtro, la señal $y$ es la salida del
filtro, el entero $n$ es el orden del filtro, el entero $k$ indica el instante
de tiempo en que ocurre, y los escalares $b_k$ son los coeficientes del filtro.

Para poder implementar de forma eficiente este filtro en un procesador, éste
debe ser capaz de:

* Se debe sumar y multiplicar fracciones, y
* Se debe ejecutar rápidamente una secuencia de dichas operaciones.

**En la actividad 3 ya** se comentó como es la arquitectura de un DSP para poder
cumplir con estos requerimientos. Sin embargo, hay más formas de cumplirlos. Las
características funcionales y de arquitectura del procesador Arm Cortex-A53
permiten satisfacer estos requerimientos utilizando otros mecanismos.

Primeramente revisaremos las capacidades de paralelización de las que dispone el
Arm Cortex-A53, que dividiremos en dos partes:

* Procesador multinúcleos
* Núcleos superescalares

Después revisaremos la capacidad computacional del procesador, lo cual
dividiremos en dos partes:

* Procesador de 64 bits
* Extensiones NEON

Y de ahí pasaremos ver algunas consideraciones prácticas de la arquitectura: los
registros.

## Procesador Multinúcleos

Primeramente, en que es un procesador multinúcleos. Cuando decimos que un
procesador es multinúcleo, quiere decir que se combinan dos o más
microprocesadores independientes en un solo circuito integrado o paquete. Esto
proporciona la ventaja de que se puede dividir un programa en hilos y ejecutar
estos hilos en paralelo. El procesador Arm Cortex-A53 puede contener de 1 a 4
núcleos (ver figura siguiente).

| ![Arquitectura del Arm Cortex-A53](https://i1.wp.com/raspberryparatorpes.net/wp-content/uploads/2016/02/Cortex-A53-chip-diagram.png?w=606&ssl=1) |
|:-----:|
| Figura: Arquitectura del Arm Cortex-A53. Fuente: manuti (2016). Cortex-A53. Raspberry para torpes. [En línea, recuperado el 2 de octubre de 2020]. [https://raspberryparatorpes.net/glossary/cortex-a53/]. |

![Procesador Arm Cortex-A53](https://developer.arm.com/-/media/Arm%20Developer%20Community/Images/Block%20Diagrams/Cortex-A%20Processor/Cortex-A53.png?revision=1903cd57-7149-435d-ab9c-07946ddf0ef3&la=en&hash=FA7D6F6FD6091A432FB55CF45CA4E5B736EE1DC5)

En el caso de la Raspberry Pi, que utiliza el procesador Arm Cortex-A53, se
tienen 4 núcleos.

| ![Miiicihiaieil  Hieinizilieir / Wikimedia Commons / CC BY-SA 4.0](https://upload.wikimedia.org/wikipedia/commons/f/f1/Raspberry_Pi_4_Model_B_-_Side.jpg) |
|:----:|
| Figura: Raspberry Pi. Fuente: Henzler, M. (2019). Raspberry Pi 4 Model B from the side. [Fotografía]. Recuperado de https://commons.wikimedia.org/w/index.php?title=File:Raspberry_Pi_4_Model_B_-_Side.jpg&oldid=440586323. CC BY-SA 4.0. | 

## Núcleos superescalares

Cada núcleo del procesador Arm Cortex-A53 es superescalar. Un **procesador
superescalar** puede ejecutar más de una instrucción por ciclo de reloj. La
microarquitectura superescalar permite implementar paralelismo de instrucciones
y paralelismo de flujo. Este último gracias a la estructura en segmentación de
instrucciones.

La estructura típica de un procesador superescalar consta de una segmentación de
instrucciones (pipeline) con 6 etapas:

1. Lectura (fetch).
2. Decodificación (decode).
3. Lanzamiento (dispatch).
4. Ejecución (execute).
5. Escritura (writeback).
6. Finalización (retirement).

Sin embargo, en cada núcleo del Arm Cortex-A53 se implementa una segmentación de
instrucciones de 8 etapas, como se puede ver en la siguiente figura.

| ![](https://images.anandtech.com/doci/11441/arm-a75_a55-cpu_diagram-a53.png) |
|:-----:|
| Figura: Cola de segmentación de instrucciones en el procesador Arm Cortex-A53. Fuente: AnandTech (2017). CPU diagram a53. [Diagrama]. Recuperada de https://www.anandtech.com/show/11441/dynamiq-and-arms-new-cpus-cortex-a75-a55/4. |

Cada núcleo puede despachar instrucciones simultáneamente a diferentes unidades
de ejecución dentro del núcleo. Una unidad de ejecución puede ser

* Una unidad aritmético-lógica (Arithmetic-Logic Unit, o ALU),
* Una unidad de generación de direcciones (Address Generation Unit, o AGU), o
* Un multiplicador-acumulador (Multiplier-Accumulator, MAC).

Un efecto de esto, es que el orden de ejecución afecta si una instrucción se
puede ejecutar mientras se ejecuta otra. Normalmente una instrucción se ejecuta
una detrás de otra si ocupan la misma unidad de ejecución. Pero si ocupan
diferentes unidades de ejecución, se puede enviar una instrucción a una unidad
de ejecución y la siguiente a otra unidad de ejecución. No todas las unidades de
ejecución son capaces de desarrollar la operación requerida en un ciclo, por
ejemplo el acceso a memoria.

A continuación se muestra un ejemplo de como el orden del código afecta la ejecución.

~~~
ldr r1, =memoria1
mov r2, #42
add r3. r1, r2
~~~

~~~
mov r2, #42
ldr r1, =memoria1
add r3. r1, r2
~~~

Figura: Orden de ejecución afecta el número de instrucciones por ciclo. Ambos
códigos realizan la misma tarea; toman un valor almacenado en la memoria y lo
almacenan en el registro r1, cargan el registro r2 con una constante y suman
ambos valores, almacenando el resultado en el registro r3. Sin embargo, el
código de la izquierda se ejecutará un ciclo de reloj más rápido que el de la
derecha.

## Efectos sobre el ciclo for de la arquitectura RISC y un compilador optimizador

Una manera de representar en lenguaje C un convolución discreta finita es por
medio del siguiente código.

~~~
const unsigned int N = 3; // Orden del filtro

const float h[] = {.25, .25, .25, .25};
float x[] = {1., -1., 1., -1.};

double y = 0.0;
for (int k=0, i=N+1; k <= N+1; k++, i--) {
        y = y + h[k] * x[i];
}
~~~
Listado. Implementación naif de convolución.

En el caso de un procesador con arquitectura RISC, este código se puede
simplificar. En general, los procesadores con esta arquitectura están diseñados
para considerar que el código de máquina se desarrollará con ayuda de un
compilador, y en particular un compilador optimizador. Este tipo de compilador
cuenta con una técnica conocida desenroscado de bucle.

~~~
const unsigned int N = 3;

const float h[] = {.25, .25, .25, .25};
float x[] = {1., -1., 1., -1.}; 

double y = 0.0;
int k = 0;
int i = N+1;

y = y + h[k++] * x[i--];
y = y + h[k++] * x[i--];
y = y + h[k++] * x[i--];
y = y + h[k] * x[i];
~~~
Listado. Bucle desenroscado para el caso de que n=3.

Usualmente los procesadores de arquitectura RISC también incluyen operaciones de
indexado con post-incremento y post-decremento. Con el desenroscado de bucle se
transfiere el costo en tiempo a costo en espacio. Sin embargo, actualmente esto
es más económico y también permite reducir el problema de vaciar la cola de
instrucciones a causa de saltos en arquitecturas superescalares.

**Observación**. No es el programador el que debe realizar la optimización, sino
el compilador.

## Arquitectura de 64 Bits

En el procesador Arm Cortex-A53 se implementa la arquitectura AARCH64. Esta
arquitectura es una extensión de 64 bits de arquitectura Arm, lo cual permite
tener operandos de 64 bits y tener un espacio de memoria de 2^64 bytes.

Sin embargo, es importante notar que el procesador Arm Cortex-A53 es compatible
la arquitectura AARCH32. De hecho, sobre esta arquitectura trabajaremos, ya que
el sistema operativo a utilizar será Raspberry Pi OS, el cual se desarrolla
sobre AARCH32.

## Extensiones NEON

La tecnología NEON es una extensión para los procesadores Arm Cortex-A y
Cortex-R. Esta extensión implementa una arquitectura de paralelización llamada
una instrucción, múltiples datos (Single Instruction Multiple Data, SIMD).

La extensión avanzada de SIMD y punto flotante es una de las razones, por las
que el procesador Arm Cortex-A53 se puede utilizar en procesamiento digital de
señales.

Esta extensión implementa, llamada Arm NEON, que es la técnica de cómputo en
paralelo de una instrucción, múltiples datos (Single Instruction Multiple Data,
SIMD). Con esta esta tecnología se números de punto flotante y enteros. También
tiene instrucciones para codificar números de punto fijo .

Figura: Logo de la extensión NEON. Fuente: Arm (2020). Neon Example Image [Imagen]. Recuperada de https://developer.arm.com/architectures/instruction-sets/simd-isas/neon.

La arquitectura SIMD aplica una misma operación sobre un arreglo de datos, de
tal manera que la misma instrucción se ejecuta simultáneamente sobre todos los
elementos del arreglo. Dicho de otra manera, permite vectorizar operaciones.

La extensión NEON está pensada para el procesamiento de señales, por ejemplo
audio y video. También se puede aplicar para aplicaciones de aprendizaje
profundo  e inteligencia artificial.
