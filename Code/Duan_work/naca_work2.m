% 定义攻角范围
alpha_range = -5:1:15;
rouf=1.29;
wingArea=1;
Vinf=1;

% 初始化结果数组
cl_results = zeros(size(alpha_range));
cm_results = zeros(size(alpha_range));

% 计算不同攻角下的Cl和Cm
for i = 1:length(alpha_range)
    % 计算gamma
    gamma = calculateGamma(alpha_range(i), XB, YB, Vinf);

    % 计算Cl和Cm
    [alpha, cl, cm] = calculateCoefficients(gamma, S, XC, rouf, Vinf, wingArea);

    % 存储结果
    cl_results(i) = cl;
    cm_results(i) = cm;
end

% 绘制结果
figure;
plot(alpha_range, cl_results, '-o', 'DisplayName', 'Cl');
hold on;
plot(alpha_range, cm_results, '-s', 'DisplayName', 'Cm');
xlabel('攻角 (degrees)');
ylabel('系数值');
title('不同攻角下的升力系数和力矩系数');
legend('show');
grid on;
function gamma = calculateGamma(alpha, XB, YB, Vinf)
    numPts = length(XB);
    numPan = numPts - 1;

    % Initialize variables
    XC   = zeros(numPan, 1);
    YC   = zeros(numPan, 1);
    S    = zeros(numPan, 1);
    phiD = zeros(numPan, 1);

    % Compute panel geometry
    for i = 1:numPan
        XC(i)   = 0.5 * (XB(i) + XB(i+1));
        YC(i)   = 0.5 * (YB(i) + YB(i+1));
        dx      = XB(i+1) - XB(i);
        dy      = YB(i+1) - YB(i);
        S(i)    = sqrt(dx^2 + dy^2);
        phiD(i) = atan2d(dy, dx);
        if phiD(i) < 0
            phiD(i) = phiD(i) + 360;
        end
    end

    % Include angle of attack
    deltaD             = phiD + 90;
    betaD              = deltaD - alpha;
    betaD(betaD > 360) = betaD(betaD > 360) - 360;

    % Convert angles to radians
    phi  = phiD * (pi/180);
    beta = betaD * (pi/180);

    % Compute integrals
    [I, J] = COMPUTE_IJ_SPM(XC, YC, XB, YB, phi, S);
    [K, L] = COMPUTE_KL_VPM(XC, YC, XB, YB, phi, S);

    % Construct coefficient matrix A
    A = zeros(numPan, numPan);
    for i = 1:numPan
        for j = 1:numPan
            if j == i
                A(i, j) = pi;
            else
                A(i, j) = I(i, j);
            end
        end
    end
    for i = 1:numPan
        A(i, numPan+1) = -sum(K(i, :));
    end
    for j = 1:numPan
        A(numPan+1, j) = (J(1, j) + J(numPan, j));
    end
    A(numPan+1, numPan+1) = -sum(L(1, :) + L(numPan, :)) + 2*pi;

    % Compute right-hand side vector b
    b = zeros(numPan, 1);
    for i = 1:numPan
        b(i) = -Vinf * 2 * pi * cos(beta(i));
    end
    b(numPan+1) = -Vinf * 2 * pi * (sin(beta(1)) + sin(beta(numPan)));

    % Solve for gamma
  resArr = A\b;
  gamma  = resArr(end);
end
function [alpha, cl, cm] = calculateCoefficients(gamma, S, XC, rouf, Vinf, wingArea)
    % 计算每个控制点相对于翼型前缘的距离
    x_from_le = XC - min(XC);

    % 计算总的涡量
    vortexPanelStrength = gamma .* S;
    totalCirculation = trapz(vortexPanelStrength);

    % 计算升力
    L = rouf * Vinf * totalCirculation;

    % 计算升力系数
    cl = L / (0.5 * rouf * Vinf^2 * wingArea);

    % 计算每个板子的升力即dL1
    dL1 = gamma .* S;

    % 计算局部力矩 dM
    dM = dL1 .* x_from_le;

    % 计算总力矩
    M = trapz(x_from_le, dM);

    % 计算力矩系数
    cm = M / (0.5 * rouf * Vinf^2 * wingArea * 1);

    % 计算攻角
    alpha = atan2d(L, M);  % 将弧度转为角度
end
