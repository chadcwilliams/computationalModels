clear all; clc;

nBlocks = 1;
nBandits = 4; % Length should match nBlocks. Items should be perfect squares
nTrials = 1000; % Trials per block

%Initialize Model 
actualPayouts = initalize_payouts(nBandits,nTrials);

%Initialize Model
response_values = zeros(1,nBandits);
parameters.learning_rate = .1; %Learning Rate
parameters.temperature = 2; %Exploration rate of SoftMax solution
parameters.discount = .99; %Degree to which future rewards have influence
parameters.epsilon = .1; %Exploration rate of greedy solution
parameters.responseSolutions = 'SoftMax'; %Options are 'Greedy' and 'SoftMax'

for trial = 1:nTrials
    
    %Select Action
    [action] = select_action(response_values,parameters);
    
    %Update Values
    [response_values] = update_values(action,trial,response_values,actualPayouts,parameters);

    %Track values
    model_values(:,trial) = response_values;
end

%Plot
plot_output(model_values,actualPayouts);

corr(model_values(1,:)',actualPayouts{1,1}(1,:)')
corr(model_values(2,:)',actualPayouts{1,1}(2,:)')
corr(model_values(3,:)',actualPayouts{1,1}(3,:)')
corr(model_values(4,:)',actualPayouts{1,1}(4,:)')