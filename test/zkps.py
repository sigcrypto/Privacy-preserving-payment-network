from charm.core.math.integer import*
from charm.toolbox.ecgroup import ECGroup,ZR,G

def create_t(group1): ##Bob
    t_i = group1.random(ZR);
    return t_i; ##Creates token ti which is to be given by BoB

def create_A(group1,T_i,g): ## Step 2 Bob creates A##
    G = g;
    t_i = T_i;
    A = G ** t_i;
    return A;

def create_com(group1,g): #Ingrid - verifier
    G = g;
    S = group1.random(ZR);
    #h = group1.randomGen();
    r =group1.random();
    c = (G ** S);##creates commitment c
    return S,c;

def create_y1(group1,R_1,g): ##Bob creates y1 sends to Ingrid
    G = g;
    r1= R_1;
    y1= G**r1;
    return y1;


group1 = ECGroup(694);
g = group1.random(G)## generates g step 0
#print(g)
#Bob =[];
##step 1 : Bob creates a secret ti
ti = create_t(group1);
#Bob.append(ti); ## Adds ti to Bob's list
A = create_A(group1,ti,g); ## step 1
#Bob.append(A);

#Ingrid =[];
#Ingrid.appe                                                             nd(A);
 ## Bob sends A to Ingrid

s,com = create_com(group1,g);
#print("commitment")
#print(com);
#Ingrid.append(s);
#Ingrid.append(com);
#Bob.append(com);
#print(Bob[2])

## r1 and Y1:
r1 = group1.random(ZR);
#Bob.append(r1);
y1 = create_y1(group1,r1,g);
#Bob.append(y1);
#Ingrid.append(y1);
#print(Bob[4]); ##y1
#print(Ingrid[3]); ##y1;
#Bob.append(s);

##Bob des step 6:

z = (ti * s)+r1; ## Bob computes z
print(z);

##Ingrid does step 7:
x = (g ** z); ## Ingrid verifies LHS
print(x)

y= (A ** s) * y1; #Ingrid verifies RHS
print(y)




