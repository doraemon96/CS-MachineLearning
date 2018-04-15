#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>


int double_spiral (int n);
int curve_check (float x, float y);
float curve1(float t);
float curve2(float t);
void to_polar (float x, float y, float *r, float *t);

/*MAIN*/
int main(int argc, char **argv){
    double_spiral(atoi(argv[1]));
    FILE* f = fopen("dat_c.names","w");
    fprintf(f, "0,1.\nx: continuous.\ny: continuous.");
}

int double_spiral (int n)
{
    time_t t;
    srand48((long int) time(&t));

    FILE *f = fopen("dat_c.data","w");
    if (f == NULL) {printf("ERROR OPENING FILE\n"); exit(1);}

    //for R
    //fprintf(f,"x, y, c\n");

    int ammount = (int) n/2;
    int ammount_a = 0;
    int ammount_b = 0;

    while(1){
        // Generate coordinates in [-1,1]
        float x = drand48() * 2.0 - 1.0;
        float y = drand48() * 2.0 - 1.0;
        float mod = x*x + y*y;
        if (mod <=1){
            switch(curve_check(x,y)){
                case 0:
                    if(ammount_a <= ammount){
                        fprintf(f,"%f, %f, %d \n", x, y, 0);
                        ammount_a++;
                    }
                    break;
                case 1:
                    if(ammount_b <= ammount){
                        fprintf(f,"%f, %f, %d \n", x, y, 1);
                        ammount_b++;
                    }
                    break;
            }
        }
        if((ammount_a + ammount_b) == n){
            break;
        }
    }

    return 0;
}


int curve_check (float x, float y)
{
    float r, t;
    to_polar(x,y,&r,&t);
    float ro1 = curve1(t);
    float ro2 = curve2(t);

    if(ro1 < ro2){
        float cdif = ro2 - ro1;
        if(r < ro1){
            return 0;
        }
        if(r < ro2){
            return 1;
        }
        if(r < ro2 + cdif){
            return 0;
        }
        if(r < ro2 + 2*cdif){
            return 1;
        }
        if(r < ro2 + 3*cdif){
            return 0;
        }
        if(r < ro2 + 4*cdif){
            return 1;
        }
    }
    if(ro1 >= ro2){
        float cdif = ro1 - ro2;
        if(r < ro2){
            return 0;
        }
        if(r < ro1){
            return 1;
        }
        if(r < ro1 + cdif){
            return 0;
        }
        if(r < ro1 + 2*cdif){
            return 1;
        }
        if(r < ro1 + 3*cdif){
            return 0;
        }
        if(r < ro1 + 4*cdif){
            return 1;
        }
    }
}

float curve1(float t)
{
    return (t/(4*M_PI));
}

float curve2(float t)
{
    return ((t+M_PI)/(4*M_PI));
}


void to_polar (float x, float y, float *r, float *t)
{
    *r = sqrt(x*x + y*y);
    *t = atan2(y,x);
}

