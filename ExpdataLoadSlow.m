% Fast experimental temperature protocol
% Script is written by Natalia Maksymchuk
% Slightly updated from the article titled 
% 'Transient and Steady-State Properties of Drosophila Sensory Neurons
% Coding Noxious Cold Temperature'
% Front. Cell. Neurosci., 25 July 2022
% Sec. Cellular Neurophysiology
% Volume 16 - 2022 | https://doi.org/10.3389/fncel.2022.831803



dataName='SlowTempProt';
TempdataR = load([dataName,'.txt']);
Tempdata(:,1)=TempdataR(:,1)-TempdataR(1,1);
Tempdata(:,2)=TempdataR(:,2);

%% Figure with temperature protocol
colorTem=[255./255. 0./255. 43./255.];
FontSz=16.;
FontName='Arial';
figure; 
hp1=plot(Tempdata(:,1),Tempdata(:,2), 'linewidth',2);
set(hp1, 'color', colorTem, 'linewidth', 2)
ylim([8. 26.]);
ylabel('T, {}^oC')
xlabel('t, s')
set(gca, 'FontSize', 10,'FontWeight', 'bold');
title(dataName)