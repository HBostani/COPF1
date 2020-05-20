% MATLAB code for coreset-based Optimum-path Forest
% Reference: H. Bostani, M. Sheikhan, B. Mahboobi, “Developing a Fast Supervised Optimum-path Forest Based on Coreset,”
%            In Proc. 19th International Symposium on Artificial Intelligence and Signal Processing (AISP’2017), 
%            pp. 172-177, 2017. DOI: 10.1109/AISP.2017.8324076
%
% Coded by:  Hamid Bostani (st_h_bostani@azad.ac.ir), 2017.
%
% Purpose: Finding the Minimum Spanning Tree of the input derived graph used the prototypes selection
% 
% Code compatible: MATLAB 2014a and later versions.

function [MST] = creatMST(Z1,F)   
    AdjacencyMatrix=pdist(Z1(:,F));
    G=squareform(AdjacencyMatrix);
    DG=sparse(G);
    [Tree, ~] = graphminspantree(DG);
    MST=Tree;
end

