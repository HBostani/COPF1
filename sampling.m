% MATLAB code for coreset-based Optimum-path Forest
% Reference: H. Bostani, M. Sheikhan, B. Mahboobi, “Developing a Fast Supervised Optimum-path Forest Based on Coreset,”
%            In Proc. 19th International Symposium on Artificial Intelligence and Signal Processing (AISP’2017), 
%            pp. 172-177, 2017. DOI: 10.1109/AISP.2017.8324076
%
% Coded by:  Hamid Bostani (st_h_bostani@azad.ac.ir), 2017.
%
% Purpose: Defining the sampling step of the coreset construction algorithm
%
% Code compatible: MATLAB 2014a and later versions.

function [ output ] = sampling(T,partList)
    sectors=unique(partList);
    for i=1:size(sectors,1)
        index=find( ismember(partList,sectors(i)));   
        [~,id]=max(T(index,5));
        T(index(id),6)=size(index,1);
    end
    output=T;
end

