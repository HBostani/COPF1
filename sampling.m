% Comparing OPF and Approximated OPF (V1.0).
% Dveploped by Hamid Bostani, 2017.
% "Bostani, H., Sheikhan, M. and Mahboobi, B., 2017, October. Developing a 
% fast supervised optimum-path forest based on coreset. In 2017 Artificial 
% Intelligence and Signal Processing Conference (AISP)(pp. 172-177). IEEE."

function [ output ] = sampling(T,partList)
    sectors=unique(partList);
    for i=1:size(sectors,1)
        index=find( ismember(partList,sectors(i)));   
        [~,id]=max(T(index,5));
        T(index(id),6)=size(index,1);
    end
    output=T;
end

