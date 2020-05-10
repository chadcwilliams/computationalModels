clear all; clc;

%% Initiation

%Determine board and starting/ target locations
board_values = ones(20,20)*0;
rand_spots = [Shuffle(1:20);Shuffle(1:20)];
board_values(rand_spots(1,1),rand_spots(2,1)) = 1;

%Create platform for model location
board_template = zeros(20,20);
board_template(rand_spots(1,end),rand_spots(2,end)) = -1;
board_template(rand_spots(1,1),rand_spots(2,1)) = 1;

%Model Parameters
parameters.target = [rand_spots(1,1),rand_spots(2,1)];
parameters.learning_rate = .7; %Learning Rate
parameters.temperature = .5; %Exploration rate of SoftMax solution
parameters.discount = .99; %Degree to which future rewards have influence
parameters.epsilon = .1; %Exploration rate of greedy solution
parameters.responseSolutions = 'SoftMax'; %Options are 'Greedy' and 'SoftMax'
parameters.learningSolutions = 'SARSA'; %Q or SARSA
parameters.Steps = []; %Create empty variable to track number of steps to target

%% Run
for walk = 1:100
    %Reset board
    ongoing = 1;
    board_state = zeros(20,20);
    board_state(rand_spots(1,end),rand_spots(2,end)) = 1;
    [x,y] = find(board_state==1);
    step = 0;
    while ongoing
        %% Select action
        %Determine action of current state
        [action, update_value] = select_action(x,y,board_values,parameters);
        
        %Determine next state
        [x2,y2] = next_state(x,y,action);
        
        %% Update Model
        %Update Values
        [board_values] = update_values(x,y,x2,y2,board_values,update_value,parameters);
        
        %Update Board State
        [ongoing,x,y,board_state] = update_state(x,y,x2,y2,board_state,parameters);
        
        %Update Step for Model Assessment
        step = step + 1;
    end
    
    %% Plot Output
    parameters.Steps = [parameters.Steps,step];
    plot_walk(board_template,board_values,parameters)
end

