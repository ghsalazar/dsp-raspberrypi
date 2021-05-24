## Registros


### Un primer ejemplo en ensamblador

<script src="http://gist-it.appspot.com/https://github.com/ghsalazar/dsp-raspberrypi/raw/main/src/forty-two.s"></script>

~~~{.s name=forty-two.s caption=forty-two.s numbers=left frame=leftline}
.global main
~~~

~~~{.s name=forty-two.s caption=forty-two.s numbers=left frame=leftline}
main:
~~~

~~~{.s name=forty-two.s caption=forty-two.s numbers=left frame=leftline}
    mov r0, #42
    bx lr
~~~

