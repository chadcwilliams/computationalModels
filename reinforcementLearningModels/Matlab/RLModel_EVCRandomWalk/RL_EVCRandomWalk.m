clear all; clc;

%% Initiation

%Determine board and starting/ target locations
board_values = ones(20,20)*0;
board_costs = ones(20,20)*0;
board_efforts = ones(20,20)*0;
rand_spots = [Shuffle(1:20);Shuffle(1:20)];
rand_spots(1:2,1) = [18;10]; %Force target to specific spot
rand_spots(1:2,end) = [3;10]; %Force agent to specific spot
board_values(rand_spots(1,1),rand_spots(2,1)) = 1;
board_costs(8,1:20) = 0.05:.05:1; %Add a wall of cost
board_costs(13,1:20) = 1:-.05:.05; %Add a wall of cost

%Create platform for model location
board_template = zeros(20,20);
board_template(rand_spots(1,end),rand_spots(2,end)) = -1;
board_template(rand_spots(1,1),rand_spots(2,1)) = 1;
board_template(8,1:20) = (0.05:.05:1)+2; %Add cost 
board_template(13,1:20) = (1:-.05:.05)+2; %Add cost 

%Model Parameters
parameters.target = [rand_spots(1,1),rand_spots(2,1)];
parameters.learning_rate = .7; %Learning Rate
parameters.temperature = .15; %Exploration rate of SoftMax solution
parameters.discount = .99; %Degree to which future rewards have influence
parameters.costdiscount = .1; %Degree to which future rewards have influence
parameters.epsilon = .1; %Exploration rate of greedy solution
parameters.responseSolutions = 'SoftMax'; %Options are 'Greedy' and 'SoftMax'
parameters.learningSolutions = 'Q'; %Q or SARSA
parameters.Steps = []; %Create empty variable to track number of steps to target
parameters.effort_cost = 2; %Lower numbers = more punishment for steps

%% Run
for walk = 1:100
    if mod(walk,100)==0
        disp(['Walk: ',num2str(walk)]);
    end

    %Reset board
    ongoing = 1;
    board_state = zeros(20,20);
    board_state(rand_spots(1,end),rand_spots(2,end)) = 1;
    [x,y] = find(board_state==1);
    parameters.step = 0;
    while ongoing
        %% Select action
        %Determine action of current state
        [action, update_value, update_cost] = select_action(x,y,board_values,board_efforts,parameters);
        
        %Determine next state
        [x2,y2] = next_state(x,y,action);
        
        %% Update Model
        %Update Values
        [board_values,board_efforts] = update_values(x,y,x2,y2,board_values,board_costs,board_efforts,update_value,update_cost,parameters);
        
        %Update Board State
        [ongoing,x,y,board_state] = update_state(x,y,x2,y2,board_state,parameters);
        
        %Update Step for Model Assessment
        parameters.step = parameters.step + 1;
    end
    
    %% Plot Output
    parameters.Steps = [parameters.Steps,parameters.step];
    plot_walk(board_template,board_values,board_efforts,parameters)
end

