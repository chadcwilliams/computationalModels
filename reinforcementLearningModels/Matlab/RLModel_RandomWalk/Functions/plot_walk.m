function plot_walk(board_template,board_values,parameters)
subplot(1,3,1)
plot_template = zeros(22,22);
plot_template(2:21,2:21) = board_template;
pcolor(plot_template);
title('Start (Blue) and Target (Yellow) Locations');
subplot(1,3,2)
plot_values = zeros(22,22);
plot_values(2:21,2:21) = board_values;
pcolor(plot_values); shading interp;
title('Model Board Values');
drawnow;
subplot(1,3,3)
plot(parameters.Steps)
title('Number of Steps to Target')
end