clear all
load('rodentall3YEARpernew.mat');%data
% The model sum of squares given in the model structure.
model.ssfun = @f3;
lo=-Inf;

% All parameters are constrained to be positive. The initial
% concentrations are also unknown and are treated as extra parameters.
params = {
    %AA population 
    {'bAA', 2,1,Inf,3,0.5} % birthrate of striped field mouse
    {'dAA', 0.5,0.5,2}% death rate of striped field mouse
    {'N0_AA',0.7,0,1,0.85,0.05}% initial popuation of striped field mouse 
    {'KAA',1,0,15}% environment carring capicity of striped field mouse
    {'theta_AA',0,lo,Inf}% scale factor for the effect of patch size preference on competition intensity of striped field mouse
    {'eAA',0.5,0,Inf,0.5,0.15}% intercept for the effect of patch size preference on competition intensity of striped field mouse
    %CT population
    {'bCT', 2,0,5,2,0.5} % birthrate of CT
    {'dCT',  1,0.5,2}% death rate of CT
    {'N0_CT',0.1,0.01,1,0.113,0.05}% initial popuation of CT
    {'KCT',1,0,15}% environment carring capicity of CT
    {'theta_CT',0,lo,Inf}% scale factor for the effect of patch size preference on competition intensity of CT
    {'eCT',0.5,0,Inf,0.5,0.15}%intercept for the effect of patch size preference on competition intensity of CT
    %RN population
    {'bRN', 2,0,5,2,1} % birthrate of RN
    {'dRN',  1,0.5,2}% death rate of RN
    {'N0_RN',0.1,0.01,1}% initial popuation of RN
    {'KRN',1,0,15}% environment carring capicity of RN
    {'theta_RN',0,lo,Inf}% scale factor for the effect of patch size preference on competition intensity of RN
    {'eRN',0.5,0,Inf}% intercept for the effect of patch size preference on competition intensity of RN
    
        
};
%%
% We assume having at least some prior information on the
% repeatability of the observation and assign rather non informational
% prior for the residual variances of the observed states. The default
% prior distribution is sigma2 ~ invchisq(S20,N0), the inverse chi
% squared distribution (see for example Gelman et al.). The 3
% components (_A_, _Z_, _P_) all have separate variances.
model.S20 = [0.02,0.05,0.02]; %model and observation 
model.N0  = [1,0.5,0.5];

%%
% First generate an initial chain.
options.nsimu =50000;
options.stats = 1;
[results1, chain1, s2chain1]= mcmcrun(model,data,params,options);

% % Then re-run starting from the results of the previous run,
options.nsimu =200000;
options.stats = 1;
[results2, chain2, s2chain2] = mcmcrun(model,data,params,options,results1);
  

%%
% Chain plots should reveal that the chain has converged and we can
% % use the results for estimation and predictive inference.
 
figure 
mcmcplot(chain2,[],results2);
figure
mcmcplot(chain2,[],results2,'denspanel',2);

%% statistic of parameters 
results2.sstype = 1; % needed for mcmcpred and sqrt transformation
chainstats(chain2,results2)

%%
% In order to use the |mcmcpred| function we need
% function |modelfun| with input arguments given as
% |modelfun(xdata,theta)|. We construct this as an anonymous function.
modelfun = @(d,th) f4(d(:,1),th,d); 


%%
% We sample 1000 parameter realizations from |chain| and |s2chain|
% and calculate the predictive plots.
nsample = 1000;
results.sstype = 1; % needed for mcmcpred and sqrt transformation
out = mcmcpred(results2,chain2,s2chain2,data.xdata(1:end,:),modelfun,nsample);

figure
mcmcpredplot(out);

%save model results
fit=out.predlims{1,1}{1,1}(2,:);
fit2=out.predlims{1,1}{1,2}(2,:);
fit3=out.predlims{1,1}{1,3}(2,:);
%r-square
AAr2=1-sum((data.ydata(:,2)-fit').^2)/ sum((data.ydata(:,2)-mean(data.ydata(:,2))).^2)
CRr2=1-sum((data.ydata(:,3)-fit2').^2)/ sum((data.ydata(:,3)-mean(data.ydata(:,3))).^2)
RNr2=1-sum((data.ydata(:,4)-fit3').^2)/ sum((data.ydata(:,4)-mean(data.ydata(:,4))).^2)

