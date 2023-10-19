% -------------------------------------------------------------------------
% This code is used to read the data from the text file,
% and generate the saliency map, heat map for ASD children and TD children.
% Eye tracker: Tobii Eye Tracker 5C
% -------------------------------------------------------------------------
clc
clear all

PathASD = 'C:\test\data\slmd\';
fsd=50;%首次扫视时间的距离，像素
results=zeros(25,6);
goundx=[1073,1588,1589,1491,674,1489,971,505,1588,1680,754,823,1435,1738,322,1491,425,1588,1681,673,1588,842,1681,272,398];
goundy=[200,388,803,490,745,596,836,338,468,723,182,880,596,596,219,724,691,725,469,504,594,320,595,555,881];
kbj=[ 14 9 23]';

for iii=1:size(kbj)
results(kbj(iii),6)=1;
end

for cnt = 1:25
    timetemp=0; 
    shouci=0;
    timetemp1=0;
    lastscancnt=0;
    ctemp=0;
       
    DataASD = importdata([PathASD,'data',num2str(cnt),'.txt']);
    dataASD = DataASD;
    X_ASD = dataASD(:,1);
    Y_ASD = dataASD(:,2);
    T_ASD = dataASD(:,3);
    
    for cntFixPts = 2:size(dataASD,1)
        
        yy=max(min(floor((Y_ASD(cntFixPts))*1080),1080),1);
        xx=max(min(floor((X_ASD(cntFixPts))*1920),1920),1);
        pyy=max(min(floor((Y_ASD(cntFixPts-1))*1080),1080),1);
        pxx=max(min(floor((X_ASD(cntFixPts-1))*1920),1920),1);
        
        if ((pxx-xx)*(pxx-xx)+(pyy-yy)*(pyy-yy)>=fsd*fsd)
            if(timetemp1==0)
            ctemp=cntFixPts-1;
            timetemp1=1;
            end
        end
        
        if ((pxx-xx)*(pxx-xx)+(pyy-yy)*(pyy-yy)>=fsd*fsd)
            
            if(timetemp==0)%首次判定为扫视
                shouci=1;
             %1.判定首次扫视时的时间，如没有看到会迟疑
            results(cnt,1)=T_ASD(cntFixPts);%标记
            theta1=getan(xx-pxx,yy-pyy);
            %2.判定首次扫视角度与正确角度的差值
            thetacha=getan(goundx(cnt)-960,goundy(cnt)-550)-getan(xx-pxx,yy-pyy);
            results(cnt,2)=min(mod(thetacha,2*pi),mod(2*pi-thetacha,2*pi));%标记
            timetemp=1;
            end
            
            theta2=getan(xx-pxx,yy-pyy);
            if((lastscancnt~=0&&lastscancnt<cntFixPts-3)||min(mod(theta1-theta2,2*pi),mod(2*pi-theta1-theta2,2*pi))>=3.14/4)%3.突然改变方向或者出现第二次扫视
                 results(cnt,3)=results(cnt,3)+1;%标记改变次数
                  theta2= theta1;
            end
            
        lastscancnt=cntFixPts;
        end   
        
        if ((pxx-xx)*(pxx-xx)+(pyy-yy)*(pyy-yy)<fsd*fsd&&shouci~=0)%5.第一次扫视结束之后，还距离多少像素
            results(cnt,5)=sqrt((goundx(cnt)-xx)*(goundx(cnt)-xx)+(goundy(cnt)-yy)*(goundy(cnt)-yy));%标记
            shouci=0;
        end
        
    end
    
    for i = 2:ctemp
        for ii = 1:i
            yy=max(min(floor((Y_ASD(i))*1080),1080),1);
        xx=max(min(floor((X_ASD(i))*1920),1920),1);
        pyy=max(min(floor((Y_ASD(ii))*1080),1080),1);
        pxx=max(min(floor((X_ASD(ii))*1920),1920),1);%4.第一次扫视之前，注视范围最大距离
            results(cnt,4)=max(results(cnt,4),sqrt((pxx-xx)*(pxx-xx)+(pyy-yy)*(pyy-yy)));%标记最大的初始距离
        end
    end
end
%
