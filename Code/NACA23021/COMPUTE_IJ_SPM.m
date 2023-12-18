function [I,J] = COMPUTE_IJ_SPM(XC,YC,XB,YB,phi,S)
numPan = length(XC);                                                        

% 初始化向量
I = zeros(numPan,numPan);                                                   
J = zeros(numPan,numPan);                                                  

% 计算积分
for i = 1:1:numPan                                                         
    for j = 1:1:numPan                                                     
        if (j ~= i)                                                         
            %计算中间变量
            A  = -(XC(i)-XB(j))*cos(phi(j))-(YC(i)-YB(j))*sin(phi(j));     
            B  = (XC(i)-XB(j))^2+(YC(i)-YB(j))^2;                          
            Cn = sin(phi(i)-phi(j));                                       
            Dn = -(XC(i)-XB(j))*sin(phi(i))+(YC(i)-YB(j))*cos(phi(i));     
            Ct = -cos(phi(i)-phi(j));                                     
            Dt = (XC(i)-XB(j))*cos(phi(i))+(YC(i)-YB(j))*sin(phi(i));      
            E  = sqrt(B-A^2);                                              
            if (~isreal(E))
                E = 0;
            end
            
            % 计算I，法向速度
            term1  = 0.5*Cn*log((S(j)^2+2*A*S(j)+B)/B);                     
            term2  = ((Dn-A*Cn)/E)*(atan2((S(j)+A),E) - atan2(A,E));       
            I(i,j) = term1 + term2;                                         
            
            % 计算J，切向速度
            term1  = 0.5*Ct*log((S(j)^2+2*A*S(j)+B)/B);                    
            term2  = ((Dt-A*Ct)/E)*(atan2((S(j)+A),E) - atan2(A,E));       
            J(i,j) = term1 + term2;                                        
        end
        %判断IJ的为赋值的部分，全部给零
        if (isnan(I(i,j)) || isinf(I(i,j)) || ~isreal(I(i,j)))
            I(i,j) = 0;
        end
        if (isnan(J(i,j)) || isinf(J(i,j)) || ~isreal(J(i,j)))
            J(i,j) = 0;
        end
    end
end
