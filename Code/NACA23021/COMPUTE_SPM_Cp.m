function [Cp,XC] = COMPUTE_SPM_Cp(X_0,Y_0,Cp_0,XB,YB,angle_input)
numPts = length(XB);                                                      
numPan = numPts - 1; 
% 初始化变量
XC   = zeros(numPan,1);                                                     
YC   = zeros(numPan,1);                                                     
S    = zeros(numPan,1);                                                    
phiD = zeros(numPan,1);  
Vinf = 1;
AoA = angle_input;

% 得到几何特征
for i = 1:1:numPan                                                          
    XC(i)   = 0.5*(XB(i)+XB(i+1));                                          
    YC(i)   = 0.5*(YB(i)+YB(i+1));                                          
    dx      = XB(i+1)-XB(i);                                              
    dy      = YB(i+1)-YB(i);                                               
    S(i)    = (dx^2 + dy^2)^0.5;                                          
	phiD(i) = atan2d(dy,dx);                                                
    if (phiD(i) < 0)                                                        
        phiD(i) = phiD(i) + 360;
    end
end

% 计算角度，并加入攻角
deltaD             = phiD + 90;                                             % Angle from positive X-axis to outward normal vector [deg]
betaD              = deltaD - AoA;                                          % Angle between freestream vector and outward normal vector [deg]
betaD(betaD > 360) = betaD(betaD > 360) - 360;                              % Make sure angles aren't greater than 360 [deg]

%将角度转化为弧度制
phi  = phiD.*(pi/180);                                                      % Convert from [deg] to [rad]
beta = betaD.*(pi/180);                                                     % Convert from [deg] to [rad]

[I,J] = COMPUTE_IJ_SPM(XC,YC,XB,YB,phi,S);                                  % Compute geometric integrals

A = zeros(numPan,numPan);                                                   % Initialize the A matrix
for i = 1:1:numPan                                                          % Loop over all i panels
    for j = 1:1:numPan                                                      % Loop over all j panels
        if (i == j)                                                         % If the panels are the same
            A(i,j) = pi;                                                    % Set A equal to pi
        else                                                                % If panels are not the same
            A(i,j) = I(i,j);                                                % Set A equal to geometric integral
        end
    end
end

b = zeros(numPan,1);                                                        % Initialize the b array
for i = 1:1:numPan                                                          % Loop over all panels
    b(i) = -Vinf*2*pi*cos(beta(i));                                         % Compute RHS array
end

lambda  = A\b;                                                              % Compute all source strength val
Vt = zeros(numPan,1);                                                       % Initialize tangential velocity array
Cp = zeros(numPan,1);                                                       % Initialize pressure coefficient array
for i = 1:1:numPan                                                          % Loop over all i panels
    addVal  = 0;                                                            % Reset the summation value to zero
    for j = 1:1:numPan                                                      % Loop over all j panels
        addVal = addVal + (lambda(j)/(2*pi))*(J(i,j));                      % Sum all tangential source panel terms
    end
    
    Vt(i) = Vinf*sin(beta(i)) + addVal;                                     % Compute tangential velocity by adding uniform flow term
    Cp(i) = 1-(Vt(i)/Vinf)^2;                                               % Compute pressure coefficient
end
end