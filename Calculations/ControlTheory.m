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
h=bodeplot(HGW, HGWa); 
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
Vg = 80; %Smaller than Vg_max

Mp=1.4;
V1=Vg*(Mp-1)/Mp
V2=Vg*(Mp+1)/Mp

nu1=8; % nu1 < V1
nu2=400; % nu2 > V2

%preparing plot with prohibited area
OMEGA_a=r2/r1;
L_limit1=(1/epsilon)*(r1*r1/r2)*(1.16*4/pi);
L_limit2=(L_limit1*sqrt(2)*OMEGA_a)/(s*(s*(1/OMEGA_a)+1));
figure(2);
hold on;
bodemag(L_limit2,'r');
semilogx([2/Tp 2/Tp],[-150 100],'r', 'DisplayName', 'R_limit');
HGW_lag=HGW*(1-(Tp/2)*s)/(1+(Tp/2)*s); %transfer function "lagged" by 1 tact
bodemag(HGW_lag, 'b');
hold off;

k=3; %gain
nCv=k*conv([1/nu1 1],[1/Wp 1]); %nominator of transfer function of controller
dCv=conv([1/nu2 1],[1/nu2 1]); %denominator of transfer function of controller
CWn=tf(nCv,dCv)
LW=CWn*HGW_lag;

figure(3);
hold on;
bodemag(L_limit2,'r');
semilogx([2/Tp 2/Tp],[-150 100],'r', 'DisplayName', 'R_limit');
bodemag(LW, 'b');
hold off;

%Section 3 Stability, sensitivity function
CWn2=c2d(CWn,Tp,'tustin');
z=tf('z');
CWn2_lag=CWn2/z
L=HG*CWn2_lag;

figure(4);
NO=nyquistoptions;
NO.XLim=[-2,0.5];
NO.XLimMode='manual';
NO.Grid='on';
NO.ShowFullContour='off'; 
nyquist(L,NO);

figure(5);
margin(L)

S=1/(1+L);
T=L*S;

figure(6);
BO=bodeoptions;
BO.MagScale='linear';
BO.MagUnits='abs';
bodemag(S,T,BO);

figure(7);
Q=S*CWn2_lag;
bodemag(Q,BO);

%Section 4 Presentation of results:
figure(8);
step(L/(1+L));
figure(9);
opt = stepDataOptions('StepAmplitude',r1*r1/r2);
step(L/(1+L), opt);
figure(10);
t = 0:0.004:10;
usim = r1*r1/r2*sin(r2/r1*t);
lsim(L/(1+L),usim,t);
figure(11);
utrap = trap(t, r1, r2);
lsim(L/(1+L),utrap,t);
figure(12);
lsim(HG/(1+L),utrap,t);
figure(13);
lsim(1/(1+L),utrap,t);