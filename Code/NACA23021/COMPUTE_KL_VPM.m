function [K,L] = COMPUTE_KL_VPM(XC,YC,XB,YB,phi,S)

% 板子的数量
numPan = length(XC);                                                       

% 初始化数组
K = zeros(numPan,numPan);                                                   
L = zeros(numPan,numPan);                                                  

% 计算积分
for i = 1:1:numPan                                                          
    for j = 1:1:numPan                                                      
        if (j ~= i)                                                         
            A  = -(XC(i)-XB(j))*cos(phi(j))-(YC(i)-YB(j))*sin(phi(j));      
            B  = (XC(i)-XB(j))^2+(YC(i)-YB(j))^2;                          
            Cn = -cos(phi(i)-phi(j));                                       
            Dn = (XC(i)-XB(j))*cos(phi(i))+(YC(i)-YB(j))*sin(phi(i));       
            Ct = sin(phi(j)-phi(i));                                        
            Dt = (XC(i)-XB(j))*sin(phi(i))-(YC(i)-YB(j))*cos(phi(i));       
            E  = sqrt(B-A^2);                                              
            if (~isreal(E))
                E = 0;
            end
            
            % 计算K值
            term1  = 0.5*Cn*log((S(j)^2+2*A*S(j)+B)/B);                     
            term2  = ((Dn-A*Cn)/E)*(atan2((S(j)+A),E)-atan2(A,E));          
            K(i,j) = term1 + term2;                                         
            
            % 计算L值
            term1  = 0.5*Ct*log((S(j)^2+2*A*S(j)+B)/B);                     
            term2  = ((Dt-A*Ct)/E)*(atan2((S(j)+A),E)-atan2(A,E));          
            L(i,j) = term1 + term2;                                         
        end
        if (isnan(K(i,j)) || isinf(K(i,j)) || ~isreal(K(i,j)))
            K(i,j) = 0;
        end
        if (isnan(L(i,j)) || isinf(L(i,j)) || ~isreal(L(i,j)))
            L(i,j) = 0;
        end
    end
end
