---
title: Event-driven programming in embedded systems
layout: post
categories: [Embedded Systems]
---

Event-driven programming is a [programming
paradigm](https://en.wikipedia.org/wiki/Programming_paradigm), where
the execution flow is handled by events. Event-driven programming is
mostly used in applications that require response to the outside
world; examples of events include sensor outputs, user actions,
messages from other programs, or computers.

# Events

We define an event as an action that software must react
to. Typically, an event has an external origin and is asynchronous. We
mean by asynchronous, software and events need to interact, but we
don’t when (Rouse, 2019).

Events can be confused with concepts such as exceptions and
interruptions. First, we mean by the term exception the abbreviation
of "exceptional event" (Oracle, 1995). Thus, exceptions are a subset
of events. An event can be expected or unexpected. The movement of a
mouse is an example of an expected event, that mean that we are
expecting that action to happen, but we don’t know when. A division by
zero is an unexpected event, or exception.

There is not consensus if interrupts are or not a subset of
exceptions. Some authors propose that exceptions should come from the
inside of the processor (Chiarulli, 2005). On the other hand, an
interrupt is an unexpected event originated outside the
processor. Some other authors see interrupts as a subset of exceptions
(Arm, 2010).

# Event handling

There are different mechanisms to handle events. There are hardware
mechanisms, operating system mechanisms and programming-language
mechanisms.

At the hardware level, we have interrupts. An interrupt is only an
electrical signal that request the attention of the CPU. If the
request is accepted, the CPU will interrupt the current process and
branch to an [interrupt service
routine](https://techterms.com/definition/isr) or handler. When the
handler completes its execution, the CPU will resume the original
process.

At the operating-system level, we have
[signals](https://en.wikipedia.org/wiki/Signal_(IPC)); A signal is
like an interrupt, but in software. Another mechanism is
[polling](https://en.wikipedia.org/wiki/Polling_(computer_science));
that means that the event is detected by the operating system, but the
handling is executed by a user process; the synchronization between
the operating system and the process is handled by a
[semaphore](https://www.geeksforgeeks.org/semaphores-in-process-synchronization/)
or flag.

At the programming-language level, there are languages such C++ or
Java that have instructions to handle events, such as try/catch/throw.

Finally, when a language doesn’t support directly event handling,
there are
[frameworks](https://en.wikipedia.org/wiki/Software_framework).
Frameworks use [inversion of
control](https://en.wikipedia.org/wiki/Inversion_of_control), through
[callback
functions](https://en.wikipedia.org/wiki/Callback_(computer_programming)). These
functions allow to the programmer to set the required behavior to the
event, without requiring how the event is detected.  Examples are some
engines of JavaScript and MBED.

# Example in MBED

MBED uses inversion of control at several levels. We will show an
example using some of those levels. You will find the code of the
example at the [MBED
repository](https://os.mbed.com/users/ghsalazar/code/mydsc-serial-example/).

This program handles four distinct events through callbacks:

- Reception of a character through the serial port,
- Press of the user button,
- Setting of a variable, and
- Reading of a variable.

The whole idea is to have different reaction of the system without
blocking or interfering each other. This code depends on
[MBED](https://www.mbed.com/en/) and the [mydsc
library](https://os.mbed.com/users/ghsalazar/code/mydsc/).

Firstly, we have two different sources of events, the serial port and
the user button.

```
Serial      serial  (USBTX, USBRX);
InterruptIn button  (USER_BUTTON);
```

In order to communicate with the main process, we will use two
semaphores:

```
volatile bool semaphore_input = false;
volatile bool semaphore_button = false;
```

These semaphores are declared as
[volatile](https://barrgroup.com/embedded-systems/how-to/c-volatile-keyword),
in order to disallow the compiler to optimize the variable
handling. This is because their respective callback or the main
process may change their value.

Because we have four different events, we require four different
callbacks. The first callback will receive a character and will
inserted character in a string. This process will be repeated with
each received character, until the callback receives an end-of-line
character (015, in octal); then the callback changes the value of the
semaphore variable, signaling to the main process to read the whole
line.

```
void on_rx()
{
    static char c;
    static unsigned index = 0;

    c = serial.getc();
    message[index] = c;
    index++;
    message[index] = '\0';
    if ((END_OF_LINE == c) || (MESSAGE_MAX_LEN+1) == index) {
        semaphore_input = true;
        index = 0;
    }
}
```

The main process reacts to the semaphore in the main loop, handling
the character string with help
[strcpy](https://overiq.com/c-programming-101/the-strcpy-function-in-c/),
[strtok](https://www.tutorialspoint.com/c_standard_library/c_function_strtok.htm),
and
[strcmp](https://www.programiz.com/c-programming/library-function/string.h/strcmp)
of the [C standard library for string
handling](https://en.wikipedia.org/wiki/C_string_handling). This is a
very straightforward command interpreter.

```
    while(1) {
        // Loop
		...

        if (semaphore_input == true) {
            semaphore_input = false;
            strcpy(command_buffer, strtok(message," \015"));
            if (strcmp(command_buffer, "set") == 0) {
                strcpy(key_buffer, strtok(NULL," \015"));
                strcpy(value_buffer, strtok(NULL, " \015"));
                result = mydsc_kvp_set_value(&kvp, key_buffer, value_buffer);
                if (result != MYDSC_SUCCESS)
                    serial.printf("\r\nError: %s", mydsc_error[result]);
            }
            else if (strcmp(command_buffer,"get") == 0) {
                strcpy(key_buffer, strtok(NULL," \015"));
                value = mydsc_kvp_get_value(&kvp,key_buffer);
                if (NULL != value)
                    serial.printf("\r\n%s", value);
                else
                    serial.printf("\r\nError: %s", mydsc_error[MYDSC_KVP_NO_KEY]);
            }
                else if (strcmp(command_buffer,"help") == 0) {
                    serial.printf("\r\nAvailable commands are: get help set");
                }
            else
                serial.printf("\r\nError: %s doesn't exist\r\n", command_buffer);
           serial.printf("\r\nOk > ");
        }
		…
   }

```

The second callback defines the reaction to pressing the user
button. It will switch the state of the corresponding semaphore. Also,
it will print a line on the terminal, showing the state of the
semaphore.

```
void on_user_button()
{
    semaphore_button = !semaphore_button;
    serial.printf("\r\n%s\r\nOk > ", (semaphore_button? "Paused": "Running"));
}
```

The semaphore will signal to the main loop to pause or continue the count down.

```
    while(1) {
        // Loop
		...
       if (!semaphore_button)
            delay_count--;
    ...
    }

```

The third callback will be called when the interpreter receives the command “get”, so it sends the value of the variable delay as a string.

```
char* get_delay(void)
{
    static char value[VALUE_SIZE];

    sprintf(value, "%lu", delay);
    return value;
}

```

As for the fourth callback, it will be called when the interpreter
requires change the value of the variable delay.

```
int set_delay(char* value)
{
    sscanf(value, "%lu", &delay);
    return MYDSC_SUCCESS;

}
```

In order to use the callbacks, they must be registered with their
respective frameworks or libraries. The callbacks on_rx() and and
on_user_button() should be registered with their corresponding
instances of the classes Serial and InterruptIn of MBED. On the other
hand, get_delay() and set_delay() are registered with the
key-value-pair library of mydsc.

```
int main()

{

    // Setup

...

    // Setting the callbacks up

    serial.attach(&on_rx, Serial::RxIrq);

    button.fall(&on_user_button);

    mydsc_kvp_append(&kvp, "delay",  &get_delay, &set_delay);

...

}

```

The code of the whole example is showed in the next listing.

```
#include "mbed.h"
#include "stdio.h"
#include "stdlib.h"
#include "string.h"
#include "ctype.h"

#include "mydsc_kvp.h"
#include "mydsc_error.h"

// Hardware Interface
DigitalOut  led     (LED1);
Serial      serial  (USBTX, USBRX);
InterruptIn button  (USER_BUTTON);

// Behavior interface
const unsigned          MESSAGE_MAX_LEN = 126;
const char              END_OF_LINE     = 015;
const unsigned          VALUE_SIZE      = 128;
const unsigned short    BUFFER_SIZE     = 128;

unsigned long delay = 5000000UL;
char message[MESSAGE_MAX_LEN+2];

volatile bool semaphore_input = false;
volatile bool semaphore_button = false;

// This set of functions are callbacks
void on_rx()
{
    static char c;
    static unsigned index = 0;

    c = serial.getc();
    message[index] = c;
    index++;
    message[index] = '\0';
    if ((END_OF_LINE == c) || (MESSAGE_MAX_LEN+1) == index) {
        semaphore_input = true;
        index = 0;
    }
}

void on_user_button()
{
    semaphore_button = !semaphore_button;
    serial.printf("\r\n%s\r\nOk > ", (semaphore_button? "Paused": "Running"));
}

char* get_delay(void)
{
    static char value[VALUE_SIZE];

    sprintf(value, "%lu", delay);
    return value;
}

int set_delay(char* value)
{
    sscanf(value, "%lu", &delay);
    return MYDSC_SUCCESS;
}

int main()
{
    // Setup
    static char     command_buffer[BUFFER_SIZE];
    static char     key_buffer[BUFFER_SIZE];
    static char     value_buffer[BUFFER_SIZE];
    long unsigned   delay_count = delay;

    Serial      serial(USBTX, USBRX);
    serial.baud(9600);
    serial.printf("\r\nHello, world!");

    // Setting the key-value list up
    mydsc_kvp_t kvp;
    mydsc_kvp_init(&kvp);

    // Setting the callbacks up
    serial.attach(&on_rx, Serial::RxIrq);
    button.fall(&on_user_button);
    mydsc_kvp_append(&kvp, "delay",  &get_delay, &set_delay);
    serial.printf("\r\nOK > ");

    led = 1;

    while(1) {
        // Loop
        int result = 0;
        char* value = "";

        if (semaphore_input == true) {
            semaphore_input = false;
            strcpy(command_buffer, strtok(message," \015"));
            if (strcmp(command_buffer, "set") == 0) {
                strcpy(key_buffer, strtok(NULL," \015"));
                strcpy(value_buffer, strtok(NULL, " \015"));
                result = mydsc_kvp_set_value(&kvp, key_buffer, value_buffer);
                if (result != MYDSC_SUCCESS)
                    serial.printf("\r\nError: %s", mydsc_error[result]);
            }
            else if (strcmp(command_buffer,"get") == 0) {
                strcpy(key_buffer, strtok(NULL," \015"));
                value = mydsc_kvp_get_value(&kvp,key_buffer);
                if (NULL != value)
                    serial.printf("\r\n%s", value);
                else
                    serial.printf("\r\nError: %s", mydsc_error[MYDSC_KVP_NO_KEY]);
            }
                else if (strcmp(command_buffer,"help") == 0) {
                    serial.printf("\r\nAvailable commands are: get help set");
                }
            else
                serial.printf("\r\nError: %s doesn't exist\r\n", command_buffer);
           serial.printf("\r\nOk > ");
        }
        if (!delay_count) {
            led = !led;
            delay_count = delay;
        }
        if (!semaphore_button)
            delay_count--;
    }
}
```

# References

Arm Limited. (2010). Cortex TM-M4 Devices Generic User
Guide. Retrieved from [http://www.arm.com](http://www.arm.com)

Chiarulli, D. M. (2005). Exceptions and Interrupts for the MIPS
architecture. Retrieved March 25, 2020, from
[http://people.cs.pitt.edu/~don/coe1502/current/Unit4a/Unit4a.html](http://people.cs.pitt.edu/~don/coe1502/current/Unit4a/Unit4a.html)

Oracle. (1995). What Is an Exception?. Retrieved March 25, 2020, from
[https://docs.oracle.com/javase/tutorial/essential/exceptions/definition.html](https://docs.oracle.com/javase/tutorial/essential/exceptions/definition.html)

Rouse, M. (2019). What is Asynchronous and What Does it Mean?
Retrieved March 25, 2020, from
[https://searchnetworking.techtarget.com/definition/asynchronous](https://searchnetworking.techtarget.com/definition/asynchronous)
