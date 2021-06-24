%Back-Propagating Neural Network for the Cards experiment (Williams et al., 2017)
%Written by Chad Williams and Cameron Hassall, University of Victoria
%March 2017

%Note: Must install deep neural network package (solely for the sigmoid function) from:
%https://www.mathworks.com/matlabcentral/fileexchange/42853-deep-neural-network/content/DeepNeuralNetwork/sigmoid.m

%% Model Controls

train_model = 1; %Turning this off will let you simulate the trained model
continuous_run = 0; %If on, this keeps re-running the model until it learns
assess_model_accuracy = 0; %Continuously run model 1000 times to determine chance of success

%% Model Setup

if train_model == 1;
    clearvars -except train_model continuous_run assess_model_accuracy
end

%Model Parameters
shuffle(rng); %Randomize the random function
num_of_steps = 20000; %Number of steps model will undergo
num_of_input = 10; %Number of nodes in the input layer
num_of_hidden = 10; %Number of nodes in the hidden layer
num_of_output = 5; %Number of nodes in the output layer
LearningRate = .2; %Model learning rate
time_to_convergence = num_of_steps; %X axis of plots

go = 1; %Variable to continuously run the model
model = 0; %Tracks how many times the model has been run
num_models = 1000; % If assessing model accuracy, how many times do you want to run the model
clc; %Clear command window

%% Train the Model
while go
    model = model+1; %Increase the model count by one
    disp(num2str(model)); %Displays the models occurence
    if train_model == 1
        
        % Define initial weights
        IHWeights = -ones(num_of_input,num_of_hidden) + 2 * rand(num_of_input,num_of_hidden); %Randomize weights between the input and hidden layer
        HOWeights = -ones(num_of_hidden,num_of_output) + 2 * rand(num_of_hidden,num_of_output); %Randomize weights between the hidden and output layer
        
        %Generate Input Data
        outtarget = [1,0,0,0,0; 0,1,0,0,0; 0,0,1,0,0; 0,0,0,1,0; 0,0,0,0,1]; %Determine correct output for each input
        obias = zeros(1,num_of_output); %Initialize adjustment to output nodes
        hbias = zeros(1,num_of_hidden); %Initialize adjustments to hidden nodes

        for step = 1:num_of_steps %Begin model training
            %Determine the order of the inputs
            TrialOrder = randperm(5); %Randomize the order that the inputs are presented
            
            %Clear past variables
            clear mva mvb mvc mvd mve mvf mvg mvh mvi mvj mvk mvl mvm mvn mvo mvp mvq mvr mvs mvt Range1 Range2 Range3 Range4 Range5 Text1 Text2 Text3 Text4 Text5 Input target
            
            for j = 1:length(TrialOrder) %Cycle through all inputs each step
                % Select input - Input generated by these scripts to choose a random number per variable within the range of the disease
                
                TrialInput = TrialOrder(j); %Define the disease input to be generated
                
                if TrialInput == 1
                    ModelValues1 %Generate input one
                end
                if TrialInput == 2
                    ModelValues2 %Generate input two
                end
                if TrialInput == 3
                    ModelValues3 %Generate input three
                end
                if TrialInput == 4
                    ModelValues4 %Generate input four
                end
                if TrialInput == 5
                    ModelValues5 %Generate input five
                end
                
                % Define correct ouput (target) of the input
                target(1,:) = outtarget(TrialInput,:);
                
                % Present input layer
                Input = [Range1,Range2,Range3,Range4,Range5,Text1,Text2,Text3,Text4,Text5];
                
                % Determine the hidden layer
                tempHidden = (Input * IHWeights) + hbias; %Generate hidden nodes
                Hidden = sigmoid(tempHidden); %Adjust nodes with a sigmoid function
                
                %Determine output layer
                tempOutput = (Hidden * HOWeights) + obias; %Generate output nodes
                Output(TrialInput,:) = sigmoid(tempOutput); %Adjust nodes with a sigmoid function
                
                % Compute model error
                BP(5 * (step - 1)+ j,:) = (target(:)'-Output(TrialInput,:)).*(Output(TrialInput,:).*(1-Output(TrialInput,:))); %Output Error
                error(step,:,TrialInput) = abs(target(:)' - Output(TrialInput,:)); %Record error for plotting
                
                BP2 = Hidden' .* (1.0 - Hidden') .* (HOWeights .* BP(5 * (step - 1)+ j,:)); %Hidden Error
                
                obias = obias + BP(5 * (step - 1)+ j,:)*LearningRate; %Change output biases
                
                for k = 1:num_of_hidden
                    for l = 1:num_of_output
                        hbias(k) = hbias(k) + BP2(k).*LearningRate; %Change hidden biases
                    end
                end
                
                %Update the Hidden - Output Weights
                delW2 = (LearningRate .* BP(5 * (step-1) + j,:)) .* Hidden'; %Determine the degree of adjustment
                HOWeights = HOWeights + delW2; %Adjust hidden-output weights
                
                %Update the Input - Hidden weights
                A = Input'; %Reorganize variables
                for k = 1:(num_of_hidden - 1)
                    A = [A Input'];
                end
                e = [BP2';BP2'];
                delW1 = LearningRate .* A .* e; %Determine the degree of adjustment
                IHWeights = IHWeights + delW1; %Adjust input-hidden Weights
            end
        end
    end
    
    if assess_model_accuracy == 0 %If not assessing model accuracy, stop either after one run or after model achieves success
        % Determine whether the model has learned
        if (mean(error(end,:,1)) < 0.05) && (mean(error(end,:,2)) < 0.05) && (mean(error(end,:,3)) < 0.05) && (mean(error(end,:,4)) < 0.05) && (mean(error(end,:,5)) < 0.05)
            go = 0; %End model re-runs if model is trained
            save('Trained_Model') %Save entire workspace for use in future simulations
        end
        
        % End after one model run, if selected
        if continuous_run ==0
            go = 0; %End model re-runs
        end
    else %If assessing model, track whether the model succeeds or fails
        if (mean(error(end,:,1)) < 0.05) && (mean(error(end,:,2)) < 0.05) && (mean(error(end,:,3)) < 0.05) && (mean(error(end,:,4)) < 0.05) && (mean(error(end,:,5)) < 0.05)
            model_accuracy(model) = 1; %Determine model has succeeded
        else
            model_accuracy(model) = 0; %Determine model has failed
        end
        
        if model == num_models %Stop running when reached the number of runs planned
            go = 0; %End model re-runs
            disp('Percent of model success:'); %Lead up text
            disp(num2str(sum(model_accuracy)/num_models)); %Display percentage of models successfully learned
        end
    end
end

%% Simulate Model


if train_model == 0
    
    % Enter the input manually
    clc;
    %siminput = str2num(input('Enter the disease code:\n','s'));
    
    for diseasecount = 1:5
        clear simoptions stempHidden sHidden stempOutput sOutput
        simoptions = repmat(diseasecount,[1,10000]);
        for simcount = 1:10000
            siminput = simoptions(simcount);
            
            if siminput == 1
                ModelValues1
            end
            if siminput == 2
                ModelValues2
            end
            if siminput == 3
                ModelValues3
            end
            if siminput == 4
                ModelValues4
            end
            if siminput == 5
                ModelValues5
            end
            
            % Present input layer
            sInput = [Range1,Range2,Range3,Range4,Range5,Text1,Text2,Text3,Text4,Text5];
            
            % Determine the hidden layer
            stempHidden = (sInput * IHWeights) + hbias;
            %sHidden = sigmoid(stempHidden);
            sHidden(simcount,:) = sigmoid(stempHidden);
            
            % Determine the output layer
            stempOutput = (sHidden(simcount,:) * HOWeights) + obias;
            sOutput(siminput,:) = sigmoid(stempOutput);
            
            %clc;
            %disp('Output:');
            %disp(sOutput(siminput,:));
            
            
        end
        disease(diseasecount,:) = mean(sHidden);
    end
    save('HiddenLayers3.mat','disease');
end

%% Makes a convergence plot for each input
if train_model == 1
    for counter = 1:num_of_output %Determine the average error of each model
        error(:,counter,num_of_output+1) = mean(error(:,:,counter),2);
    end
    user_error = error;
    num_hidden = num_of_hidden;
    n = time_to_convergence;
    ns = 1:n;
    c = zeros(1,n);
    for i = 1:n
        c(1,i) = 0.05;
    end
    figure;
    subplot(2,3,1);
    user_error(1,:);
    plot(ns, user_error(1:n,1,1),'.',ns, user_error(1:n,2,1),'.',ns, user_error(1:n,3,1),'.',ns, user_error(1:n,4,1),'.',ns, user_error(1:n,5,1),'.',ns, c, 'r-');
    title('Disease 1');
    xlabel('Epochs');
    ylabel('Error');
    axis([1 n 0 1]);
    subplot(2,3,2);
    plot(ns, user_error(1:n,1,2),'.',ns, user_error(1:n,2,2),'.',ns, user_error(1:n,3,2),'.',ns, user_error(1:n,4,2),'.',ns, user_error(1:n,5,2),'.', ns, c, 'r-');
    title('Disease 2');
    xlabel('Epochs');
    ylabel('Error');
    axis([1 n 0 1]);
    subplot(2,3,3);
    plot(ns, user_error(1:n,1,3),'.',ns, user_error(1:n,2,3),'.',ns, user_error(1:n,3,3),'.',ns, user_error(1:n,4,3),'.',ns, user_error(1:n,5,3),'.',ns, c, 'r-');
    title('Disease 3');
    xlabel('Epochs');
    ylabel('Error');
    axis([1 n 0 1]);
    subplot(2,3,4);
    plot(ns, user_error(1:n,1,4),'.',ns, user_error(1:n,2,4),'.',ns, user_error(1:n,3,4),'.',ns, user_error(1:n,4,4),'.',ns, user_error(1:n,5,4),'.',ns, c, 'r-');
    title('Disease 4');
    xlabel('Epochs');
    ylabel('Error');
    axis([1 n 0 1]);
    subplot(2,3,5);
    plot(ns, user_error(1:n,1,5),'.',ns, user_error(1:n,2,5),'.',ns, user_error(1:n,3,5),'.',ns, user_error(1:n,4,5),'.',ns, user_error(1:n,5,5),'.',ns, c, 'r-');
    title('Disease 5');
    xlabel('Epochs');
    ylabel('Error');
    axis([1 n 0 1]);
    subplot(2,3,6);
    plot(ns, user_error(1:n,1,6),'.',ns, user_error(1:n,2,6),'.',ns, user_error(1:n,3,6),'.',ns, user_error(1:n,4,6),'.',ns, user_error(1:n,5,6),'.',ns, c, 'r-');
    title('All Diseases');
    xlabel('Epochs');
    ylabel('Error');
    axis([1 n 0 1]);
    set(gcf,'color','w'); %Make background white
end
%% Assess Hidden Layer
if ~train_model
    
    clear all;
    %Load Hidden Layers
    %load('/Users/Chad/Dropbox (Krigolson Lab)/Projects/Medical Decision Making/Computational Model/Models/Cards Neural Network 2.0/Trained Model/HiddenLayers3.mat');
    load('/Users/Chad/Dropbox (Krigolson Lab)/Projects/Medical Decision Making/Computational Model/Models/Cards Neural Network 1.0/HiddenLayersAveragedData.mat');
    %disease = load('/Users/Chad/Dropbox (Krigolson Lab)/Projects/Medical Decision Making/Computational Model/Models/Cards Neural Network 1.0/AverageInput.txt');
    
    %Labels for one dimensional bar graph and dendogram, respectively
    %For Hidden Layers Data
    %labels = {'Cholestatic Intrahepatic', 'Severe Hepatocellular', 'Cholestatic Extrahepatic', 'Mild Hepatocellular', 'Moderate Hepatocellular'};
    %For Averaged data
    labels = {'Cholestatic Intrahepatic', 'Severe Hepatocellular', 'Mild Hepatocellular', 'Moderate Hepatocellular','Cholestatic Extrahepatic'};
    
    Euclidean = pdist(disease); %Determine euclidean distance of all possible pairs
    DistanceMatrix = squareform(Euclidean); %Summarize distances into a matrix
    OneDDistance = mean(DistanceMatrix); %Averaging the matrix allows for a one dimensional distance vector (smaller = most similar to others)
    OneDDistance(2,:) = [1,2,3,4,5];
    [OrderedOneD,Index]=sort(OneDDistance(1,:),'ascend');
    for ordercount = 1:5
        OrderedLabels{ordercount} = labels{1,Index(ordercount)};
    end
    
    subplot(1,2,1)
    bar(OrderedOneD); %Bar Graph
    set(gca,'XTickLabel', OrderedLabels,'FontName','Times','fontsize',18); %Add x axis labels
    xtickangle(45); %Make x axis labels diagonal
    
    PairwiseDistance = linkage(Euclidean,'average');
    
    subplot(1,2,2)
    dendrogram(PairwiseDistance, 'Labels', labels); %Dendrogram
    set(gca,'FontName','Times','fontsize',18); %Manipulate x axis labels
    xtickangle(45); %Make x labels diagonal
    set(gcf,'color','w'); %Make background white
end