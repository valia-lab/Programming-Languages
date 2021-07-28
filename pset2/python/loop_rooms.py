import sys
import numpy as np
#======================READ FILE ===============
infile = open(sys.argv[1], 'r')
with open(sys.argv[1], "rt") as inputFile:
        inputs = inputFile.read().split('\n')
#print(inputs)
first = inputs[0].split()
N = int(first[0])
M = int(first[1])
#===============================================

arra = []
#print("N=",N)
#print("M=",M)
for i in range(1,N+1):
    array = []
    for j in range(M):
        array.append(inputs[i][j])
    arra.append(array)
#print("arra=",arra)

for i in range(N):
    for j in range(M):
        if i == 0 and arra[i][j] == 'U':
            arra[i][j] = 'W'
        elif j == 0 and arra[i][j] == 'L':
            arra[i][j] = 'W'
        elif j == M-1 and arra[i][j] =='R':
            arra[i][j] = 'W'
        elif i == N-1 and arra[i][j] == 'D':
            arra[i][j] = 'W'
arr=np.array(array)
inputs = []
inputs=arra

infile.close()

flag=0
traps=0
for i in range(N):
    psize=0
    for j in range(M):
        flag=0
        path=[]
        cur=inputs[i][j]
       # print("cur=",i,j)
        psize=0
        ids=i*M+j
        if cur=='W':
            flag=1
        elif cur=='X':
            flag=1
        if flag==1: continue###############<-
        #print("i am checking ",cur)
        k=i
        l=j

        while True:
            cur_i=k
            cur_j=l
            #print("i am checking ",cur)
            if cur=='U':
                next_c=inputs[k-1][l]
                next_id=(k-1)*M+l
                if next_c=='X' or next_c=='V':
                    flag=1
                else: k=k-1
            if cur=='D':
                next_c=inputs[k+1][l]
                next_id=(k+1)*M+l
                if next_c=='X' or next_c=='V':
                    flag=1
                else: k+=1
            if cur=='L':
                next_c=inputs[k][l-1]
                next_id=k*M+l-1
                if next_c=='X' or next_c=='V':
                    flag=1
                else: l=l-1
            if cur=='R':
                next_c=inputs[k][l+1]
                next_id=k*M+l+1
                if next_c=='X' or next_c=='V':
                    flag=1
                else: l+=1
            if cur=='V' or cur=='X':
                flag=1
            if cur=='W':
                flag=2

            if flag==1:
                path=np.append(path,ids)
                psize+=1
                traps+=psize
                for p in range(psize):
                    a=int(path[p]/M)
                    b=int(path[p]%M)
     #               print("(i,j) =",a,",",b);
                    inputs[a][b] = 'X'
                break #########################<-
            if flag==2:
                for p in range(psize):
                    a=int(path[p]/M)
                    b=int(path[p]%M)
                    inputs[a][b] = 'W'
                break ########################<-
            inputs[cur_i][cur_j]='V'
            psize+=1
            path=np.append(path,ids)
            cur=next_c
            ids = next_id
            flag = 0
print(traps);
