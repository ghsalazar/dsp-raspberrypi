---
title:  Puerto serial bajo GNU/Linux
author: Gastón Hugo Salazar Silva
layout: post
date:   2021-10-18
...

La comunicación serial asíncrona se utiliza ampliamente en la industria. Si bien
ya casi no se usan los estándares clásicos, existen muchos sistemas que los
emulan. Uno de ellos es la comunicación serial vía USB.

El objetivo de la presente actividad es que implementemos la comunicación entre
una Raspberry Pi y una Arduino para enviar un mensaje por medio de la interfaz
USB. Primeramente, prepararemos la Arduino para enviar un mensaje. Después
ajustaremos los parámetros de comunicación de la Raspberry Pi. Y, finalmente,
Recibiremos el mensaje con la Raspberry Pi.

## Preparación del Arduino

La tarjeta Arduino incorpora varias interfaces seriales, como son la SPI, la I2C
y la UART. Sin embargo, la interfaz serial más accesible es por medio de la USB.

El siguiente programa activa la interfaz serial de la USB y envía el mensaje
"hola, mundo!" a través del puerto serial de forma constante, con una pausa de 1
segundo.

~~~
void setup() {
  Serial.begin(9600);
}

void loop() {
    Serial.println("Hola, mundo!");
    delay(1000);
}
~~~

## Preparación del puerto serial de la Raspberry Pi

Existen muchas razones por las que preparar el puerto serie bajo un sistema
operativo como GNU/Linux no es tan sencillo. Primero hay que recordar que todo
dispositivo físico se modela un archivo en Unix.

En el caso de los puertos seriales, se denominan terminales y se abrevian como
`tty`. Todos los archivos que corresponden a las terminales están en el
subdirectorio `/dev`. Para ver que terminales tenemos disponibles, podemos usar
la siguiente instrucción.

~~~
ls /dev/tty*
~~~

En el caso del puerto serial vía USB, el nombre del dispositivo es `ttyUSB0`.
El número final puede cambiar dependiendo si hay más interfaces serial
conectadas vía USB.

Por otro lado, existe una rica y "antiquísima" tradición en Unix, con nombres
muy abreviados para comandos y opciones muy barrocas. Un claro ejemplo de ello
es el comando [`stty`(1)](https://man.archlinux.org/man/stty.1.es).

Utilizamos el comando `stty` para ajustar los parámetros de comunicación del
puerto serial `ttyUSB0` para comunicarse con la Arduino. Para ello, utilizamos
la siguiente instrucción

~~~
stty 9600 cs8 -parenb -cstopb -ixon -echo -F /dev/ttyUSB0
~~~

donde tenemos que la velocidad de comunicación es 9600 baudios por segundo, el
tamaño de carácter es de 8 bits (cs8), no hay bit de paridad (-parenb), el
número de bits de parada es uno (-cstob), no hay control de flujo (-ixon) y ni
eco (-echo) en el puerto serial `ttyUSB0`. Se recomienda revisar el manual del
comando [`stty`(1)](https://man.archlinux.org/man/stty.1.es).

## Programa de comunicación serial en la Raspberry Pi

Finalmente, el programa de la Raspberry Pi para la comunicación serial se
presenta a continuación. Su función es copiar un carácter a la vez del puerto
serie a la salida estándar.

~~~
#include <unistd.h>
#include <fcntl.h>    

int main() {
    char byte;
  
    int fd = open("/dev/ttyUSB0", O_RDONLY);

    while(1) {
        read(fd, &byte, 1);
        write(STDOUT_FILENO, &byte, 1);
    }

    close(fd); // No se usa.
    return 0;
}
~~~

Pasaremos a explicar cada parte del programa. Primero tenemos los archivos de
encabezado. Como se van a usar las llamadas a sistema para manipular el puerto
serie, necesitamos el archivo `unistd.h` que tiene las declaraciones de dichas
llamadas.

~~~
#include <unistd.h>
~~~

Ciertos aspectos de las llamadas se simplifican por medio de algunas
macroinstrucciones (*macros*) que se encuentran en el archivo `fcntl.h`.

~~~
#include <fcntl.h>    
~~~

Ahora tenemos que definir la función `main`.

~~~
int main() {
~~~

Sólo tendremos dos variables. La primera es `byte`, cuya función es almacenar un carácter.

~~~
    char byte;
~~~

La siguiente variable es `fd`, que es una abreviación de *file descriptor*.
Como ya hemos dicho, los dispositivos se modelan como archivos. El primer paso
es utilizar la llamada a sistema
[`open`(2)](https://www.venea.net/man/es/open(2)) para abrir el dispositivo `ttyUSB0`.

~~~
    int fd = open("/dev/ttyUSB0", O_RDONLY);
~~~

El archivo se abrirá para sólo lectura, lo cual se especifica por el parámetro `O_RDONLY`.

Después iniciamos un ciclo infinito por medio de la instrucción `while`.

~~~
    while(1) {
~~~

El primer paso dentro del ciclo es leer un carácter del puerto serie, lo cual
hacemos por medio de la llamada a sistema
[`read`(2)](https://www.venea.net/man/es/read(2)).

~~~
        read(fd, &byte, 1);
~~~

El primer parámetro de la llamada a sistema es el descriptor de archivo
correspondiente al dispositivo. El segundo parámetro es la dirección de memoria
de la variable `byte`. Para obtener la dirección de memoria utilizamos el
declarador `&`. El último parámetro es la cantidad de caracteres que se leen, en
este caso 1.

El segundo paso dentro del ciclo es escribir el carácter en la salida estándar, lo cual
hacemos por medio de la llamada a sistema
[`write`(2)](https://www.venea.net/man/es/write(2)).

~~~
        write(STDOUT_FILENO, &byte, 1);
    }
~~~

El primer parámetro de la llamada a sistema es el descriptor de archivo
correspondiente a la salida estándar, `STDOUT_FILENO`. La salida estándar
corresponde al monitor. Este descriptor está abierto por default.

El segundo parámetro es la dirección de memoria de la variable `byte`. El último
parámetro es la cantidad de caracteres que se escriben, en este caso 1.

Como el programa está en un ciclo infinito, nunca se cerrará el archivo
correspondiente al puerto serial. Sin embargo, se incluye el código para ello.

~~~
    close(fd); // No se usa.
~~~

Y finalmente, terminamos la función.

~~~
    return 0;
}
~~~

## Compilación y ejecución

Para compilar el programa en la Raspberry Pi, primero se utilizará la
instrucción

~~~
gcc serial.c -o serial
~~~

Luego, se ejecutará el programa con la instrucción

~~~
./serial
~~~

## Para saber más

En el siguiente video podemos ver otros aspectos de la comunicación serial entre
una Raspberry Pi y una Arduino.

<iframe width="560" height="315" src="https://www.youtube.com/embed/nh5geiIDqjA" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Conclusiones

El objetivo de la presente actividad fue implementar la comunicación entre
una Raspberry Pi y una Arduino para enviar un mensaje por medio de la interfaz
USB.

Primeramente, programamos la Arduino en el lenguaje Wiring para enviar un
mensaje. Después, vimos cómo se ajustan los parámetros de comunicación de la
Raspberry Pi. Finalmente, programamos la Raspberry Pi para recibir el mensaje
enviado por la Arduino.
