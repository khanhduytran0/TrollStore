#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char **argv) {
    setuid(0);
    setgid(0);
    
    // fake sudo is expected to be copied to a temporary location, remove it on exit
    remove("/private/preboot/Cryptexes/sudo");
    
    return execv(argv[1], &argv[1]);
}
