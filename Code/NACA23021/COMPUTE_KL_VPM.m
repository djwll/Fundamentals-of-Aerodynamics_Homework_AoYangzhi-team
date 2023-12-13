function [K,L] = COMPUTE_KL_VPM(XC,YC,XB,YB,phi,S)

% 板子的数量
numPan = length(XC);                                                        % Number of panels

% 初始化数组
K = zeros(numPan,numPan);                                                   % Initialize K integral matrix
L = zeros(numPan,numPan);                                                   % Initialize L integral matrix

% 计算积分
for i = 1:1:numPan                                                          % Loop over i panels
    for j = 1:1:numPan                                                      % Loop over j panels
        if (j ~= i)                                                         % If panel j is not the same as panel i
            A  = -(XC(i)-XB(j))*cos(phi(j))-(YC(i)-YB(j))*sin(phi(j));      % A term
            B  = (XC(i)-XB(j))^2+(YC(i)-YB(j))^2;                           % B term
            Cn = -cos(phi(i)-phi(j));                                       % C term (normal)
            Dn = (XC(i)-XB(j))*cos(phi(i))+(YC(i)-YB(j))*sin(phi(i));       % D term (normal)
            Ct = sin(phi(j)-phi(i));                                        % C term (tangential)
            Dt = (XC(i)-XB(j))*sin(phi(i))-(YC(i)-YB(j))*cos(phi(i));       % D term (tangential)
            E  = sqrt(B-A^2);                                               % E term
            if (~isreal(E))
                E = 0;
            end
            
            % 计算K值
            term1  = 0.5*Cn*log((S(j)^2+2*A*S(j)+B)/B);                     % First term in K equation
            term2  = ((Dn-A*Cn)/E)*(atan2((S(j)+A),E)-atan2(A,E));          % Second term in K equation
            K(i,j) = term1 + term2;                                         % Compute K integral
            
            % 计算L值
            term1  = 0.5*Ct*log((S(j)^2+2*A*S(j)+B)/B);                     % First term in L equation
            term2  = ((Dt-A*Ct)/E)*(atan2((S(j)+A),E)-atan2(A,E));          % Second term in L equation
            L(i,j) = term1 + term2;                                         % Compute L integral
        end
        if (isnan(K(i,j)) || isinf(K(i,j)) || ~isreal(K(i,j)))
            K(i,j) = 0;
        end
        if (isnan(L(i,j)) || isinf(L(i,j)) || ~isreal(L(i,j)))
            L(i,j) = 0;
        end
    end
end
