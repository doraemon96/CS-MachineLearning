#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

int ejercicio_b (char* s, int d, int n, double c);
double dnormal (double v, double sd, float mu);
void generate_normal (int ammount, int class, int d, double sd, int center, FILE *f);
void generate_names(char* name, int d);

/* MAIN
 *  arg1 : d
 *  arg2 : n
 *  arg3 : c
 */
int main(int argc, char **argv){
    ejercicio_b("dat_b.data",atoi(argv[1]),atoi(argv[2]),atof(argv[3]));
    generate_names("dat_b.names",atoi(argv[1]));

    return 0;
}

/* generate_names
 */
void generate_names (char* name, int d)
{
    FILE* f = fopen(name, "w");

    fprintf(f,"0,1.\n");
    int i;
    for(i='a'; i <= 'z' && i < (d+'a'); i++){
        fprintf(f,"%c: continuous.\n", (char)i);
    }
    if(i < (d+'a')){ //Need MOAR
        int j = 'a';
        while((i-'a')+(j-'a') < d){
            fprintf(f,"a%c: continuous.\n", (char)j);
            j++;
        }
    }
}

/* ejercicio_b
 */
int ejercicio_b (char* s, int d, int n, double c)
{
    FILE *f = fopen(s,"w");
    if (f == NULL) {printf("ERROR OPENING FILE\n"); exit(1);}

    time_t t;
    srand48((long int) time(&t));

    double sd = c;
    int ammount = (int) (n/2);

#ifdef DEBUG
    printf("Standard Deviation:%f\n", sd);
#endif
    //for R
    //fprintf(f,"x, y, z, w, c\n");
    generate_normal(ammount, 1, d, sd, 1, f);
    generate_normal(ammount, 0, d, sd, -1, f);

    return 0;
}

/* generate_normal
 */
void generate_normal (int ammount, int class, int d, double sd, int center, FILE *f)
{
    int n_center;
    int i,j;
    for(i=0; i<ammount; i++){
        n_center = center;
        for(j=0; j<d;){
            if(j != 0){
                n_center = 0;
            }
            //random in [center-5*sd, center+5*sd]
            double rnum = (drand48() * 10 * sd) - (5 * sd) + n_center;
            double fval = dnormal(rnum,sd,(float)n_center);
            //method of rejection
            double rnum2 = drand48() * (1.0/(sqrt(2.0*M_PI)*sd));
            if (rnum2 <= fval) {
                fprintf(f, "%f,", rnum);
                j++;
            }
        }
        fprintf(f, "%d\n", class);
    }
}

/* dnormal
 *  Input:
 *   v  <- value
 *   sd <- standard deviation
 *   mu <- center
 *  Output:
 *   double
 */
double dnormal (double v, double sd, float mu)
{
    double coef = 1.0/(sd * sqrt(2*M_PI));
    double expf = -(v-mu)*(v-mu) / (2*sd*sd);
    return (coef * exp(expf));
}
