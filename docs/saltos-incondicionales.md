---
title:  Saltos incondicionales en ensamblador para la Raspberry Pi 
author: Gastón H. Salazar-Silva
categories: [raspberry pi, lenguaje ensamblador, arm, procesador digital de señales]
...

En lenguaje de máquina, los saltos incondicionales se utilizan para transferir
el control de flujo de una dirección a otra. En lenguajes de programación, tal
como C, se utiliza la instrucción `goto` para tal finalidad.

En lenguajes de alto nivel, usualmente se desalienta el uso de los saltos
incondicionales; sin embargo, en lenguaje de máquina esto no es posible.

Para el salto incondicional en los procesadores Arm, se utiliza el mnemónico 
`b`. Al ejecutarse esta instrucción, se carga una dirección en el registro `R15`
del procesador.

