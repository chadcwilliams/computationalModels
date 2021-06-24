function plot_walk(board_template,board_values,board_efforts,parameters)
subplot(2,3,1)
plot_template = zeros(22,22);
plot_template(2:21,2:21) = board_template;
pcolor(plot_template);
title('Start (Blue) and Target (Yellow) Locations');
subplot(2,3,2)
plot_values = zeros(22,22);
plot_values(2:21,2:21) = board_values;
pcolor(plot_values); shading interp;
title('Model Board Values');
subplot(2,3,3)
plot_efforts = zeros(22,22);
plot_efforts(2:21,2:21) = board_efforts;
pcolor(plot_efforts); shading interp;
title('Model Board Effort');
subplot(2,3,4)
plot_utility = zeros(22,22);
plot_utility(2:21,2:21) = board_values-board_efforts;
pcolor(plot_utility); shading interp;
title('Model Board Effort');
subplot(2,3,5)
plot(parameters.Steps)
title('Number of Steps to Target')
drawnow;
end