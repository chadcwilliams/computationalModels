%% Drift Diffusion Model
clear all; clc;

%Drift rate affects accuracy and lowers RT globally (does not separate RT between correct and error responses)
%Drift rate trial variability corresponds to long errors (failure to execute)
%Starting point trial variability corresponds to short errors (biased)
%Shortening decision time leads to more errors and shorter times (incomplete processing)

%Boundary separation: Response caution, focusing on accuracy

%Parameters
decision_threshold = 3;
starting_point = 0;
starting_variance = 1;
drift_rate = 0.0;
drift_variance = 0.3;
drift_trial_variance = 0.025;
decision_time_limit = 50000;
decision_time_variability = 20;

for run = 1:10000
    current_run = [];
    current_run = cumsum([current_run,normrnd(starting_point,starting_variance),normrnd(normrnd(drift_rate,drift_trial_variance),drift_variance,1, round(normrnd(decision_time_limit,decision_time_variability)))]);
    run_rt = find(abs(current_run)>3);
    if isempty(run_rt)
        run_rt = length(current_run);
    end
    
    
    %Track data
    data(1,run) = run_rt(1,1);
    data(2,run) = current_run(run_rt(1,1))>0;
    data(3,run) = current_run(1,1);
    
end

%Plot RT
clf;
d = data(1,data(2,:)==1); 
RT(1,1) = mean(d);
ACC(1,1) = length(d);
[n,x] = hist(d,25);
p = polyfit(x,n,7);
x1 = linspace(min(d),max(d));
y1 = polyval(p,x1);
plot(x1,y1);
hold on
d = data(1,data(2,:)==0);
[n,x] = hist(d,25);
p = polyfit(x,n,7);
x1 = linspace(min(d),max(d));
y1 = polyval(p,x1);
plot(x1,y1,'color','r');
ylim([0,inf]);
RT(1,2) = mean(d);
ACC(1,2) = length(d);

RT
ACC
