% Comparing OPF and Approximated OPF (V1.0).
% Dveploped by Hamid Bostani, 2017.
% "Bostani, H., Sheikhan, M. and Mahboobi, B., 2017, October. Developing a 
% fast supervised optimum-path forest based on coreset. In 2017 Artificial 
% Intelligence and Signal Processing Conference (AISP)(pp. 172-177). IEEE."

clear;
clc;
No_TrainingSample=500;
alpha_No=20;
radiusSplitNoMain=30;
load('HTRU_2_DS.mat');
P_Set=HTRU_2_DS;
P_Set=unique(P_Set(1:No_TrainingSample,:),'rows');
if size(P_Set,1)<No_TrainingSample
    No_TrainingSample=size(P_Set,1);
end
Features=1:size(P_Set,2)-1;
m=size(Features,2);

%Region: Finding the protoypes
MST=creatMST(P_Set,Features);
Prototypes=findPrototypes(P_Set,MST,9);
Prototypes=Prototypes(:,1:2);
%End region

%Region: Constructing OPF
tic
T=zeros(No_TrainingSample,7);%T is the training instances where dim1,dim2, dim3,dim4,dim5, dim6 and dim7 are cost, parent, label, root, bc, weight and ring index, respectively
T(:,1)=100000;
Z1=P_Set(:,1:8);
[Tr,TOrderedTemp]= training(T,Z1, Prototypes,Features);
Row=1:No_TrainingSample;
Tr=[Row',Tr];
TOrdered=zeros(No_TrainingSample,7);
CostReal=sum(Tr(:,2));
TrainingTime_OPF=toc
%End region

radiusMax=0;
radiusTemp=0;
radius=0;
polarSet=cell(size(Prototypes,2),1);
CoresetNo=zeros(1,alpha_No);
ExcTime=zeros(1,alpha_No);
Epsilon=zeros(1,alpha_No);
disp('******Coreset construction******')
for alpha=1:alpha_No
    %Region: Constructing coreset and approximated OPF
    message=['threshold: ', num2str(alpha)];
    disp(message)    
    tic   
    for p=1:size(Prototypes,2)
        b=P_Set(Prototypes(1,p),1:m);
        a=P_Set(:,1:m);
        P_SetNew=a-b(ones(size(a,1),1),:);
        [theta,rho] = cartesian2spherical(P_SetNew,m);
        polarList=[fliplr(theta),rho];
        polarList(isnan(polarList))=0;        
        [nelements,centers] =hist(polarList(:,8));
        idx=find(nelements>150);
        radius=max(radius,centers((idx(end))));
        radiusTemp=max([polarList(:,end);radiusTemp]);
        if radius > radiusMax
            radiusMax=radius;
            radiusSlice=radius/radiusSplitNoMain;
            radiusItr=0:radiusSlice:radius;
        else
            radius=radiusMax;
        end
        polarSet{p}=polarList;
    end
    radiusSplitNo=radiusSplitNoMain+1;
    radiusItr=[radiusItr,radiusTemp];
    T=zeros(No_TrainingSample,7);%T is the training instances where dim1, dim2, dim3, dim4, dim5, dim6 and dim7 are cost, parent, label, root, bc, weight and ring index, respectively
    T(:,1)=100000;    
    pointsRingIndexMain=[];
    for j=1:radiusSplitNo        
        for p=1:size(Prototypes,2)
            polarList=polarSet{p};
            if(j == radiusSplitNo)
                pointsRingIndex=find((polarList(:,end)>=radiusItr(j) & polarList(:,end)<=radiusItr(j+1)) | polarList(:,end)==0);   % polarList(:,end)==0 term is used for the reason that the subset should include prototype point
            else
                pointsRingIndex=find((polarList(:,end)>=radiusItr(j) & polarList(:,end)<radiusItr(j+1)) | polarList(:,end)==0);
            end          
            pointsRingIndex=sort([setdiff(pointsRingIndex,Prototypes(1,:)');Prototypes(1,p)']);
            p_i=polarList(pointsRingIndex,:);
            polarSetTemp{p,1}=p_i;
            polarSetTemp{p,2}=pointsRingIndex;            
            pointsRingIndexMain=unique([pointsRingIndexMain;pointsRingIndex]);
        end
        pointLastRingIndex=find(j~=1 &  T(:,7)~=0 & T(:,7)<j);       
        pointsRingIndexMain=sort(setdiff(pointsRingIndexMain,pointLastRingIndex));
        pointsRingIndexMainTemp=pointsRingIndexMain;        
        if size(pointsRingIndexMain,1)==0
            continue;
        end
        T(pointsRingIndexMain,7)=j;
        pointsRingIndexMain = unique([find(T(:,1)==0 | T(:,6)~=0);pointsRingIndexMain]);
        [v,idx]=ismember(Prototypes(1,:)',pointsRingIndexMain);
        PrototypesIndex=[idx,Prototypes(2,:)'];
        Z1=P_Set(pointsRingIndexMain,1:m);
        TTemp=T(pointsRingIndexMain,:);
        for p1=1:size(Prototypes,2)
            idxPrototype=find(TTemp(:,4)==Prototypes(1,p1)');
            TTemp(idxPrototype,4)=PrototypesIndex(p1,1);
        end      
        [TTemp,TOrderedTemp]= training(TTemp,Z1, PrototypesIndex',Features);
        rangeAngle=0:pi/2:2*pi;
        bounds=rangeAngle(ones(m-1,1),:)';
        bounds(3,:)=bounds(3,:)+0.0001;% Modifying pi edges of angles
        bounds(5,:)=bounds(5,:)+0.0001;% Modifying 2*pi edges of angles for the theta angle
        result = 1:4;
        b = 1:2;
        for i=1:m-2
            result = combvec(b,result);
        end
        result = fliplr(result');        
        TTempMain=TTemp;
        for p=1:size(PrototypesIndex,1)
            p_i=polarSet{p};            
            p_i_index=find(TTempMain(:,4)==PrototypesIndex(p,1) & TTempMain(:,7) == j);
            if isempty(p_i_index) == 1
                continue;
            end
            [val,idxx] = ismember(PrototypesIndex(:,1),p_i_index);
            if size(find(val~=0),1)>1
                size(find(val~=0),1)
                idxx(val~=0)
            end
            p_i_indexMain=pointsRingIndexMain(p_i_index);
            p_i=p_i(p_i_indexMain,:);
            radiusItrTemp=radiusItr(j+1);
            radiusItr(j+1)=max(p_i(:,8))+0.1;% This is because some rings from other rings can belong to the current OPT
            partList=cell(size(p_i,1),1);
            partList(:)={'0'};
            for i=1:size(result,1)
                row=result(i,:);
                angles=zeros(size(row,2),2);
                indexRow=(0:m-2).*(5*ones(1,m-1));
                angles(:,1)=(bounds(row+indexRow))';
                angles(:,2)=bounds((row+indexRow+1))';       
                lAngles=[angles(:,1)',radiusItr(j)];             
                lAngles=lAngles(ones(size(p_i,1),1),:);                
                if(j ~= radiusSplitNo)
                    uAngles=[angles(:,2)',radiusItr(j+1)];
                else
                    uAngles=[angles(:,2)',radiusItr(j+1)+0.1];
                end               
                uAngles=uAngles(ones(size(p_i,1),1),:);
                cmp=p_i>=lAngles & p_i<uAngles;
                sector=find(sum(cmp')'==m);              
                partList(sector)={strcat(num2str(i),',')};
                if(size(sector,1)>alpha)                   
                    IsLastRing=0;
                    if(j == radiusSplitNo)
                        IsLastRing=1;
                    end
                    call=0;
                    partList=partitioning(p_i, partList,angles,radiusItr(j),radiusItr(j+1),alpha,IsLastRing,m,No_TrainingSample,call+1);
                end             
            end
            TTemp(p_i_index,:)=sampling(TTemp(p_i_index,:),partList);            
            radiusItr(j+1)=radiusItrTemp;        
            TTemp(p_i_index,4)=Prototypes(1,p)';
            TTemp(p_i_index,2)=-1;            
            TTemp(PrototypesIndex(p,1),6)=0;
            idxPrototype=find(TTemp(:,4)==PrototypesIndex(p,1));
            TTemp(idxPrototype,4)=Prototypes(1,p)';
            T(pointsRingIndexMain,:)=TTemp;            
        end       
        T(Prototypes(1,:)',7)=0;
        T(T(:,6)~=0,2)=-1;        
    end
    %Region: Constructing coreset and approximated OPF
    
    %Region: Evaluating OPF and aprroximated OPF
    ExcTime(alpha) = toc;
    CoresetNo(alpha)= size(find(T(:,6)~=0),1);   
    CostCoreset=sum(T(:,1).*T(:,6));   
    Epsilon(alpha)=abs(CostReal-CostCoreset)/CostReal;
    disp(['ExcTime: ',num2str(ExcTime(alpha))])
    disp(['CostCoreset: ',num2str(CoresetNo(alpha))])
    disp(['Epsilon: ',num2str(Epsilon(alpha))])
    disp('~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    %End region
end

%Region: Plotting the results
threshold=1:alpha_No;
subplot(2,1,1);
plot(threshold,ExcTime,'-s')
xlabel('Threshold')
ylabel('Excution Time (s)')
title('Effect of the value of the threshold on the execution time')
grid on
subplot(2,1,2);
plot(threshold,Epsilon,'r-s')
xlabel('Threshold')
ylabel('Approximation Error (%)')
title('Effect of the value of the threshold on the approximation error')
grid on
%End region


