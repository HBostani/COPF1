% Comparing OPF and Approximated OPF (V1.0).
% Dveploped by Hamid Bostani, 2017.
% "Bostani, H., Sheikhan, M. and Mahboobi, B., 2017, October. Developing a 
% fast supervised optimum-path forest based on coreset. In 2017 Artificial 
% Intelligence and Signal Processing Conference (AISP)(pp. 172-177). IEEE."

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

