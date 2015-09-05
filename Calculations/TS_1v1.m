%Ustawienie opcji dla loop shaping-u - wykresy bodego
BO1=bodeoptions;
BO1.MagScale='log';
BO1.MagUnits='abs';

%Ustawienia dla wykresów funkcji wrazliwoœci
BO2=bodeoptions;
BO2.MagScale='linear';
BO2.MagUnits='abs';

%Ustawienie dla wykresów funkcji wra¿liwoœci
BO2=bodeoptions;
BO2.MagUnits='abs';
BO2.MagScale='linear';

%Ustawienie opcji dla wykresów Nyquista
NO=nyquistoptions;
NO.XLim=[-2,0.5];
NO.XLimMode='manual';
NO.Grid='on';
NO.ShowFullContour='off'; %ta opcja nie daje widocznych rezultatów

%Sta³e dane w zadaniu
r1=0.8;         %maksymalna prêdkoœæ sygna³u
r2=1.8;         %maksymalne przyspieszenie sygnalu
epsilon=0.01;   %dok³adnoœæ 

%Sta³e dobierane przez projektanta
Mp=1.3;         %wielkoœc maksymalnego piku rezonasowego
Tp=0.01;        %czas próbkowania
kr=2;           %wzmocnienie regulatora
Vg=30;

%Wprowadzenie transmitancji obiektu G
s=tf('s');
G=100/(s*(0.37*s+1)*(0.074*s+1));
HG=c2d(G,Tp);
HGW=d2c(HG,'tustin');
HGW_lag=HGW*(1-(Tp/2)*s)/(1+(Tp/2)*s);

%Wyzanczenie pulsacji granicznej
[Gm,Pm,Wg,Wp]=margin(HGW);
Wp
Vg_maksymalne=0.44/Tp
V1=Vg*(Mp-1)/Mp
V2=Vg*(Mp+1)/Mp

subplot(2,2,1);
%Wyznaczenie obszaru zabronionego
OMEGA_a=r2/r1;
L_ograniczenie=(1/epsilon)*(r1*r1/r2)*(1.16*4/pi);
obszarzabroniony=(L_ograniczenie*sqrt(2)*OMEGA_a)/(s*(s*(1/OMEGA_a)+1));
bodemag(obszarzabroniony,'r',BO1);
hold;
bodemag(tf(1),'k',BO1);

%Wrysowanie transmistancji obiektu z opóŸnieniem
bodemag(HGW_lag,'b',BO1);

%Wrysowanie transmitancji z regulatorem P (Czy musi to byæ tak zagmatwane)
Gkr=kr*G;
HGkr=c2d(Gkr,Tp);
HGkrW=d2c(HGkr,'tustin');
bodemag(HGkrW,'g',BO1);

%Wyzanczenie transmitancji regulatora
C0=(s/2.70253819668182+1)*(s/13.4929862409832+1)*(s/15+1) /((s/OMEGA_a+1)*(s/200+1)*(s/200+1)); %          

%Wrysowanie charakterystyki z regulatorem
bodemag(HGkrW*C0,'m',BO1);

%Wrysowanie kawa³ka o nachyleniu jeden przechodzacego przez punkt (Vg,1)
bodemag(Vg/s,'c',BO1);

%Wyznaczenie transmitancji regulatora dyskretnego z opóŸnieniem
C=kr*C0;
Cd=c2d(C,Tp,'tustin');
z=tf('z');
Cd_lag=Cd/z;
hold;
%rzeczy testowe
% figure(2);
L=HG*Cd_lag;
% step((L)/(1+L));
S=1/(1+L);
T=L*S;
%wykresy S i T wymagaj¹ skali liniowej i abs
subplot(2,2,2)
nyquist(HG*Cd_lag,NO);
subplot(2,2,3)
bodemag(S,T,BO2);
subplot(2,2,4)
step(L/(1+L));

