function plot_output(model_values,actualPayouts)
subplot(4,2,1)
plot(model_values(1,:)*100);hold on
plot(actualPayouts{1,1}(1,:));

subplot(4,2,2)
scatter(model_values(1,:)*100,actualPayouts{1,1}(1,:));
lsline

subplot(4,2,3)
plot(model_values(2,:)*100);hold on
plot(actualPayouts{1,1}(2,:));

subplot(4,2,4)
scatter(model_values(2,:)*100,actualPayouts{1,1}(2,:));
lsline

subplot(4,2,5)
plot(model_values(3,:)*100);hold on
plot(actualPayouts{1,1}(3,:));

subplot(4,2,6)
scatter(model_values(3,:)*100,actualPayouts{1,1}(3,:));
lsline

subplot(4,2,7)
plot(model_values(4,:)*100);hold on
plot(actualPayouts{1,1}(4,:));

subplot(4,2,8)
scatter(model_values(4,:)*100,actualPayouts{1,1}(4,:));
lsline
end