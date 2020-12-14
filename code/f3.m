function ss = f3(theta,data)

numh=size(data.ydata,2);
time   = data.ydata(:,1);
ydata  = data.ydata(:,2:numh);
xdata  = data.xdata(:,:);

ymodel = f4(time,theta,xdata);
ymodelnew=ymodel(:,1:numh-1);

%adjust data magnitude 
ymodelnew(:,2)=ymodelnew(:,2)*0.2;
ydata(:,2)=ydata(:,2)*0.2;

ss =sum((sqrt(ymodelnew) - sqrt(ydata)).^2);




