% Comparing OPF and Approximated OPF (V1.0).
% Dveploped by Hamid Bostani, 2017.
% "Bostani, H., Sheikhan, M. and Mahboobi, B., 2017, October. Developing a 
% fast supervised optimum-path forest based on coreset. In 2017 Artificial 
% Intelligence and Signal Processing Conference (AISP)(pp. 172-177). IEEE."

function [ phi,radius ] = cartesian2spherical ( vector,m )
    pVector=vector(:,1:m).^2;
    radius=sqrt(sum(pVector'));
    radius=radius';
    phi=zeros( size(vector,1),m-1);
    phi(:)=1000;
    j=1;
    for i=1:m-2
        idx=i:m;
        phi(:,i)=acos(vector(:,i)./sqrt(sum(pVector(:,idx)')'));
        j=j+1;
    end
    idx=j:m;
    phi(find(vector(:,m)>=0),m-1)=acos(vector(find(vector(:,m)>=0),m-1)./sqrt(sum(pVector(find(vector(:,m)>=0),idx)')'));
    phi(find(vector(:,m)<0),m-1)=2*pi-acos(vector(find(vector(:,m)<0),m-1)./sqrt(sum(pVector(find(vector(:,m)<0),idx)')'));
end

