load('rodentall3YEARpernew.mat'); %108obs
load('./res/matlab09236.mat');%results and parameter of model
theta=results2.mean;
xdata=data.xdata;
t=1:33;
patcharea=xdata(ceil(t),21)/100;%average patch size from 1984-2016
thetaAA=theta(5);% scale factor for the effect of patch size preference on competition intensity of striped field mouse
eAA=theta(6);% intercept for the effect of patch size preference on competition intensity of striped field mouse
thetaCT=theta(11);% scale factor for the effect of patch size preference on competition intensity of CT
eCT=theta(12);%intercept for the effect of patch size preference on competition intensity of CT
thetaRN=theta(17);% scale factor for the effect of patch size preference on competition intensity of RN
eRN=theta(18);% intercept for the effect of patch size preference on competition intensity of RN

landaa=thetaAA*patcharea+eAA;%the effect of patch size preference of AA
landct=thetaCT*patcharea+eCT;%the effect of patch size preference of CT
landrn=thetaRN*patcharea+eRN;%the effect of patch size preference of RN
%model simulation
ydot=modelsimu(results2,landaa,landct,landrn);

%% no competition
clandaa(1:33)=0;
clandct(1:33)=0;
clandrn(1:33)=0;
ydotnocom=modelsimu(results2,clandaa,clandct,clandrn);
figure
title('33year real')
subplot(311)
plot(ydotnocom(:,1))
subplot(312)
plot(ydotnocom(:,2))
subplot(313)
plot(ydotnocom(:,3))

%% unchanged patch 
plandaa(1:33)=landaa(1);
plandct(1:33)=landct(1);
plandrn(1:33)=landrn(1);
ydotnochange=modelsimu(results2,plandaa,plandct,plandrn);

%% different change rate of patch size
% accelerated land consolidation by 30%
patcharea3=patcharea;
for i=2:33;
    patcharea3(i)=patcharea3(i-1)+(patcharea(i)-patcharea(i-1))*1.3;  
end    
landaa3=thetaAA*patcharea3+eAA;%the effect of patch size preference of AA
landct3=thetaCT*patcharea3+eCT;%the effect of patch size preference of CT
landrn3=thetaRN*patcharea3+eRN;%the effect of patch size preference of RN
yland3=modelsimu(results2,landaa3,landct3,landrn3);

% accelerated land consolidation by 20%
patcharea2=patcharea;
for i=2:33;
    patcharea2(i)=patcharea2(i-1)+(patcharea(i)-patcharea(i-1))*1.2;  
end    
landaa2=thetaAA*patcharea2+eAA;%the effect of patch size preference of AA
landct2=thetaCT*patcharea2+eCT;%the effect of patch size preference of CT
landrn2=thetaRN*patcharea2+eRN;%the effect of patch size preference of RN
yland2=modelsimu(results2,landaa2,landct2,landrn2);

% accelerated land consolidation by 10%
patcharea1=patcharea;
for i=2:33;
    patcharea1(i)=patcharea1(i-1)+(patcharea(i)-patcharea(i-1))*1.1;  
end    
landaa1=thetaAA*patcharea1+eAA;%the effect of patch size preference of AA
landct1=thetaCT*patcharea1+eCT;%the effect of patch size preference of CT
landrn1=thetaRN*patcharea1+eRN;%the effect of patch size preference of RN
yland1=modelsimu(results2,landaa1,landct1,landrn1);

% slow down land consolidation by 10%
patcharea1n=patcharea;
for i=2:33;
    patcharea1n(i)=patcharea1n(i-1)+(patcharea(i)-patcharea(i-1))*0.9;  
end    
landaa1n=thetaAA*patcharea1n+eAA;%the effect of patch size preference of AA
landct1n=thetaCT*patcharea1n+eCT;%the effect of patch size preference of CT
landrn1n=thetaRN*patcharea1n+eRN;%the effect of patch size preference of RN
yland1n=modelsimu(results2,landaa1n,landct1n,landrn1n);

% slow down land consolidation by 20%
patcharea2n=patcharea;
for i=2:33;
    patcharea2n(i)=patcharea2n(i-1)+(patcharea(i)-patcharea(i-1))*0.8;  
end    
landaa2n=thetaAA*patcharea2n+eAA;%the effect of patch size preference of AA
landct2n=thetaCT*patcharea2n+eCT;%the effect of patch size preference of CT
landrn2n=thetaRN*patcharea2n+eRN;%the effect of patch size preference of RN
yland2n=modelsimu(results2,landaa2n,landct2n,landrn2n);

% slow down land consolidation by 30%
patcharea3n=patcharea;
for i=2:33;
    patcharea3n(i)=patcharea3n(i-1)+(patcharea(i)-patcharea(i-1))*0.7;  
end    
landaa3n=thetaAA*patcharea3n+eAA;%the effect of patch size preference of AA
landct3n=thetaCT*patcharea3n+eCT;%the effect of patch size preference of CT
landrn3n=thetaRN*patcharea3n+eRN;%the effect of patch size preference of RN
yland3n=modelsimu(results2,landaa3n,landct3n,landrn3n);

yfinal=[yland3,yland2,yland1,ydot,yland1n,yland2n,yland3n];

%%
% figure
% subplot(3,1,1)
% plot(yfinal(:,1))
% hold on
% for i=1:6
%     plot(yfinal(:,3*i+1))
% end
% hold off
% subplot(3,1,2)
% plot(yfinal(:,2))
% hold on
% for i=1:6
%     plot(yfinal(:,3*i+2))
% end
% hold off
% subplot(3,1,3)
% plot(yfinal(:,3))
% hold on
% for i=1:6
%     plot(yfinal(:,3*i+3))
% end
% hold off
