% MATLAB code for coreset-based Optimum-path Forest
% Reference: H. Bostani, M. Sheikhan, B. Mahboobi, “Developing a Fast Supervised Optimum-path Forest Based on Coreset,”
%            In Proc. 19th International Symposium on Artificial Intelligence and Signal Processing (AISP’2017), 
%            pp. 172-177, 2017. DOI: 10.1109/AISP.2017.8324076
%
% Coded by:  Hamid Bostani (st_h_bostani@azad.ac.ir), 2017.
%
% Purpose: Defining the partitioning step of coreset construction algorithm
%
% Code compatible: MATLAB 2014a and later versions.

function [ partList] = partitioning(polarList, partList,anglesTemp,lbRadius,ubRadius,threshold,IsLastRing,m,n,call) 
    bounds=zeros(3,m);
    bounds(:)=1000;
    for d=m:-1:1
    if(d==m)
        rangeRadius=[lbRadius,mean([lbRadius,ubRadius]),ubRadius];
        bounds(:,d)=rangeRadius';
    else
        rangeAngle=[anglesTemp(d,1),mean([anglesTemp(d,1),anglesTemp(d,2)]),anglesTemp(d,2)];
        bounds(:,d)=rangeAngle';
    end           
    end
    bounds(3,1:m-1)=bounds(3,1:m-1)+0.0001;% modify pi edges of angles
    result = 1:2;
    b = 1:2;
    for i=1:m-1
     result = combvec(b,result);          
    end
    result = fliplr(result');
    for i=1:size(result,1)
    row=result(i,:);
    radiusBound=zeros(1,2);   
    angles=zeros(size(row,2),2);    
    indexRow=(0:m-1).*(3*ones(1,m));
    angles(:,1)=(bounds(row+indexRow))';
    angles(:,2)=bounds((row+indexRow+1))';
    lAngles=angles(:,1)';
    lAngles=lAngles(ones(size(polarList,1),1),:);
    if(IsLastRing ~= 1)       
        uAngles=angles(:,2)';
    else
        angles(end,2)=angles(end,2)+0.1;       
        uAngles=angles(:,2)';
    end
    uAngles=uAngles(ones(size(polarList,1),1),:);
    cmp=polarList>=lAngles & polarList<uAngles;
    sector=find(sum(cmp')'==m);  
    if(size(sector,1)>1) 
        size(sector,1);
    end      
    partList(sector)=strcat(partList(sector),strcat(num2str(i),','));              
    if(size(sector,1)>threshold)   
        radiusBound=angles(end,:);
        angles=angles(1:m-1,:);
        partList=partitioning(polarList, partList,angles,radiusBound(1),radiusBound(2),threshold,IsLastRing,m,n,call+1);                   
    end      
    end 
end