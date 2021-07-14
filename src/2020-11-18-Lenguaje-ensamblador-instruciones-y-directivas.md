---
title: Lenguaje ensamblador - instrucciones, mnemónicos y directivas
author: Gastón Hugo Salazar Silva
layout: post
lang: es
...

> **En resumen**
> 
> Una **instrucción** de lenguaje de máquina es una operación que se procesa en
> la ejecución del programa. Las instrucciones se definen por la arquitectura
> del procesador.
>
> Un **mnemónico** es un símbolo que representa a una instrucción de lenguaje de
> máquina. Los mnemónicos se definen por el lenguaje ensamblador.
>
> Una **directiva** es una operación que se procesa en el ensamblado del
> programa, no en su ejecución. Las directivas se definen por el programa
> ensamblador.

En un programa escrito en lenguaje ensamblador se mezclan en realidad dos
lenguajes diferentes.

Primero que nada hay que entender que la computadora no ejecuta directamente un
programa en ensamblador, sino que ejecuta un programa en lenguaje de máquina.
Este programa se compone de **instrucciones**, las cuales están definidas por la
arquitectura del procesador. Las instrucciones tienen la función de modificar el
estado del programa durante su ejecución. [Por
ejemplo](https://www.realdigital.org/doc/2f85bd55ef59ddbfcf64206f4421d5de), en
un procesador Arm de 32 bits, la instrucción para sumar los contenidos de los
registros R1 y R2, para luego colocar el resultado en el registro R4 se hace por
medio de la siguiente instrucción representada en binario:

~~~
111000000100100010010000000000100
~~~

El primer lenguaje que se utiliza en un programa en lenguaje ensamblador es
precisamente el lenguaje ensamblador, el cual está compuesto por
[**mnemónicos**](https://es.wikipedia.org/wiki/Mnem%C3%B3nico#:~:text=En%20inform%C3%A1tica%2C%20un%20mnem%C3%B3nico%20o,el%20concepto%20de%20lenguaje%20ensamblador.),
que son una representación simbólica de las instrucciones en lenguaje de
máquina. Este lenguaje es el que se va a transformar en lenguaje de máquina.
Utilizando el [ejemplo
anterior](https://www.realdigital.org/doc/2f85bd55ef59ddbfcf64206f4421d5de), se
tiene el siguiente código en lenguaje ensamblador para un [procesador Arm de 32
bits](https://developer.arm.com/documentation/dui0802/b/A32-and-T32-Instructions):

~~~
adds R4, R1, R2
~~~

El segundo lenguaje se compone de **directivas**. Éstas no se van transformar a
lenguaje de máquina, sino que modifican el comportamiento del ensamblador
mientras procesa los mnemónicos a lenguaje de máquina. Las directivas permiten
extender el lenguaje ensamblador para manejar conceptos como variables,
constantes, etc. A las directivas también se les conoce como
[seudoinstrucciones](https://www.encyclopedia.com/computing/dictionaries-thesauruses-pictures-and-press-releases/pseudoinstruction).
Las directivas varían dependiendo del programa ensamblador utilizado. Las
directivas utilizadas por el [ensamblador
Arm](https://developer.arm.com/documentation/dui0802/b/Directives-Reference/Alphabetical-list-of-directives)
no son las mismas que las del [ensamblador
GNU](https://www.ic.unicamp.br/~celio/mc404-2014/docs/gnu-arm-directives.pdf).
Un ejemplo de directiva para este último ensamblador sería la definición de una
constante TEST con el valor 1:

~~~
.equ TEST, 1
~~~

Finalmente, los lenguajes de programación también pueden tener directivas. Un
caso específico es C, que tiene [directivas de
preprocesador](https://docs.microsoft.com/es-es/cpp/preprocessor/preprocessor-directives?view=msvc-160#:~:text=Las%20directivas%20de%20preprocesador%2C%20como,en%20diferentes%20entornos%20de%20ejecuci%C3%B3n.&text=Las%20directivas%20del%20archivo%20de,preprocesador%20que%20realice%20acciones%20espec%C3%ADficas.).
En este caso las directivas se procesan antes del compilado o durante la
compilación.
