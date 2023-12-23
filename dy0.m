% Fast experimental temperature protocol
% Script is written by Natalia Maksymchuk
% Slightly updated from the article titled 
% 'Transient and Steady-State Properties of Drosophila Sensory Neurons
% Coding Noxious Cold Temperature'
% Front. Cell. Neurosci., 25 July 2022
% Sec. Cellular Neurophysiology
% Volume 16 - 2022 | https://doi.org/10.3389/fncel.2022.831803


function dy=dy0(t,y,tauNaF,GNaF,GK,GL,...
    ENa,EK,EL,vmNaF,vhNaF,vmK,KmNaF,KhNaF,...
    KmK,Cap,Vol,GBK,CaBK,KmBK,kmBK,VmBK,vmBK,tmBK,nBK,nSK,GSK,tau_aSK,...
   Z, K05, R, F,k,Camin, Caout,GleakTest,kPCa,kPNa,kPK,GCa,vmCa,KmCa,...
    vhCa, KhCa, tmCa, thCa,A,N,w,Th,Cain_half,tau_hLT,T0,tau_mLT)

%        y(1)=V,
%        y(2)=mNaF,
%        y(3)=hNaF,
%        y(4)=mK,
%        y(5)=mBK,
%        y(6)=mCa;
%        y(7)=hCa;
%        y(8)=Cai
%        y(9)=mSK
%        y(10)=hTRP
%        y(11)=mTRP


TC = T0;%Temperature in oC
T=TC+273.15;% Temperature in K

if y(8)<=0.0 
   y(8)=1.e-15;
end

%% Temperature-dependend scaling factors
ro=1.3^((T-298.15)/10.);
fi=3.0^((T-298.15)/10.);

ECa = 1000.*R*T/(Z*F)*log(Caout/y(8));
I_Ca=ro*GCa*y(6)*y(7)*(y(1)-ECa); 
fCaBK=1/(1+(CaBK/y(8))^nBK); 
I_BK=ro*GBK*fCaBK*y(5)*y(5)*y(5)*y(5)*(y(1)-EK);
mSKinf=1/((K05/y(8))^nSK+1);
I_SK=ro*GSK*y(9)*(y(1)-EK); 
I_NaF=ro*GNaF*y(2)*y(2)*y(2)*y(3)*(y(1)-ENa); 
I_K=ro*GK*y(4)*y(4)*y(4)*y(4)*(y(1)-EK);
Ca_LT=kPCa*(y(1)-ECa);
Na_LT=kPNa*(y(1)-ENa);
K_LT=kPK*(y(1)-EK);
I_TRP=GleakTest*y(10)*y(11)*(Ca_LT+Na_LT+K_LT);% test leak channel
I_TRPCa=y(11)*GleakTest*y(10)*(Ca_LT);
I_L=ro*GL*(y(1)-EL);

mBKinf=1/(1+exp(-(y(1)+vmBK)/kmBK));
t_mBK=-0.1502/(1+exp(-(y(1)+VmBK)/KmBK))+tmBK;
 
%%
dy(1,1)=-(I_NaF+I_K+I_BK+I_SK+I_L+I_TRP+I_Ca)/Cap;

%mNaF
dy(2,1)=fi*(minfHB5(KmNaF,vmNaF,y(1))-y(2))/tauNaF;

%hNaF
a1=4.5;
tau_hNa=(a1./cosh((y(1) + vhNaF)./(3.*KhNaF))+0.75)/1000.;% fitted from experimental data Wang 2013
dy(3,1)=fi*(hinfHB5(KhNaF,vhNaF,y(1))-y(3))/tau_hNa;

%mK
       a1 = 5.;
       b1 = 2.;  
       taumKFit = (a1./cosh((y(1) + vmK)./(b1*KmK))+0.75)/1000;
dy(4,1)=fi*(minfHB5(KmK,vmK,y(1))-y(4))/taumKFit;
 
%mBK
dy(5,1)=fi*(mBKinf-y(5))./t_mBK;

%mCa
dy(6,1)=fi*(minfHB5(KmCa,vmCa,y(1))-y(6))/tmCa;

%hCa
dy(7,1)=fi*(hinfHB5(KhCa,vhCa,y(1))-y(7))/thCa;

%Cain
dy(8,1)=-(I_TRPCa+I_Ca)/(F*Z*Vol)-k*(y(8)-Camin);

%mSK 
dy(9,1)=fi*(mSKinf-y(9))/tau_aSK;

%inactivation of TRP
hTRP=1.-y(8)^N/(Cain_half^N+y(8)^N);
dy(10,1)=(hTRP-y(10))/tau_hLT;

%activation of TRP
mTRP=w+1../(1.+exp(-A*(Th-T)));
dy(11,1)=(mTRP-y(11))/tau_mLT;
  

 
 

