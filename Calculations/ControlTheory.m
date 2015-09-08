%data from the task
r1 = 1; %maximum speed
r2 = 0.8; %maximum acceleration
epsilon = 0.005; %accuracy

%analysis of the object and its discrete accurate transfer function 

s=tf('s');  %definition of the operator s
G=150/(s*(1.12*s+1)*(0.224*s+1)) %transfer function of object
Tp=0.01; %sampling time, smaller than 1/10 of smallest time constant of G
HG=c2d(G,Tp) %spectral transfer function
HGW=d2c(HG,'tustin') %pseudo-transfer function
HGWa=G*(1-0.5*Tp*s) %approximation of pseudo-transfer function

%Bode plot for G, HG, HGW & HGWa
