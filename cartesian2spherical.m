% MATLAB code for coreset-based Optimum-path Forest
% Reference: H. Bostani, M. Sheikhan, B. Mahboobi, “Developing a Fast Supervised Optimum-path Forest Based on Coreset,”
%            In Proc. 19th International Symposium on Artificial Intelligence and Signal Processing (AISP’2017), 
%            pp. 172-177, 2017. DOI: 10.1109/AISP.2017.8324076
%
% Coded by:  Hamid Bostani (st_h_bostani@azad.ac.ir), 2017.
%
% Code compatible: MATLAB 2014a and later versions.

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

