% Comparing OPF and Approximated OPF (V1.0).
% Dveploped by Hamid Bostani, 2017.
% "Bostani, H., Sheikhan, M. and Mahboobi, B., 2017, October. Developing a 
% fast supervised optimum-path forest based on coreset. In 2017 Artificial 
% Intelligence and Signal Processing Conference (AISP)(pp. 172-177). IEEE."    

function [MST] = creatMST(Z1,F)   
    AdjacencyMatrix=pdist(Z1(:,F));
    G=squareform(AdjacencyMatrix);
    DG=sparse(G);
    [Tree, ~] = graphminspantree(DG);
    MST=Tree;
end

