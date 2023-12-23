%_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_
% April 28 2020 improved version wich takes into account small oscillations
%_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_

function [NNmax] = FunkNNmax(t,V,thresh)

                      
[Vpeak,NNpeak] = findpeaks(V);
a=find(Vpeak>=thresh);
NNmax=NNpeak(a);



if   isempty(a)==1
     NNmax=zeros;
end     
    
      
end 





