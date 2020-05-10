def softmax(response_values,parameters):
    import numpy as np
        
    possible_locs = ~np.isnan(response_values)
            
    temp_data = np.exp(np.divide(response_values[possible_locs],parameters['temperature'][0]))
    SM_Output = temp_data/np.sum(temp_data)
        
    SM_Output = SM_Output.cumsum()
        
    temp_action = np.zeros(len(SM_Output))
    chosen_action = np.where(SM_Output > np.random.rand())[0][0]
    temp_action[chosen_action] = 1
        
    output = np.zeros(4)
    output[possible_locs] = temp_action
    
    return output

def greedy(response_values, parameters):
    import numpy as np
     
    if np.random.uniform() < parameters['epsilon'][0]:
        possible_locs = ~np.isnan(response_values)
        temp_actions = response_values[possible_locs]
        action_selected = np.random.randint(0,len(temp_actions))
        temp_actions[:] = 0
        temp_actions[action_selected] = 1
        output = np.zeros(len(response_values))
        output[possible_locs] = temp_actions
    else:
        output = np.zeros(len(response_values))
        output[np.where(response_values==np.nanmax(response_values))[0][0]] = 1
    return output

def select_action(x,y,board_values,parameters):
    import numpy as np
    import RL_RandomWalk_Functions as rl

    response_values = np.empty(4)
    response_values[:] = np.nan
    if x-1 > -1:
        response_values[0] = board_values[x-1,y]
    if x+1 < len(board_values):
        response_values[1] = board_values[x+1,y]
    if y-1 > -1:
        response_values[2] = board_values[x,y-1]
    if y+1 < len(board_values):
        response_values[3] = board_values[x,y+1]
            
    if parameters['responseSolutions'][0] == 'SoftMax':
        output = rl.softmax(response_values,parameters)
    elif parameters['responseSolutions'][0] == 'Greedy':
        output = rl.greedy(response_values,parameters)
    else:
        print('Response solution not supported')
        
    action = np.where(output==1)[0][0]
    
    if parameters['learningSolutions'][0] == 'SARSA':
        update_value = response_values[action]
    elif parameters['learningSolutions'][0] == 'Q':
        update_value = np.nanmax(response_values)
    else:
        print('Learning solution not supported')
    
    return action,update_value

def next_state(x,y,action):
    x2=x;y2=y;
    if action == 0:
        x2=x-1;
    elif action == 1:
        x2=x+1;
    elif action == 2:
        y2=y-1;
    else:
        y2=y+1;
    return x2,y2

def update_values(x,y,x2,y2,board_values,update_value,parameters):
    if (x2 == parameters['target_x'][0]) & (y2 == parameters['target_y'][0]):
        reward = 1
    else:
        reward = 0
        
    PE = parameters['learning_rate'][0]*(reward+(parameters['discount'][0]*update_value)-board_values[x,y])
    board_values[x,y]+= PE
            
    if board_values[x,y] > 1:
        board_values[x,y] = 1
    elif board_values[x,y] < -1:
        board_values[x,y] = -1

    return board_values

def update_state(x,y,x2,y2,board_state,parameters):
    if (x2 == parameters['target_x'][0]) & (y2 == parameters['target_y'][0]):
        ongoing = 0
    else:
        ongoing = 1
        
    board_state[x2,y2] = 1
    board_state[x,y] = 0
    
    x=x2
    y=y2
    
    return x,y,board_state,ongoing
    
def plot_walk(board_template,board_state,board_values,parameters):
    from IPython import get_ipython
    get_ipython().magic('clear') #Clears console
    import matplotlib.pyplot as plt

    plt.cla()
    plt.subplot(1,4,1)
    plt.imshow(board_template, cmap='coolwarm', interpolation='nearest')
    plt.subplot(1,4,2)
    plt.imshow(board_state, cmap='coolwarm', interpolation='nearest')
    plt.subplot(1,4,3)
    plt.imshow(board_values, cmap='coolwarm',interpolation='nearest')
    plt.subplot(1,4,4)
    plt.plot(parameters['steps'][0])
    plt.show()
    
def plot_steps(board_values,h):
    from matplotlib.pyplot import draw, pause
    h.set_data(board_values)
    draw(), pause(1e-3)
    return h
