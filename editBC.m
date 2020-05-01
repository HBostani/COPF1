% Comparing OPF and Approximated OPF (V1.0).
% Dveploped by Hamid Bostani, 2017.
% "Bostani, H., Sheikhan, M. and Mahboobi, B., 2017, October. Developing a 
% fast supervised optimum-path forest based on coreset. In 2017 Artificial 
% Intelligence and Signal Processing Conference (AISP)(pp. 172-177). IEEE."

function [ output ] = editBC(T,k)
    T(k,5)=T(k,5)+1;
    if(T(k,2)~=T(k,4) && T(k,2)~=0 && T(k,2) ~=-1)    
        editBC(T,T(k,2));    
    end
    output=T;
end

