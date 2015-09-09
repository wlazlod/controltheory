% Section 1 Basic analysis

%Data from the task
r1 = 1; %maximum speed
r2 = 0.8; %maximum acceleration
epsilon = 0.005; %accuracy

%Analysis of the object and its discrete accurate transfer function 
s=tf('s');  %definition of the operator s
G=150/(s*(1.12*s+1)*(0.224*s+1)) %transfer function of object
Tp=0.004; %sampling time, smaller than 1/10 of smallest time constant of G
HG=c2d(G,Tp) %spectral transfer function
HGW=d2c(HG,'tustin') %pseudo-transfer function
HGWa=G*(1-0.5*Tp*s) %approximation of pseudo-transfer function

%Bode plot for G, HG, HGW & HGWa
h=bodeplot(HGW, HGWa) 
p=getoptions(h);
p.PhaseMatching='on'; %dealing with phase offset
p.PhaseMatchingFreq=1.97;
p.PhaseMatchingValue=-180;
setoptions(h,p)
hold
bodeplot(G, HG)
hold off;

% Section 2 Regulator
% Calculating  the minimum gain margin, Gm, phase margin, Pm, and associated frequencies Wg and Wp
[Gm,Pm,Wg,Wp]=margin(HGW);
Wp

Vg_max=0.44/Tp %maxiumum value of Vg
Vg = 80 %Smaller than Vg_max

V1=Vg*(Mp-1)/Mp
V2=Vg*(Mp+1)/Mp

