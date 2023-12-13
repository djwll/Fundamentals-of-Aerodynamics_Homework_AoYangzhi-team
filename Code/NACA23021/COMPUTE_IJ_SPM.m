function [I,J] = COMPUTE_IJ_SPM(XC,YC,XB,YB,phi,S)
numPan = length(XC);                                                        % Number of panels/control points

% 初始化向量
I = zeros(numPan,numPan);                                                   % Initialize I integral matrix
J = zeros(numPan,numPan);                                                   % Initialize J integral matrix

% 计算积分
for i = 1:1:numPan                                                          % Loop over i panels
    for j = 1:1:numPan                                                      % Loop over j panels
        if (j ~= i)                                                         % If the i and j panels are not the same
            %计算中间变量
            A  = -(XC(i)-XB(j))*cos(phi(j))-(YC(i)-YB(j))*sin(phi(j));      % A term
            B  = (XC(i)-XB(j))^2+(YC(i)-YB(j))^2;                           % B term
            Cn = sin(phi(i)-phi(j));                                        % C term (normal)
            Dn = -(XC(i)-XB(j))*sin(phi(i))+(YC(i)-YB(j))*cos(phi(i));      % D term (normal)
            Ct = -cos(phi(i)-phi(j));                                       % C term (tangential)
            Dt = (XC(i)-XB(j))*cos(phi(i))+(YC(i)-YB(j))*sin(phi(i));       % D term (tangential)
            E  = sqrt(B-A^2);                                               % E term
            if (~isreal(E))
                E = 0;
            end
            
            % 计算I，法向速度
            term1  = 0.5*Cn*log((S(j)^2+2*A*S(j)+B)/B);                     % First term in I equation
            term2  = ((Dn-A*Cn)/E)*(atan2((S(j)+A),E) - atan2(A,E));        % Second term in I equation
            I(i,j) = term1 + term2;                                         % Compute I integral
            
            % 计算J，切向速度
            term1  = 0.5*Ct*log((S(j)^2+2*A*S(j)+B)/B);                     % First term in J equation
            term2  = ((Dt-A*Ct)/E)*(atan2((S(j)+A),E) - atan2(A,E));        % Second term in J equation
            J(i,j) = term1 + term2;                                         % Compute J integral
        end
        
        if (isnan(I(i,j)) || isinf(I(i,j)) || ~isreal(I(i,j)))
            I(i,j) = 0;
        end
        if (isnan(J(i,j)) || isinf(J(i,j)) || ~isreal(J(i,j)))
            J(i,j) = 0;
        end
    end
end
