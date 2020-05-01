% Comparing OPF and Approximated OPF (V1.0).
% Dveploped by Hamid Bostani, 2017.
% "Bostani, H., Sheikhan, M. and Mahboobi, B., 2017, October. Developing a 
% fast supervised optimum-path forest based on coreset. In 2017 Artificial 
% Intelligence and Signal Processing Conference (AISP)(pp. 172-177). IEEE."

function [ T,TOrdered ] = training(T,Z1, prototypes,features)
    n=size(Z1,1);
    TOrdered=zeros(n,7);
    m=size(prototypes,2);
    Q=[];%S is protypes where each row corresponds to a class description where dim1,dim2,dim3, dim4 and dim5 are instance number (node No),cost,parent, label and root, respetively
    prototypesTemp=prototypes';
    Q=[prototypesTemp(:,1),zeros(size(prototypesTemp,1),1),zeros(size(prototypesTemp,1),1),prototypesTemp(:,2),prototypesTemp(:,1)];
    T(prototypesTemp(:,1),1)=0;
    T(prototypesTemp(:,1),3)=prototypesTemp(:,2);
    T(prototypesTemp(:,1),4)=prototypesTemp(:,1);
    temp=find(T(:,1)~=100000 & T(:,1) ~= 0);
    q=[temp,T(temp,1),T(temp,2),T(temp,3),T(temp,4)];
    Q=[Q;q];
    n1=[1:n]';
    temp1=setdiff(n1,temp);
    while size(Q,1)>0
        [node,cost,parent,label,root,Q]=queueRemove(Q);
        s=[node,cost,parent,label,root];  
        for k1=1:size(temp1,1)       
            k=temp1(k1);
            if k ~= s(1) && T(k,1)>s(2)
                cst=max(s(2),pdist([Z1(s(1),features);Z1(k,features)]));           
                if cst<T(k,1)               
                    if T(k,1) ~=100000
                        Q(Q(:,1)==k,:)=[];
                    end               
                    T(k,:)=[cst,s(1),s(4),s(5),T(k,5),T(k,6),T(k,7)];             
                    T=editBC(T,k);
                    [Q] = queueAdd(Q,[k,T(k,1),T(k,2),T(k,3),T(k,4)]);
                end
            end
        end
    end
end

