from collections import deque
import sys
#================     READ FILE   ===============
infile = open(sys.argv[1], 'r')
with open(sys.argv[1], "rt") as inputFile:
    inputs = inputFile.read().split('\n')
N = int(inputs[0])
myq =tuple(map(int,inputs[1].split()))
#===============================================

    #=====all the moves now done =====================
for i in range(N-1):  #O(n)
    if(myq[i]> myq[i+1]):
        flag = 0
        break #unsorted
    else:
        flag= 1
if flag==1:
    print('empty')
    exit()

# state is defined by current queue & stack
def Qmove(state):
    Qin, Sin = state
    if(Qin): #Q move
        qQ = Qin[1:]           #pop the first element of Q keep the rest
        sS = (Qin[0], ) + Sin  #add the first element of Q to S
        return (qQ, sS)
    else:
        return state


def Smove(state):
    #print(state)
    Qin, Sin = state
    #........now make the move 'S'
    if(Sin):
            sS = Sin[1:]
            qQ = Qin + (Sin[0],)
            return(qQ, sS)
    else:
        return state

init = (myq,tuple())
visited = {init: None}
moves = ['Q','S']

#Q holds the states we want to explore
Q= deque([(myq, tuple())])
s = []

while(Q):
    state = Q.popleft()
    #print(state)                       #while the are states to explore paths from


    t = Qmove(state)
    if t not in visited:
        Q.append(t)
        visited[t] = ('Q', state)

    t = Smove(state)
    if t not in visited:
        Q.append(t)
        visited[t] = ('S', state)

    if not t[1]:                      #empty stack!
    #=====all the moves now done =====================
        for i in range(N-1):  #O(n)
            if(t[0][i]> t[0][i+1]):
                flag = 0
                break #unsorted
            else:
                flag= 1

        if flag ==1 :                   #solution found!
            word=[]
            len = 0
            while True:
                if(visited[t]==None):
                    break
                word+=visited[t][0]
                prev = visited[t][1]             #previous state
                t = prev
                len+=1

            w = ""
            for i in range(len):
                w +=word[len-i-1]
            print(w)
            exit()
