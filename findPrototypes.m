% Comparing OPF and Approximated OPF (V1.0).
% Dveploped by Hamid Bostani, 2017.
% "Bostani, H., Sheikhan, M. and Mahboobi, B., 2017, October. Developing a 
% fast supervised optimum-path forest based on coreset. In 2017 Artificial 
% Intelligence and Signal Processing Conference (AISP)(pp. 172-177). IEEE."

function [Prototypes]=findPrototypes(Z1,MST,LabelIndex)
    [A,B,~] = find(MST);
    c=Z1(A,LabelIndex) ~= Z1(B,LabelIndex);
    a=[A(c)';Z1(A(c),LabelIndex)'];
    b=[B(c)';Z1(B(c),LabelIndex)'];
    Prototypes=[a,b];
    [~,idx]=unique(Prototypes(1,:));
    Prototypes=Prototypes(:,idx');
end
