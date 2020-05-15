% MATLAB code for coreset-based Optimum-path Forest
% Reference: H. Bostani, M. Sheikhan, B. Mahboobi, “Developing a Fast Supervised Optimum-path Forest Based on Coreset,”
%            In Proc. 19th International Symposium on Artificial Intelligence and Signal Processing (AISP’2017), 
%            pp. 172-177, 2017. DOI: 10.1109/AISP.2017.8324076
%
% Coded by:  Hamid Bostani (st_h_bostani@azad.ac.ir), 2017.
%
% Code compatible: MATLAB 2014a and later versions.

function [ output ] = editBC(T,k)
    T(k,5)=T(k,5)+1;
    if(T(k,2)~=T(k,4) && T(k,2)~=0 && T(k,2) ~=-1)    
        editBC(T,T(k,2));    
    end
    output=T;
end

