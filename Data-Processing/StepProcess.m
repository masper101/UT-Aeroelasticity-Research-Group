function [StepData, StepDataAvg] = StepProcess(StreamData,conditions)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% This function is used to process loads data with step input 
%
% Function(s) called:
% (1) fprocStep
% 
% INPUTS:
%        StreamData = All loads data from the streams data files 
%                     (See LoadData)
%        condition = [Temperature [F], Humidity, Prassure [in-hg]] 
%
% OUTPUTS:
%        StepData = Structure containing all loads data organized in the 
%                   following fields 
%           (1) OMEGA = Instantaneous RPM signal
%           (2) before
%           (3) during 
%           (4) after
%           (2)-(4) have the following fields
%               Fx_outer     
%               Fy_outer
%               Fz_outer
%               Mx_outer
%               My_outer
%               Mz_outer
%               OMEGA 
%
%        StepDataAvg = Structure containing all averaged loads data 
%                      organized in the following fields 
%           (1) before
%           (2) during 
%           (3) after
%           (1)-(3) have the following fields
%               Fx_outer     
%               Fy_outer
%               Fz_outer
%               Mx_outer
%               My_outer
%               Mz_outer
%               OMEGA
%               cts_outer
%               cps_outer
%               OMEGA
%               err_Fx_outer
%               err_Fy_outer
%               err_Fz_outer
%               err_Mx_outer
%               err_My_outer
%               err_Mz_outer
%               err_cts_outer
%               err_cps_outer
%               err_OMEGA
%
% CREATED: Patrick Mortimer 04/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parameters
FS = 10000; % Sampling frequency
lenends = 2000;

c = 0.08;
StreamData.R = 1.108;
Nblade = 2;
StreamData.sigma = StreamData.R*c*Nblade / (pi*StreamData.R^2);

T     = (conditions(1) - 32)*5/9 + 273.15; % [Kelvin]
P     = conditions(3)*101325/29.9212; % [Pa]
R_air = 287.05; 
StreamData.rho = P/R_air/T;

% Filtering options
filtoptions.smooth  = true;
filtoptions.moveavg = false;
filtoptions.Lpass   = false;
filtoptions.wndw    = 2000;

% Interpolating the measured rotational speed
for ii = 1:length(StreamData.names)
   
    npts = length(StreamData.Fz_outer{1,ii});
    tvec = [0:1/FS:(npts-1)/FS]';

    x    = [linspace(0,max(tvec),length(StreamData.OMEGA{1,ii}))]';
    y    = StreamData.OMEGA{1,ii};
    
    StepData.OMEGA{1,ii} = interp1(x,y,tvec,'linear');
    
end

[ipt]  = fprocStep(StreamData.Fz_outer,filtoptions,lenends,FS);
[ipts] = fprocStep(StepData.OMEGA,filtoptions,lenends,FS);

% Organizing data
for ii = 1:length(StreamData.names)
   
    % Organizing data before step
    StepData.before(ii).Fx_outer = StreamData.Fx_outer{ii}(1:ipt(1,ii)+lenends);
    StepData.before(ii).Fy_outer = StreamData.Fy_outer{ii}(1:ipt(1,ii)+lenends);
    StepData.before(ii).Fz_outer = StreamData.Fz_outer{ii}(1:ipt(1,ii)+lenends);
    StepData.before(ii).Mx_outer = StreamData.Mx_outer{ii}(1:ipt(1,ii)+lenends);
    StepData.before(ii).My_outer = StreamData.My_outer{ii}(1:ipt(1,ii)+lenends);
    StepData.before(ii).Mz_outer = StreamData.Mz_outer{ii}(1:ipt(1,ii)+lenends);
    StepData.before(ii).OMEGA    = StepData.OMEGA{ii}(1:ipts(1,ii)+lenends);

    % Organizing data during step
    StepData.during(ii).Fx_outer = StreamData.Fx_outer{ii}(ipt(1,ii)+lenends:ipt(2,ii)+lenends);
    StepData.during(ii).Fy_outer = StreamData.Fy_outer{ii}(ipt(1,ii)+lenends:ipt(2,ii)+lenends);
    StepData.during(ii).Fz_outer = StreamData.Fz_outer{ii}(ipt(1,ii)+lenends:ipt(2,ii)+lenends);
    StepData.during(ii).Mx_outer = StreamData.Mx_outer{ii}(ipt(1,ii)+lenends:ipt(2,ii)+lenends);
    StepData.during(ii).My_outer = StreamData.My_outer{ii}(ipt(1,ii)+lenends:ipt(2,ii)+lenends);
    StepData.during(ii).Mz_outer = StreamData.Mz_outer{ii}(ipt(1,ii)+lenends:ipt(2,ii)+lenends);   
    StepData.during(ii).OMEGA    = StepData.OMEGA{ii}(ipts(1,ii)+lenends:ipts(2,ii)+lenends);
    
    % Organizing data after step
    StepData.after(ii).Fx_outer = StreamData.Fx_outer{ii}(ipt(2,ii)+lenends:end);
    StepData.after(ii).Fy_outer = StreamData.Fy_outer{ii}(ipt(2,ii)+lenends:end);
    StepData.after(ii).Fz_outer = StreamData.Fz_outer{ii}(ipt(2,ii)+lenends:end);
    StepData.after(ii).Mx_outer = StreamData.Mx_outer{ii}(ipt(2,ii)+lenends:end);
    StepData.after(ii).My_outer = StreamData.My_outer{ii}(ipt(2,ii)+lenends:end);
    StepData.after(ii).Mz_outer = StreamData.Mz_outer{ii}(ipt(2,ii)+lenends:end);       
    StepData.after(ii).OMEGA   = StepData.OMEGA{ii}(ipts(2,ii)+lenends:end);
    
end

% Padarrays and arrange into one matrix
for ii = 1:length(StreamData.names)
    
    % Before step
    for jj = 1:length(StreamData.names)
    
        s(jj) = size(StepData.before(jj).Fz_outer,1);
        h(jj) = size(StepData.before(jj).OMEGA,1);
        
    end
    
    pdsize = max(s)-s(ii);
    pdsize2 = max(s) - h(ii);
    
    before(ii).Fx_outer = padarray(StepData.before(ii).Fx_outer,pdsize,nan,'post');
    before(ii).Fy_outer = padarray(StepData.before(ii).Fy_outer,pdsize,nan,'post');
    before(ii).Fz_outer = padarray(StepData.before(ii).Fz_outer,pdsize,nan,'post');
    before(ii).Mx_outer = padarray(StepData.before(ii).Mx_outer,pdsize,nan,'post');
    before(ii).My_outer = padarray(StepData.before(ii).My_outer,pdsize,nan,'post');
    before(ii).Mz_outer = padarray(StepData.before(ii).Mz_outer,pdsize,nan,'post');
    before(ii).OMEGA    = padarray(StepData.before(ii).OMEGA,pdsize2,nan,'post');
    
    Fx_outer_before(:,ii) = [before(ii).Fx_outer];
    Fy_outer_before(:,ii) = [before(ii).Fy_outer];
    Fz_outer_before(:,ii) = [before(ii).Fz_outer];
    Mx_outer_before(:,ii) = [before(ii).Mx_outer];
    My_outer_before(:,ii) = [before(ii).My_outer];
    Mz_outer_before(:,ii) = [before(ii).Mz_outer];
    OMEGA_before(:,ii) = [before(ii).OMEGA];

    cts_outer_before(:,ii) = Fz_outer_before(:,ii) ./ StreamData.rho / (pi * StreamData.R^2) ./ (OMEGA_before(:,ii).*StreamData.R).^2 / StreamData.sigma;
    cps_outer_before(:,ii) = Mz_outer_before(:,ii) ./ StreamData.rho / (pi * StreamData.R^2) ./ (OMEGA_before(:,ii).*StreamData.R).^2 /StreamData.R / StreamData.sigma;
  
    
    % During step
    for kk = 1:length(StreamData.names)   
    
        s(kk) = size(StepData.during(kk).Fz_outer,1);
        h(kk) = size(StepData.during(kk).OMEGA,1);

    end
    
    pdsize = max(h)-s(ii);
    pdsize2 = max(h) - h(ii);

    during(ii).Fx_outer = padarray(StepData.during(ii).Fx_outer,pdsize,nan,'post');
    during(ii).Fy_outer = padarray(StepData.during(ii).Fy_outer,pdsize,nan,'post');
    during(ii).Fz_outer = padarray(StepData.during(ii).Fz_outer,pdsize,nan,'post');
    during(ii).Mx_outer = padarray(StepData.during(ii).Mx_outer,pdsize,nan,'post');
    during(ii).My_outer = padarray(StepData.during(ii).My_outer,pdsize,nan,'post');
    during(ii).Mz_outer = padarray(StepData.during(ii).Mz_outer,pdsize,nan,'post');
    during(ii).OMEGA    = padarray(StepData.during(ii).OMEGA,pdsize2,nan,'post');
    
    Fx_outer_during(:,ii) = [during(ii).Fx_outer];
    Fy_outer_during(:,ii) = [during(ii).Fy_outer];
    Fz_outer_during(:,ii) = [during(ii).Fz_outer];
    Mx_outer_during(:,ii) = [during(ii).Mx_outer];
    My_outer_during(:,ii) = [during(ii).My_outer];
    Mz_outer_during(:,ii) = [during(ii).Mz_outer];    
    OMEGA_during(:,ii)    = [during(ii).OMEGA];
    
    cts_outer_during(:,ii) = Fz_outer_during(:,ii) ./ StreamData.rho / (pi * StreamData.R^2) ./ (OMEGA_during(:,ii).*StreamData.R).^2 / StreamData.sigma;
    cps_outer_during(:,ii) = Mz_outer_during(:,ii) ./ StreamData.rho / (pi * StreamData.R^2) ./ (OMEGA_during(:,ii).*StreamData.R).^2 /StreamData.R / StreamData.sigma;    
    
    
    % After step
    for cc = 1:length(StreamData.names)
    
        s(cc) = size(StepData.after(cc).Fz_outer,1);
        h(cc) = size(StepData.after(cc).OMEGA,1);
       
    end
    
    pdsize = max(h)-s(ii);
    pdsize2 = max(h) - h(ii);
    
    after(ii).Fx_outer = padarray(StepData.after(ii).Fx_outer,pdsize,nan,'post');
    after(ii).Fy_outer = padarray(StepData.after(ii).Fy_outer,pdsize,nan,'post');
    after(ii).Fz_outer = padarray(StepData.after(ii).Fz_outer,pdsize,nan,'post');
    after(ii).Mx_outer = padarray(StepData.after(ii).Mx_outer,pdsize,nan,'post');
    after(ii).My_outer = padarray(StepData.after(ii).My_outer,pdsize,nan,'post');
    after(ii).Mz_outer = padarray(StepData.after(ii).Mz_outer,pdsize,nan,'post');
    after(ii).OMEGA    = padarray(StepData.after(ii).OMEGA,pdsize2,nan,'post');
    
    Fx_outer_after(:,ii) = [after(ii).Fx_outer];
    Fy_outer_after(:,ii) = [after(ii).Fy_outer];
    Fz_outer_after(:,ii) = [after(ii).Fz_outer];
    Mx_outer_after(:,ii) = [after(ii).Mx_outer];
    My_outer_after(:,ii) = [after(ii).My_outer];
    Mz_outer_after(:,ii) = [after(ii).Mz_outer];  
    OMEGA_after(:,ii)    = [after(ii).OMEGA];
    
    cts_outer_after(:,ii) = Fz_outer_after(:,ii) ./ StreamData.rho / (pi * StreamData.R^2) ./ (OMEGA_after(:,ii).*StreamData.R).^2 / StreamData.sigma;
    cps_outer_after(:,ii) = Mz_outer_after(:,ii) ./ StreamData.rho / (pi * StreamData.R^2) ./ (OMEGA_after(:,ii).*StreamData.R).^2 /StreamData.R / StreamData.sigma;
    
end

% Calculating averages and standard deviations with 95% confidence
p = 0.95;
nu = size(Fz_outer_before,1);
xx = tinv(p,nu);

StepDataAvg.before.Fx_outer  = nanmean(Fx_outer_before,2);
StepDataAvg.before.Fy_outer  = nanmean(Fy_outer_before,2);
StepDataAvg.before.Fz_outer  = nanmean(Fz_outer_before,2);
StepDataAvg.before.Mx_outer  = nanmean(Mx_outer_before,2);
StepDataAvg.before.My_outer  = nanmean(My_outer_before,2);
StepDataAvg.before.Mz_outer  = nanmean(Mz_outer_before,2);
StepDataAvg.before.cts_outer = nanmean(cts_outer_before,2);
StepDataAvg.before.cps_outer = nanmean(cps_outer_before,2);
StepDataAvg.before.OMEGA     = nanmean(OMEGA_before,2);

StepDataAvg.before.err_Fx_outer  = xx*nanstd(Fx_outer_before,0,2);
StepDataAvg.before.err_Fy_outer  = xx*nanstd(Fy_outer_before,0,2);
StepDataAvg.before.err_Fz_outer  = xx*nanstd(Fz_outer_before,0,2);
StepDataAvg.before.err_Mx_outer  = xx*nanstd(Mx_outer_before,0,2);
StepDataAvg.before.err_My_outer  = xx*nanstd(My_outer_before,0,2);
StepDataAvg.before.err_Mz_outer  = xx*nanstd(Mz_outer_before,0,2);
StepDataAvg.before.err_cts_outer = xx*nanstd(cts_outer_before,0,2);
StepDataAvg.before.err_cps_outer = xx*nanstd(cps_outer_before,0,2);
StepDataAvg.before.err_OMEGA     = xx*nanstd(OMEGA_before,0,2);

nu = size(Fz_outer_during,1);
xx = tinv(p,nu);

StepDataAvg.during.Fx_outer  = nanmean(Fx_outer_during,2);
StepDataAvg.during.Fy_outer  = nanmean(Fy_outer_during,2);
StepDataAvg.during.Fz_outer  = nanmean(Fz_outer_during,2);
StepDataAvg.during.Mx_outer  = nanmean(Mx_outer_during,2);
StepDataAvg.during.My_outer  = nanmean(My_outer_during,2);
StepDataAvg.during.Mz_outer  = nanmean(Mz_outer_during,2);
StepDataAvg.during.cts_outer = nanmean(cts_outer_during,2);
StepDataAvg.during.cps_outer = nanmean(cps_outer_during,2);
StepDataAvg.during.OMEGA     = nanmean(OMEGA_during,2);

StepDataAvg.during.err_Fx_outer  = xx*nanstd(Fx_outer_during,0,2);
StepDataAvg.during.err_Fy_outer  = xx*nanstd(Fy_outer_during,0,2);
StepDataAvg.during.err_Fz_outer  = xx*nanstd(Fz_outer_during,0,2);
StepDataAvg.during.err_Mx_outer  = xx*nanstd(Mx_outer_during,0,2);
StepDataAvg.during.err_My_outer  = xx*nanstd(My_outer_during,0,2);
StepDataAvg.during.err_Mz_outer  = xx*nanstd(Mz_outer_during,0,2);
StepDataAvg.during.err_cts_outer = xx*nanstd(cts_outer_during,0,2);
StepDataAvg.during.err_cps_outer = xx*nanstd(cps_outer_during,0,2);
StepDataAvg.during.err_OMEGA     = xx*nanstd(OMEGA_during,0,2);

nu = size(Fz_outer_after,1);
xx = tinv(p,nu);

StepDataAvg.after.Fx_outer  = nanmean(Fx_outer_after,2);
StepDataAvg.after.Fy_outer  = nanmean(Fy_outer_after,2);
StepDataAvg.after.Fz_outer  = nanmean(Fz_outer_after,2);
StepDataAvg.after.Mx_outer  = nanmean(Mx_outer_after,2);
StepDataAvg.after.My_outer  = nanmean(My_outer_after,2);
StepDataAvg.after.Mz_outer  = nanmean(Mz_outer_after,2);
StepDataAvg.after.cts_outer = nanmean(cts_outer_after,2);
StepDataAvg.after.cps_outer = nanmean(cps_outer_after,2);
StepDataAvg.after.OMEGA     = nanmean(OMEGA_after,2);

StepDataAvg.after.err_Fx_outer  = xx*nanstd(Fx_outer_after,0,2);
StepDataAvg.after.err_Fy_outer  = xx*nanstd(Fy_outer_after,0,2);
StepDataAvg.after.err_Fz_outer  = xx*nanstd(Fz_outer_after,0,2);
StepDataAvg.after.err_Mx_outer  = xx*nanstd(Mx_outer_after,0,2);
StepDataAvg.after.err_My_outer  = xx*nanstd(My_outer_after,0,2);
StepDataAvg.after.err_Mz_outer  = xx*nanstd(Mz_outer_after,0,2);
StepDataAvg.after.err_cts_outer = xx*nanstd(cts_outer_after,0,2);
StepDataAvg.after.err_cps_outer = xx*nanstd(cps_outer_after,0,2);
StepDataAvg.after.err_OMEGA     = xx*nanstd(OMEGA_after,0,2);

% End of function

end