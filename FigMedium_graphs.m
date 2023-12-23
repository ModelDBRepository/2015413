clear all
close all

FileName='FigMedium';

xlimit=80;
FRlim=21.5;
Calim=4500.;
IFlim=95.;
BinSize=2.;

xstart=-10.;
load(FileName); 

R = 8.3100e-09;
Z=2;
F=9.6485e-05;
GCa=3.5;
      
%% ***************** GRAPHS ****************************
colorWT=[0./255. 127./255. 255./255.];
colorTem=[255./255. 0./255. 43./255.];
FontSz=16.;

t=t1;
V=ymp1(:,1);


Cai=ymp1(:,8);
CaMean=mean(Cai);
Ca=ymp1(:,8);
m_Ca=ymp1(:,6);
h_Ca=ymp1(:,7);
h_GLTest=ymp1(:,10);%hTRP
mTRP=ymp1(:,11);
TK = interp1(TimeS1,TempS1+273.15,t1);% Temperature K which corresponds every voltage point
TC=TK-273.15; %Temperature oC which corresponds every voltage point
ro=1.3.^((TK-25.)/10.);


L=log(Caout./Ca);
ECa=1000.*R*TK/(Z*F).*L;
        Ca_LT=kPCa*(V-ECa);
        Na_LT=kPNa*(V-ENa);
        K_LT=kPK*(V-EK);
       
G_LTest=mTRP.*h_GLTest*GleakTest;        
I_Test=mTRP.*h_GLTest*GleakTest.*(Ca_LT+Na_LT+K_LT);
G_Ca=m_Ca.*h_Ca*GCa;


%********* %for finding instantaneous spike requency *********************** 
    spikeNN=FunkNNmax(t,V,thresh);
    if spikeNN>0
    spikeTime=t(spikeNN);
    ISI=t(spikeNN(2:end))-t(spikeNN(1:end-1));    
    Frequency=1./ISI;
    MF=mean(Frequency);
    else
        MF=0;
    end  
    
     

if spikeNN>0
tlim=t(end);        
                    
            NBin=floor(t(end)/BinSize);
            NP=floor(BinSize/(t(2)-t(1))); %number of points in binsize 
             
                    for i=1:NBin
                     ttt(i)=(i-1)*BinSize;
                     FRbin(i)=length((find(spikeTime>(i-1)*BinSize&spikeTime<=i*BinSize)))/BinSize;
                     G_LTestBins(i)=mean(G_LTest((1+(i-1)*NP):i*NP));                    
                    end                 


  %% **************** Temperature, intracellular Ca2+ conc., acivation and inactivation variables, firing rate*******************    
                figure
                set(gcf,'Position',[100 0 700 800])
                subplot(6,1,1)
                plot(TimeS1-tonset,TempS1,'color',colorTem,'linewidth',3.);
                set(gca,'Ycolor',[0 0 0],'linewidth', 1, 'FontWeight','bold','fontsize',16,'FontName', 'Aparajita')
                set(gca,'box','off')
                set(gca,'xticklabel',[])
                ylim([8 25]);
                xlim([xstart xlimit]);
                ylabel('Temp ({}^oC)');
                
                        subplot(6,1,2)       
                        hp2=plot(t-tonset,Cai);
                        set(hp2, 'color',[230./255. 66./255. 245./255.], 'linewidth', 0.1)
                        set(gca,'box','off')
                        set(gca,'xticklabel',[])
                        xlim([xstart xlimit]);
                        ylim([0 Calim]);
                        ylabel('Ca_i (nM)')
                        set(gca,'linewidth', 1, 'FontWeight','bold','fontsize',FontSz);
                                            
                    subplot(6,1,3)
                    plot(t-tonset,mTRP,'-','color',[5/255 180/255 250/255],'linewidth',3);
                    set(gca,'Ycolor',[0 0 0],'linewidth', 1, 'FontWeight','bold','fontsize',16);
                    set(gca,'box','off')
                    set(gca,'xticklabel',[])
                    xlim([xstart xlimit]);
                    hold on
                    plot(t-tonset,h_GLTest,'-.','color',[58/255 227/255 11/255],'linewidth',3);
                    ylabel('m_T_R_P/h_T_R_P');
                    legend('m_T_R_P', 'h_T_R_P')
                    legend boxoff

                subplot(6,1,4)
                plot(t-tonset,G_LTest,'-','color',[0. 0. 0.],'LineWidth',3)
                set(gca,'Ycolor',[0 0 0],'linewidth', 1, 'FontWeight','bold','fontsize',16);
                set(gca,'box','off')
                set(gca,'xticklabel',[])
                ylim([0 1]);
                xlim([xstart xlimit]);
                ylabel('G_T_R_P (nS)');
    
                            subplot(6,1,5)
                            plot(t-tonset,V,'color',[0./255. 90./255. 255./255.],'linewidth',0.01);
                            set(gca,'Ycolor',[0 0 0],'linewidth', 1, 'FontWeight','bold','fontsize',16);
                            set(gca,'box','off')
                            set(gca,'xticklabel',[])
                            xlim([xstart xlimit]);
                            ylabel('V_m (mV)');                 
                         
            subplot(6,1,6)           
            h=plot(ttt-tonset+0.5*BinSize,FRbin,'.','MarkerSize',16,'Color',[0./255. 90./255. 255./255.]);% time of fr corresponds to the center ot the bin
            ylabel('F (spikes/s)');
            xlim([xstart xlimit]);
            ylim([0 FRlim]);
            set(gca,'Box', 'off');
            set(gca,'LineWidth',1,'Color',[1 1 1]);
            set(gca,'YColor',[0 0 0]','fontsize',16,'FontWeight','bold','FontName', 'Aparajita');%'FontWeight','bold' for poster
            set(gca,'XColor',[0 0 0]','fontsize',16,'FontWeight','bold','FontName', 'Aparajita');
            xlabel('Time (s)');
            

else 
    disp('There is no spiking activity');   
end
 



            
            





    


