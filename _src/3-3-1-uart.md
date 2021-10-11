---
title: UART
...

https://cdn-learn.adafruit.com/downloads/pdf/adafruits-raspberry-pi-lesson-5-using-a-console-cable.pdf
https://www.cyberciti.biz/faq/find-out-linux-serial-ports-with-setserial/
https://www.cmrr.umn.edu/~strupp/serial.html


<serial.c>=
#include <stdio.h>   /* Standard input/output definitions */
#include <string.h>  /* String function definitions */
#include <unistd.h>  /* UNIX standard function definitions */
#include <fcntl.h>   /* File control definitions */
#include <errno.h>   /* Error number definitions */
#include <termios.h> /* POSIX terminal control definitions */


int main(void)
{
    int fd;
    char *buffer;
    int bufferSize;
    int n;

    fd = open("/dev/ttyf1", O_RDWR | O_NOCTTY | O_NDELAY);
    if (fd == -1)
        perror("open_port: Unable to open /dev/ttyf1 - ");
    else
        fcntl(fd, F_SETFL, 0);

    while (1) {
        buffer = "Hello, world!\n";
        bufferSize = strlen(buffer);
        n = write(fd, buffer, bufferSize);
        if (n < 0) {
            buffer = "write() failed!\n";
            bufferSize = strlen(buffer);
            write(STDERR_FILENO, buffer, bufferSize);
        }
    }
}
@