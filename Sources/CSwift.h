typedef struct berval {
  int bv_len;
  char * bv_val;
} BER;

typedef BER * PBER;

typedef struct ldapmod{
  int mod_op;
  char * mod_type;
  struct berval **modv_bvals;
}LDAPMod;

extern void modIter(LDAPMod ** mod, char * buf) ;
extern void berIter(struct berval ** ber, char * buf);
extern int selfTest(char * buf);
