% 设置时间步长和时间步数
deltaT = 0.1;
timeSteps = 100;

% 初始流体质点的位置数组
xFluid = zeros(timeSteps, numPan);
yFluid = zeros(timeSteps, numPan);

% 将控制点的初始位置赋给流体质点数组
xFluid(1, :) = XC;
yFluid(1, :) = YC;

% 根据速度更新每个流体质点的位置
for t = 2:timeSteps
    for i = 1:numPan
        xFluid(t, i) = xFluid(t-1, i) + Vt(i) * cos(phi(i)) * deltaT;
        yFluid(t, i) = yFluid(t-1, i) + Vt(i) * sin(phi(i)) * deltaT;
    end
end

% 创建时间向量
timeVector = 1:timeSteps;

% 绘制翼型
figure;
plot(XB, YB, 'k-', 'LineWidth', 2);
hold on;

% 绘制每个流体质点的轨迹
for i = 1:numPan
    plot(xFluid(:, i), yFluid(:, i), '-o', 'DisplayName', sprintf('Point %d', i));
end

% 添加标签和标题
xlabel('横向位置');
ylabel('纵向位置');
title('翼型和流体质点轨迹');
legend('翼型', 'Location', 'NorthEast');
grid on;
hold off;
