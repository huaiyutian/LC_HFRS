function ydot = f4(t,theta,xdata)

%% storage allocation for variables
nAA=zeros(1,33);
nCT=zeros(1,33);
nRN=zeros(1,33);

%% parameter
%AA
bAA= theta(1); % birthrate of striped field mouse
dAA= theta(2); % death rate of striped field mouse
nAA(1)=theta(3);% initial popuation of striped field mouse
kAA= theta(4);% environment carring capicity of striped field mouse
thetaAA=theta(5);% scale factor for the effect of patch size preference on competition intensity of striped field mouse
eAA=theta(6);% intercept for the effect of patch size preference on competition intensity of striped field mouse
%CT
bCT= theta(7);%birthrate of CT
dCT= theta(8);% death rate of CT
nCT(1)=theta(9);% initial popuation of CT
kCT= theta(10);% environment carring capicity of CT
thetaCT=theta(11);% scale factor for the effect of patch size preference on competition intensity of CT
eCT=theta(12);%intercept for the effect of patch size preference on competition intensity of CT
%RN
bRN= theta(13);% birthrate of RN
dRN= theta(14);% death rate of RN
nRN(1)=theta(15);% initial popuation of RN
kRN= theta(16);% environment carring capicity of RN
thetaRN=theta(17);% scale factor for the effect of patch size preference on competition intensity of RN
eRN=theta(18);% intercept for the effect of patch size preference on competition intensity of RN

%% obeservation data 
patcharea=xdata(ceil(t),21)/100;%average patch size from 1984-2016
landaa=thetaAA*patcharea+eAA;%the effect of patch size preference of AA
landct=thetaCT*patcharea+eCT;%the effect of patch size preference of CT
landrn=thetaRN*patcharea+eRN;%the effect of patch size preference of RN

%% percent of rodent species-initial value 
ytem=nAA(1)+nRN(1)+nCT(1); %current sum of rodent population size
nAA(1)=nAA(1)/ytem; %propotion of AA
nCT(1)=nCT(1)/ytem; %propotion of CT
nRN(1)=nRN(1)/ytem; %propotion of RN

%% model
for i = 2:33; %
       
       %AA
       nAA(i) = nAA(i-1)+(bAA)*(nAA(i-1))*(1-(nAA(i-1)+nCT(i-1)*landct(i-1)+nRN(i-1)*landrn(i-1))/kAA)-dAA*nAA(i-1);   
       if(nAA(i)<0)
          nAA(i)=0.001;%population size should be >=0
       end
       
       %CT
        nCT(i) = nCT(i-1)+bCT*(nCT(i-1))*(1-(nCT(i-1)+nAA(i-1)*landaa(i-1)+nRN(i-1)*landrn(i-1))/kCT)-dCT*nCT(i-1);
        if(nCT(i)<0)
           nCT(i)=0.001; %population size should be >=0
        end
        
        %RN
        nRN(i) = nRN(i-1)+bRN*(nRN(i-1))*(1-(nRN(i-1)+nAA(i-1)*landaa(i-1)+nCT(i-1)*landct(i-1))/kRN)-dRN*nRN(i-1);
        if(nRN(i)<0)
           nRN(i)=0.001; %population size should be >=0
        end
           
       % recalculate proportion of rodent species-initial value 
        ytem=nAA(i)+nRN(i)+nCT(i); %current sum of rodent population size
        nAA(i)=nAA(i)/ytem;
        nCT(i)=nCT(i)/ytem;
        nRN(i)=nRN(i)/ytem;
        
        %Other constraints1
        if(bAA<=dAA | bCT<=dCT | bRN<=dRN )%birthrate should > death rate
           nAA(i)=0;
           nCT(i)=0;
           nRN(i)=0;
        end
        %Other constraints2
        %environment carring capicity > the sum effect of species
        if(((nAA(i-1)+nCT(i-1)*landct(i-1)+nRN(i-1)*landrn(i-1))>kAA)| ((nCT(i-1)+nAA(i-1)*landaa(i-1)+nRN(i-1)*landrn(i-1))>kCT)|((nRN(i-1)+nAA(i-1)*landaa(i-1)+nCT(i-1)*landct(i-1))>kRN))
           nAA(i)=0;
           nCT(i)=0;
           nRN(i)=0;
        end
end

%save data
ydot=[nAA(:),nCT(:),nRN(:)];

