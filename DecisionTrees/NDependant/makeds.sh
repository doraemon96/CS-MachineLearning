#!/bin/sh

gcc ../../DataGen/ejercicio_a.c -lm
for n in 125 250 500 1000 2000 4000 ; do
    for j in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do 
        ./a.out 2 $n 0.78 ; 
        mv dat_a.data Diag${n}Ds/diag${n}_${j}.data ;
        mv dat_a.names Diag${n}Ds/diag${n}_${j}.names ;
        sleep 1 ;
    done
done
./a.out 2 10000 0.78;
for n in 125 250 500 1000 2000 4000 ; do
    for j in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do 
        cp dat_a.data Diag${n}Ds/diag${n}_${j}.test ;
    done
done

gcc ../../DataGen/ejercicio_b.c -lm
for n in 125 250 500 1000 2000 4000 ; do
    for j in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do 
        ./a.out 2 $n 0.78 ; 
        mv dat_b.data Par${n}Ds/par${n}_${j}.data ;
        mv dat_b.names Par${n}Ds/par${n}_${j}.names ;
        sleep 1 ;
    done
done
./a.out 2 10000 0.78;
for n in 125 250 500 1000 2000 4000 ; do
    for j in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20; do 
        cp dat_b.data Par${n}Ds/par${n}_${j}.test ;
    done
done
