% -------------------------------------------------------------------------
% This code is used to read the data from the text file,
% and generate the saliency map, heat map for ASD children and TD children.
% Eye tracker: Tobii Eye Tracker 5C
% -------------------------------------------------------------------------
clc
clear all

PathASD = 'C:\Users\小吴医森\Desktop\1\ywy\';
PathImage = 'C:\Users\小吴医森\Desktop\2\';
PathFixPtsASD = 'C:\test\pic\tjy\1\';
PathFixMapsASD = 'C:\test\pic\tjy\2\';
PathHeatMapsASD = 'C:\Users\小吴医森\Desktop\4\';

FileFolder = fullfile(PathImage);
Files = dir(fullfile(PathImage));
out=zeros(60,3);

ttimtemp=1;
for cnt =1:60
    qjzylgd=[1920,1080,0,0];
    timtemp=1;    
    dataASD = importdata([PathASD,num2str(cnt),'.txt']);
    Img = imread([PathImage,num2str(cnt),'.png']);
     %   imshow(Img);
    %hold on;
    %% ASD
    % fixation map initialization

    X_ASD = dataASD(:,1);
    Y_ASD = dataASD(:,2);
    T_ASD = dataASD(:,3);
    num=0;
    numm=1;
    tempt=0;
    oxx=-1;
    oyy=-1;
    oxxx=[-1];
    oyyy=[-1];

temp=0;
    for cntFixPts = 2:size(dataASD,1)
        if(cntFixPts==size(dataASD,1) &&temp==1)
        temp=0;
       
        end
        if(Y_ASD(cntFixPts)>=1||Y_ASD(cntFixPts)<=0||X_ASD(cntFixPts)>=1||X_ASD(cntFixPts)<=0)
            continue;
        end
        yyy=floor(Y_ASD(cntFixPts)*1080);
        xxx=floor(X_ASD(cntFixPts)*1920);
        yyy1=floor(Y_ASD(cntFixPts-1)*1080);
        xxx1=floor(X_ASD(cntFixPts-1)*1920);
         if(Y_ASD(cntFixPts-1)>=1||Y_ASD(cntFixPts-1)<=0||X_ASD(cntFixPts-1)>=1||X_ASD(cntFixPts-1)<=0)
            continue;
        end
        if(abs((yyy-yyy1).^2+(xxx-xxx1).^2)>=2500||cntFixPts == size(dataASD,1))%jvlichang bingque zhushile yiduanshijian
       % rectangle('position',[xxx-50,yyy-50,100,100],'curvature',[1,1],'edgecolor','r');
       if(num>=6)
           ttim(ttimtemp)=num*33;
           ttimtemp=ttimtemp+1;
       tim(cnt,timtemp)=num*33;
       timtemp=timtemp+1;
        Radius=10+10*log(num);
t = 0 : .1 : 2 * pi;
x = Radius * cos(t)+xxx;
y = Radius * sin(t)+yyy;

%patch(x, y, [1,1,0], 'facecolor','cyan', 'facealpha', 0.2)

         text(xxx,yyy,num2str(numm),'horiz','center','color','r')
         out(cnt,1)=numm;
         hang=sum(tim,2);
         out(cnt,2)=hang(cnt)/numm;
         out(cnt,3)=tim(cnt,1);
        if(oxx>-1)
        % line([oxx,xxx],[oyy,yyy],'color','k')
        end
        oxx=xxx;
        oyy=yyy;
        numm=numm+1;
        oxxx(numm-1)=xxx;
         oyyy(numm-1)=yyy;
         
        %hold on;
        num=0;
       end
        else
            qjzylgd(1)=min(qjzylgd(1),xxx);
            qjzylgd(2)=min(qjzylgd(2),yyy);
            qjzylgd(3)=max(qjzylgd(3),xxx);
            qjzylgd(4)=max(qjzylgd(4),yyy);
            if(abs((yyy-yyy1).^2+(xxx-xxx1).^2)<2500)
            num=num+1;
            end
        end
    end
    jbzylsd(1)=sum(ttim)/(ttimtemp-1);
    jbzylsd(2)=std2(ttim);
    jbzylsd(3)=median(ttim);
    qjzylgd(3)=qjzylgd(3)-qjzylgd(1);
    qjzylgd(4)=qjzylgd(4)-qjzylgd(2);
    nnew(cnt,1)=qjzylgd(3);
    nnew(cnt,2)=qjzylgd(4);
   % saveas(gcf,[PathHeatMapsASD,num2str(cnt),'.png']);
    %imwrite(gcf,[PathFixMapsASD,FileName,'.png']);
    clf;
end
anss=[std2(nnew(:,1)),std2(nnew(:,2))]