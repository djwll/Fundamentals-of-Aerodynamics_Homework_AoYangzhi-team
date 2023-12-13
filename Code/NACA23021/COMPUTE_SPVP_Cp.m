function [Cp,XC] = COMPUTE_SPVP_Cp(X_0,Y_0,Cp_0,XB,YB,angle_input)
% 进行相关计算
% 边界点和板子数量
numPts = length(XB);                                                        
numPan = numPts - 1; 
Vinf = 1;
AoA = angle_input;


%初始化相关变量
XC   = zeros(numPan,1);                                                     
YC   = zeros(numPan,1);                                                     
S    = zeros(numPan,1);                                                     
phiD = zeros(numPan,1); 

%计算板子的几何特征
for i = 1:1:numPan                                                          % Loop over all panels
    XC(i)   = 0.5*(XB(i)+XB(i+1));                                          % X-value of control point
    YC(i)   = 0.5*(YB(i)+YB(i+1));                                          % Y-value of control point
    dx      = XB(i+1)-XB(i);                                                % Change in X between boundary points
    dy      = YB(i+1)-YB(i);                                                % Change in Y between boundary points
    S(i)    = (dx^2 + dy^2)^0.5;                                            % Length of the panel
    phiD(i) = atan2d(dy,dx);                                                % Angle of the panel (positive X-axis to inside face) [deg]
    if (phiD(i) < 0)                                                        % Make all panel angles positive [deg]
        phiD(i) = phiD(i) + 360;
    end
end


% 将攻角考虑进去
deltaD             = phiD + 90;                                             % Angle from positive X-axis to outward normal vector [deg]
betaD              = deltaD - AoA;                                          % Angle between freestream vector and outward normal vector [deg]
betaD(betaD > 360) = betaD(betaD > 360) - 360; 
% 将角度转化为弧度制
phi  = phiD.*(pi/180);                                                      % Convert from [deg] to [rad]
beta = betaD.*(pi/180); 

% 计算相关的积分项,调取函数，得到IJ，KL
[I,J] = COMPUTE_IJ_SPM(XC,YC,XB,YB,phi,S);                                  % Call COMPUTE_IJ_SPM function (Refs [2] and [3])
[K,L] = COMPUTE_KL_VPM(XC,YC,XB,YB,phi,S); 


%计算A矩阵
A = zeros(numPan,numPan);                                                   % Initialize the A matrix
for i = 1:1:numPan                                                          % Loop over all i panels
    for j = 1:1:numPan                                                      % Loop over all j panels
        if (j == i)                                                         % If the panels are the same
            A(i,j) = pi;                                                    % Set A equal to pi
        else                                                                % If panels are not the same
            A(i,j) = I(i,j);                                                % Set A equal to I
        end
    end
end

for i = 1:1:numPan                                                          % Loop over all i panels (rows)
    A(i,numPan+1) = -sum(K(i,:));                                           % Add gamma term to right-most column of A matrix
end

for j = 1:1:numPan                                                          % Loop over all j panels (columns)
    A(numPan+1,j) = (J(1,j) + J(numPan,j));                                 % Source contribution of Kutta condition equation
end
A(numPan+1,numPan+1) = -sum(L(1,:) + L(numPan,:)) + 2*pi; 

%计算b向量
b = zeros(numPan,1);                                                        % Initialize the b array
for i = 1:1:numPan                                                          % Loop over all i panels (rows)
    b(i) = -Vinf*2*pi*cos(beta(i));                                         % Compute RHS array
end

%加入b的库塔条件
b(numPan+1) = -Vinf*2*pi*(sin(beta(1)) + sin(beta(numPan))); 
%计算结果
resArr = A\b;

%将λ和Γ分离出来
lambda = resArr(1:end-1);                                                   % All panel source strenths
gamma  = resArr(end); 


%计算速度和压力系数
Vt = zeros(numPan,1);                                                       % Initialize tangential velocity
Cp = zeros(numPan,1);                                                       % Initialize pressure coefficient
for i = 1:1:numPan
    term1 = Vinf*sin(beta(i));                                              % Uniform flow term
    term2 = (1/(2*pi))*sum(lambda.*J(i,:)');                                % Source panel terms when j is not equal to i
    term3 = gamma/2;                                                        
    term4 = -(gamma/(2*pi))*sum(L(i,:));                                    
    
    Vt(i) = term1 + term2 + term3 + term4;                                  
    Cp(i) = 1-(Vt(i)/Vinf)^2;                                               
end
end