
          
#include <iostream>
#include <stdio.h>
#include <fstream>
#define max_in 1000001
using namespace std;

ifstream infile;
int S,N;
int a[max_in],all=0;
int j=0;
int main(int argc, char **argv){
    infile.open(argv[1]);
    /*number of inputs & hospitals*/
    infile>> S >> N;
    for(j = 0; j<S; j++){
        infile>> a[j];
        all+= a[j];
    }
    infile.close();
    /*cout<<all<<endl; */
    if(all<0 && ((-1.0*all)/(N*S) )>1 )
    {
        printf("%d\n",S);
        return 0;
    }

    double ratio=0;
    int d=0, k= S;
    int f1,f2=S-1, b1 = 0, b2;
    int n = S-1, sb = all, sf = all;
    int sf_c = all, sb_c = all;
    for(int i= 0; i<n; i++){
        b1 = i;
        f2 = n-i;
        if(f2 == b1) break;
        f1=0;
        b2 = n;
        if( f2<f1) break;
        if(i>0){
            k = f2-f1;
            if(k<=d) break;
            sf_c -= a[S-i]; 
            sb_c -= a[i-1];
        }
        sf = sf_c;
        sb = sb_c;

        for(int r=0; r<n; r++){
            k = f2-f1; if(k<=d) break;
            sf = sf- a[f1++];
            sb = sb -a[b2--];

            /*pop front */
            if (sf<0){
                ratio =((-1.0*sf)/(N*k));
                if(ratio>1 && k>d){
                    d = k;
                }
            }
            if(sb==sf) continue;
            /*  pop back */
            if(sb<0){
                ratio = ((-1.0*sb)/(N*k));
                if (ratio>1 && k>d){
                    d = k;
                }
            }
        }
    }
    printf("%d\n",d);
    return 0;
}
        