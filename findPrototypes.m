% MATLAB code for coreset-based Optimum-path Forest
% Reference: H. Bostani, M. Sheikhan, B. Mahboobi, “Developing a Fast Supervised Optimum-path Forest Based on Coreset,”
%            In Proc. 19th International Symposium on Artificial Intelligence and Signal Processing (AISP’2017), 
%            pp. 172-177, 2017. DOI: 10.1109/AISP.2017.8324076
%
% Coded by:  Hamid Bostani (st_h_bostani@azad.ac.ir), 2017.
%
% Purpose: Finding the Prototypes (key nodes) of the input graph derived from the input data set
%          based on Minimum Spanning Tree
%
% Code compatible: MATLAB 2014a and later versions.

function [Prototypes]=findPrototypes(Z1,MST,LabelIndex)
    [A,B,~] = find(MST);
    c=Z1(A,LabelIndex) ~= Z1(B,LabelIndex);
    a=[A(c)';Z1(A(c),LabelIndex)'];
    b=[B(c)';Z1(B(c),LabelIndex)'];
    Prototypes=[a,b];
    [~,idx]=unique(Prototypes(1,:));
    Prototypes=Prototypes(:,idx');
end
