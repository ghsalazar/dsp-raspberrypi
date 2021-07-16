---
title: ¿Qué es un un procesador digital de señales?
author: Gastón H. Salazar-Silva
layout: post
categories: dsp, embedded systems
...

(*Procesamiento de señales en sistemas embebidos*)

Un procesador digital de señales (DSP, por sus siglas en inglés) es un
procesador diseñado especialmente para transformar señales discretas.

Una aplicación típica de un DSP es la implementación del filtro de respuesta
finita al impulso (FIR, por sus siglas en inglés). Éste se analizará más
adelante en el curso, pero se revisará como repercute dicho filtro en el diseño
del DSP.

Un filtro de FIR se define a partir de la ecuación


$$y[n] = \sum_{k=0}^N b_i x[n-i]$$

donde las variables $x[n]$ e $y[n]$ representan las señales de entrada y salida
al filtro, respectivamente, en el tiempo $n$. Las constantes
$b_0, b_1, \ldots, b_N$ son los coeficientes del filtro.

Un filtro de FIR impone ciertas consideraciones en la arquitectura de un DSP:

* Ejecutar ciclos lo más rápidamente posible,
* Ejecutar de la manera más rápida la operación y ← y + b × x,
* Manejar fracciones de forma eficiente, y
* Acceder a la memoria lo más rápidamente posible para leer las entradas y coeficientes.

El siguiente video muestra la importancia del procesamiento de señales en el mundo moderno.

<iframe width="560" height="315" src="https://www.youtube.com/embed/EErkgr1MWw0" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Ejecución eficiente de ciclos

Otra forma en que se puede expresar el filtro de FIR, es utilizar la forma
recursiva

$$\begin{aligned} 
    s_0 &= 0,\\
    s_1 &= s_0 + b_0 x[n],\\
    s_2 &= s_1 + b_1 x[n-1],\\
    s_3 &= s_2 + b_2 x[n-2],\\
    &\vdots\\
    s_{N+1} &= s_N + b_N x[n-N].
\end{aligned}$$

Finalmente, el resultado final $y[n]$ está dado por la expresión.

$$y[n] = s_{N+1}.$$

La recursión anterior se puede implementar forma iterativa, como se puede
apreciar en el siguiente programa de C.

~~~{C}
int main()
{
    const unsigned int N = 3;
    const float b[] = {.25, .25, .25, .25};
    float x[] = {.4, .3, .2, .1};

    double y = 0.0;
    for (int k = N; k >= 0; k--)
    {
        y = y + b[k] * x[k];
    }
}
~~~

Un DSP de alto rendimiento permite realizar las operaciones en el ciclo for en
un sólo paso. Para ello, se desarrolla un nivel muy alto de paralelismo en su
arquitectura. Por ejemplo, disponen en hardware todo lo requerido para realizar
en paralelo todas operaciones requeridas por dicho ciclo for. Esto se conoce
como **ciclos con cero sobrecostos**.

## Ejecución eficiente de la operación $y \leftarrow y + b\times x$

Como ya se vio, un filtro de FIR se puede expresar por medio de una recursión.
Ésta se puede expresar de la forma

$$s_{i+1} = s_{i} + b_i x[n-i]$$

donde la base de la recursión es

$$s_{0} = 0.$$

En un DSP, se dispone un hardware especializado que se llama unidad
multiplicadora-acumuladora (MAC, por sus siglas en inglés), la cual implementa
la operación

$$y \leftarrow y + b\times x,$$

y la cual se realiza en un sólo ciclo de reloj.

## Manejo eficiente de fracciones

Transformar señales discretas en el tiempo implica realizar operaciones con
números reales. Lamentablemente esto es imposible con las computadoras digitales
por la cantidad de memoria que se necesitaría.

Una solución consiste utilizar números racionales o fracciones. Esto implicará
un error numérico en el procesamiento, pero este error se puede acotar y ser
reducido.

Una forma de representar a un número racional $y$ es por medio de la notación
científica

$$y = m \times \beta^{-n}$$

donde el número entero $m$ se denomina mantisa, la constante entera $\beta$ es
la base y el número entero $n$ es el exponente. Por limitaciones de memoria, se
tiene que tanto $m$ como $n$ están acotados,

Aquí es donde se dividen estos números en dos campos:

* Si $n$ es constante, se tienen los números de punto fijo.
* Si $n$ es variable, se tienen los números de punto flotante.

Ambos tienen ventajas y desventajas. En general, operar con números de punto
fijo conlleva más error, pero es mucho más rápido que trabajar con números de
punto flotante.

Los DSP siempre implementan funcionalidades para trabajar con números de punto
fijo; ocasionalmente, también tienen la capacidad de operar directamente números
de punto flotante.

## Acceso rápido a memoria para arreglos

La estructura de datos que utiliza un filtro de FIR es el arreglo. Tanto los
coeficientes como las entradas se almacenan en arreglos. Por lo mismo, se busca
poder acceder a los elementos de estos arreglos lo más rápido posible.

Usualmente un DSP se implementa con la [arquitectura
Harvard](https://es.wikipedia.org/wiki/Arquitectura_Harvard). En esta
arquitectura se hace diferencia entre la memoria donde residen las instrucciones
y la memoria donde se encuentran los datos. Las instrucciones no sólo se
almacenan en un banco de memoria diferente a los datos, sino que además se
acceden por buses de direccionamiento y de datos diferentes.

Es decir, un procesador en esta arquitectura cuenta con dos buses de
direccionamiento y dos buses de datos, como se puede aprecia en la imagen.

| ![Arquitectura Harvard (cortesía de Wikipedia)](https://upload.wikimedia.org/wikipedia/commons/thumb/3/38/Harvard_architecture-es.svg/640px-Harvard_architecture-es.svg.png) |
|:---:|
| **Arquitectura Harvard (cortesía de Wikipedia)** |

Se utiliza esta arquitectura en el caso de un DSP, porque permite manejar los
coeficientes y las entradas en memorias diferentes, lo cual permite una
paralelización a la hora de acceder a la memoria.

## Conclusiones

A forma de conclusión, enumeraremos las diferencias que existen entre un
microprocesador de propósito general, un microcontrolador y un DSP. Estas
diferencias se muestran en la siguiente tabla.

| Característica             | Microprocesador   | Microcontrolador   | DSP                |
|----------------------------|-------------------|--------------------|--------------------|
| Operaciones básicas | $A\leftarrow B, A \leq B$ | $bit\leftarrow 0, bit \leftarrow 1$ | $A\times B, A+B$ |
| Memoria                    | Externa           | Interna            | Externa            |
| Periféricos                | Externos          | Internos           | Externos           |
| Consumo de potencia        | Alta              | Baja               | -                  |
| Velocidad de procesamiento | Alta              | Baja               | Baja               |
| Arquitectura de memoria    | Von Neuman        | Harvard            | Harvard            |
| Aplicación                 | Proposito general | Sistemas embebidos | Sistemas embebidos |

Éstas características son importantes a la hora de decidir que tipo de
dispositivo se va a utilizar. La familia de procesadores Arm Cortex tiene
procesadores para cada caso. Es importante notar que existen procesadores que
abarcan mas de un propósito específico.