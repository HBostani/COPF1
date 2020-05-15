% MATLAB code for coreset-based Optimum-path Forest
% Reference: H. Bostani, M. Sheikhan, B. Mahboobi, “Developing a Fast Supervised Optimum-path Forest Based on Coreset,”
%            In Proc. 19th International Symposium on Artificial Intelligence and Signal Processing (AISP’2017), 
%            pp. 172-177, 2017. DOI: 10.1109/AISP.2017.8324076
%
% Coded by:  Hamid Bostani (st_h_bostani@azad.ac.ir), 2017.
%
% Code compatible: MATLAB 2014a and later versions.

function [node,cost,parent,label,root,QNew] = queueRemove(Q)
    if size(Q,1) > 0
        [~, minIndexCol] = min(Q,[],1);
        node=Q(minIndexCol(2),1);
        cost=Q(minIndexCol(2),2);
        parent=Q(minIndexCol(2),3);
        label=Q(minIndexCol(2),4);
        root=Q(minIndexCol(2),5);
        Q(minIndexCol(2),:)=[];
        QNew=Q;
    else
        node=-1;
        cost=-1;
        parent=-1;
        label=-1;
        root=-1;
        QNew=Q;
    end
end

