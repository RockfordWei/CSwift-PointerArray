#include "CSwift.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
void berIter(BER ** ber, char * buf) {
  int pipes[2] = {0, 0};
  pipe(pipes);
  FILE * fo = fdopen(pipes[1], "w");

  for(int i = 0; ber[i] != 0; i++) {
    fprintf(fo, "%d#(%d)->%s;\n", i, ber[i]->bv_len, ber[i]->bv_val);
  }//next i
  fclose(fo);
  read(pipes[0], buf, 1024);
  close(pipes[0]);
}//next i,

void modIter(LDAPMod ** mod, char * buf) {
  int pipes[2] = {0, 0};
  pipe(pipes);
  FILE * fo = fdopen(pipes[1], "w");
  char * buffer = malloc(1024);

  for(int i = 0; mod[i] != 0; i++) {
    LDAPMod * m = mod[i];
    fprintf(fo, "%d#\t%s:\n", m->mod_op, m->mod_type);
    memset(buffer, 0, 1024);
    berIter(m->modv_bvals, buffer);
    fprintf(fo, "%s\n", buffer);
  }//next
  free(buffer);
  fclose(fo);
  read(pipes[0], buf, 4096);
  close(pipes[0]);
}
int selfTest(char * buf) {
  BER b1 = {5, "12345"};
  BER b2 = {6, "123456"};
  BER b3 = {4, "abcd"};
  BER b4 = {3, "ABC"};
  PBER bx[3] = {&b1, &b2, 0};
  PBER by[3] = {&b3, &b4, 0};
  LDAPMod m0 = {1, "hello", bx};
  LDAPMod m1 = {2, "world", by};
  LDAPMod * m[3] = {&m0, &m1, 0};
  modIter(m, buf);
  return 0;
}
