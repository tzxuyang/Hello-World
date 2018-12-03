clear all;
% [num1, txt1, raw1]=xlsread('Calibration WorkSheet.xlsm','Transmission & Vehicle');
% [num2, txt2, raw2]=xlsread('Calibration WorkSheet.xlsm','Gear Loss');
% fileName={'Par_File_Loss'};

% GearLoss10R80;
% GearLoss6R140;
GearLoss8F35;

NumGear=edgl.gear;


tq_max=0;
for i=1:length(NumGear)
    tq_max=max(tq_max, max(edgl.tq{i}));
end

for i=1:length(NumGear)
    if (tq_max>1000)
        gl.tq{i}=[0	50	100	150	200	300	400	500	600	700	800	900	1000	1200	1400]; %10R140
    elseif (tq_max>650)
        gl.tq{i}=[0	50	100	150	200	250	300	350	400	450	500	550	600	700	800]; %10R80 & 10R60
    elseif (tq_max>500)
        gl.tq{i}=[0	25  50	75  100	125 150	200	250	300	350	400	450	500	550]; %8F57, 8F35, 8F40
    elseif (tq_max>300)
        gl.tq{i}=[0	25  50	75  100	125 150	175 200	225 250	275 300	350	400];
    elseif (tq_max>200)
        gl.tq{i}=[0	10	20	30	40	50	70	90	110	130	150	175	200	220	250];  %8F24
    else
        gl.tq{i}=[0	10	20	30	40	50	60  70	80  90	100	120	140	160 180];
    end
    
    gl.rpm{i}=[0	500	1050	1350	1550	1750	2000	2300	2600	2950	3400	3850	4400	5000	5700	6100	6500];
end
    
for i=1:length(NumGear)
%     tmp=num2(1+(i-1)*21,:);
%     gl.rpm{i}=tmp(~isnan(tmp)); %check
%     clear('tmp');
%     
%     tmp=num2(2+(i-1)*21,:);
%     gl.tq{i}=tmp(~isnan(tmp)); %check
%     clear('tmp');
    
    [gearEffTq, gearEffRPM]=meshgrid(edgl.tq{i}, edgl.rpm{i});
    gearEffLoss=edgl.loss{i}';
    [Xin, Yin]=meshgrid(gl.tq{i}, gl.rpm{i});
    Xin(Xin>max(edgl.tq{i}))=max(edgl.tq{i});
    Xin(Xin<min(edgl.tq{i}))=min(edgl.tq{i});
    Yin(Yin>max(edgl.rpm{i}))=max(edgl.rpm{i});
    Yin(Yin<min(edgl.rpm{i}))=min(edgl.rpm{i});
    gr.loss{i}=(interp2(gearEffTq, gearEffRPM, gearEffLoss,Xin, Yin))';
    
end

for i=1:length(NumGear)
%     xlswrite('Calibration WorkSheet.xlsm',gr.loss{i},'Gear Loss',['B',num2str(5+(i-1)*21)]);
    xlswrite('Par_File_Loss.csv',gr.loss{i},'Gear Loss',['B',num2str(3+(i-1)*17)]);
    xlswrite('Par_File_Loss.csv',gl.rpm{i},'Gear Loss',['B',num2str(1+(i-1)*17)]);
    xlswrite('Par_File_Loss.csv',gl.tq{i},'Gear Loss',['B',num2str(2+(i-1)*17)]);
end