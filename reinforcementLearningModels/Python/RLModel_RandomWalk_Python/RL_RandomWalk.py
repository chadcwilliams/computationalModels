#Random Walk Reinforcement Learning Model

#Clean environment
#from IPython import get_ipython
#get_ipython().magic('reset -f') #Clears variables
#get_ipython().magic('clear') #Clears console

#Import 
import numpy as np
import pandas as pd
import RL_RandomWalk_Functions as rl

#Setup
#Determine Target and Reward
pos_locs = np.array([np.arange(20),np.arange(20)])
np.random.shuffle(pos_locs[0,])
np.random.shuffle(pos_locs[1,])

start = np.array([pos_locs[0,0],pos_locs[1,0]])
end = np.array([pos_locs[0,-1],pos_locs[1,-1]])

board_template = np.zeros((20,20))
board_template[start[0],start[1]] = 1
board_template[end[0],end[1]] = -1

board_values = np.zeros((20,20))
board_values[end[0],end[1]] = 1

#Parameters
parameters = pd.DataFrame([np.zeros(9)],columns = ['target_x','target_y','temperature','learning_rate','discount','epsilon','responseSolutions','learningSolutions','steps'])
parameters['target_x'] = end[0]
parameters['target_y'] = end[1]
parameters['temperature'] = .1
parameters['learning_rate'] = .2
parameters['discount'] = .99
parameters['epsilon'] = .1
parameters['responseSolutions'] = 'SoftMax' #Can be 'Greedy' or 'SoftMax'
parameters['learningSolutions'] = 'SARSA' #Can be 'Q' or 'SARSA'
parameters['steps'] = np.nan

for walk in range (0,100):
    
    if walk % 100 == 0:
        print('Walk: '+ str(walk))
    
    board_state = np.zeros((20,20))
    board_state[start[0],start[1]] = 1

    x = start[0]
    y = start[1]
    
    ongoing = 1
    step = 0
    while ongoing:
        
        ## Select Action
        #Determine action of current state
        action,update_value = rl.select_action(x,y,board_values,parameters)
        
        #Determine Next State
        x2,y2 = rl.next_state(x,y,action)
        
        ## Update Model
        #Update Values
        board_values = rl.update_values(x,y,x2,y2,board_values,update_value,parameters)
        
        #Update Board State
        x,y,board_state,ongoing = rl.update_state(x,y,x2,y2,board_state,parameters)
        
        #Update step for model assessment
        step += 1
                
    ## Plot data
    parameters['steps'] = [np.append(parameters['steps'][0],step)]    
rl.plot_walk(board_template,board_state,board_values,parameters)