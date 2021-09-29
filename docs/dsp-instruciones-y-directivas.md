---
title: Lenguaje ensamblador --- instrucciones y directivas
author: Gastón Hugo Salazar Silva
date: 2020-11-12
lang: es
...

* Existen muchas formas de categorizar los lenguajes de programación.
    * Una forma es flexibilidad vs desempeño.
    * Usualmente los lenguajes con mayor flexibilidad no tienen un buen
      desempeño por si mismos.
    * Por otro lado, los lenguajes con mejor desempeño no tienen mucha
      flexibilidad.
    * Claro que existen excepciones, por ejemplo Lisp, pero esa es otra historia.

* Existen diferentes lenguajes de programación.
    * Normalmente cada lenguaje de programación tiene un nicho donde resulta
      especialmente útil.
        * Por ejemplo, lenguaje Python se utiliza para aplicaciones de interfaz
          entre diferentes programas, protocolos o servicios.
            * Sin embargo, no es muy útil para aplicaciones que requieren mucha
              velocidad.
        * Por otro lado, el lenguaje C no es muy flexible sintácticamente pero
          permite escribir programas para aplicaciones de alto desempeño.
        * El lenguaje ensamblador no es flexible sintácticamente
            * Es decir, se tiene que ser muy preciso a la hora de escribir las
              instrucciones.
            * Sin embargo, por lo general se tiene el mejor desempeño.        

* En un programa de lenguaje ensamblador se mezclan en realidad dos lenguajes
  diferentes.
    * Uno de esos lenguajes es el que se va a transformar en lenguaje de
      máquina. Ese lenguaje está compuesto por las **instrucciones** definidas por
      la arquitectura. Las intrucciones modifican el estado del programa durante
      su ejecución.
    * El otro lenguaje no se va transformar a lenguaje de máquina, pero
      modifican el comportamiento del ensamblador mientras procesa el código en
      lenguaje ensamblador.

> **Nota**
>
> Una **instrucción** es una operación que se procesa en la ejecución del
> programa.
>
> Una **directiva** es una operación que se procesa en el ensamblado del
> programa, no en su ejecución.

# Instrucciones

* En lenguaje ensamblador, un mismo símbolo que puede representar a muchas
  instrucciones diferentes de lenguaje de máquina (**Referencia**).
    * Sin embargo, es importante notar que existen diferencias dependiendo del
      de dato
* Las instrucciones de lenguaje ensamblador se conocen como mnemonicos.


## Instrucciones de movimiento de datos

* El primer subconjunto de instrucciones que analizaremos son las intrucciones
  que mueven información entre diferentes espacios de memoria.
    * De registro a registro (direccionamiento de registro)
    * De memoria de código a registro (direccionamiento inmediato)
    * De memoria de datos a registro y viceversa

* Es importante recordar que si bien un procesador puede manejar su memoria en
  un solo banco de memoria (arquitectura Von Neumann) o dos bancos de memoria
  (arquitectura Harvard), normalmente la organización de la memoria de un
  programa se divide usualmente en al menos dos espacios o **secciones**:
    * Texto o memoria de código, donde reside las instrucciones del programa.
    * Datos o memoria de datos, donde se almacenan los datos (globales).

> **Nota**
>
> Una **sección** es un espacio de memoria que cumple una función determinada.
> Se utilizan las secciones para organizar la memoria del programa. 

> **Nota**
>
> En el lenguaje C se utilizan cuatro secciones diferentes para organizar la
> memoria:
>
> * Texto (*Text*),
> * Datos (*Data*),
> * Montículo (*Heap*), un espacio donde la memoria se gestiona manualmente,
> * Pila (*Stack*) es un espacio de memoria donde el espacio se gestiona
>   automáticamente.

### Direccionamiento de registro

* El dato se copia de un registro de origen, `Rs`, a un registro de destino, `Rd`.

~~~
mov Rd, Rs
~~~

### Direccionamiento inmediato

* Mover datos entre registros no es realmente muy útil a menos que podamos
  llenar previamente el registro de origen con la información que desamos
  procesar.
    * Para ello se utiliza el direccionamiento inmediato.
    * El dato se códifica dentro de instrucción de lenguaje de máquina.
    * En un procesador RISC, las instrucciones abarcan exactamente una palabra.
    * Esto reduce el tamaño posible de un dato
    * Es importante recordar que el dato es un número entero.

> **Nota**
>    
> En el direccionamiento inmediato, el dato se encuentra en la memoria de código
> o sección de Texto.

~~~
mov Rd, #<número>
~~~

Por ejemplo, deseamos mover el número 42 al registro `R3`

~~~
mov R3, #42
~~~

### Instrucciones de acceso a la memoria de datos

#### Direccionamiento directo

* Hay que recordar que en los conjuntos de instrucciones reducidas las
  instrucciones sólo operan con la información que está en los registros.
* Por ello tienen intrucciones para mover datos de la memoria 
* Para mover un dato de la memoria de datos, o sección de datos, a un registro
  de destino, `Rd` se uiliza la instrucción `ldr`

~~~
ldr Rd, <dirección de origen>
~~~

~~~
str Rs, <dirección de destino>
~~~


#### Direccionamiento indirecto

~~~
ldr Rd, [<puntero>]
~~~

~~~
str Rs, [<dirección de destino>]
~~~

## Instrucciones aritméticas

* Se tienen una diversidad de operaciones aritméticas en el procesador Arm
  Cortex-A53

+------------------+----------------+
| add Rd, Rs1, Rs2 | Rd = Rs1 + Rs2 |
+------------------+----------------+
| sub Rd, Rs1, Rs2 | Rd = Rs1 - Rs2 |
+------------------+----------------+

## Instrucciones lógicas

## Instrucciones de control de flujo

# Directivas

* Los lenguajes de programación también pueden tener directivas.
    * Un caso específico es C, que tiene dos niveles de directivas:
        * Directivas de preprocesador
        * Pragmas.
    * En este caso las directivas se procesan antes del compilado o durante la
      compilación.
      
