%data from the task
r1 = 1; %maximum speed
r2 = 0.8; %maximum acceleration
epsilon = 0.005; %accuracy

%analysis of the transfer function G
s=tf('s');  %definition of the operator s
G=150/(s*(1.12*s+1)*(0.224*s+1)) %transfer function of object