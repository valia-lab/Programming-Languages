#include <bits/stdc++.h>
#include <iostream>
#include <stdio.h>
#include <fstream>
#define max_in 1000001
using namespace std;

ifstream infile;
int S,N;
int a[max_in],all=0;
int j=0,d=0;


/* the following algorithm is an adaption of : https://www.geeksforgeeks.org/longest-subarray-having-average-greater-than-or-equal-to-x-set-2/ 
 * descriped in this link
 * The idea is that we transform our problem into the mathematical problem:
 * given an array : find the maximum subarray that satsfies the condition |Sum| /N > M where Sum<0 and 
 * N is the number of elements in the subarray, so as |Sum| /N is the average and M is the number of hospitals
 * we then, transform further our problem into an equivalent one by:
 * substracting of each element the value M and multiplying by (-1) in order finally to solve the problem: find the maximum (j-i) so as:
 * (-a[i] -M) + (-a[i+1] -M) + ... + (-a[j]-M) >0
 */
int maxdelta(int ar[], int n)
{
    int delta;
    int i, j;

    int LeftMin[n], RightMax[n];

    LeftMin[0] = ar[0];
    for (i = 1; i < n; ++i){
        LeftMin[i] = min(ar[i], LeftMin[i - 1]);
    }
    RightMax[n - 1] = ar[n - 1];
    /*printf("%s ","RMax []= " );*/
    for (j = n - 2; j >= 0; --j){
        RightMax[j] = max(ar[j], RightMax[j + 1]);
    }
    i = 0, j = 0, delta = 0;
    while (j < n && i < n) {
        if (LeftMin[i] < RightMax[j]) {
            delta = max(delta, j - i);
            j = j + 1; /* try a smaller */
        }
        else
            i = i + 1; /* try a smaller window */
    }

    return delta;
}

void transformarr(int ar[], int n, int x)
{
    for (int i = 0; i < n; i++){
        ar[i] = -1* ar[i] - x;
        //printf("%d ", arr[i]);
    }
}

void sumarray(int ar[], int n)
{
    int s = 0;
    //printf("%s ", "prefix[] = ");
    for (int i = 0; i < n; i++) {
        s += ar[i];
        ar[i] =s;
    }
}

int longestsubarray(int ar[], int n, int x)
{
    transformarr(ar, n, x);
    sumarray(ar, n);

    return maxdelta(ar, n);
}



int main(int argc, char **argv){
    infile.open(argv[1]);
    /*number of inputs & hospitals*/
    infile>> S >> N;
    for(j = 0; j<S; j++){
        infile>> a[j];
        all+= a[j];
    }
    infile.close();
    /* if the whole array is the answer */
    if(all<0 && ((-1.0*all)/(N*S) )>1 )
    {
        printf("%d\n",S);
        return 0;
    }

    int days = longestsubarray(a,S,N);
    printf("%d\n", days);
    return 0;
}
       