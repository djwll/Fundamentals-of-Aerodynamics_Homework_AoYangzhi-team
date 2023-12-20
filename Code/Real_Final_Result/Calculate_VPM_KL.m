function [K,L] = Calculate_VPM_KL(XB,YB,XC,YC,S,Phi)
    %初始化K,L矩阵
    numPanel = length(XC);
    K = zeros(numPanel,numPanel);
    L = zeros(numPanel,numPanel);
    for i = 1:1:length(XC)
        for j = 1:1:length(YC)
            if(i ~= j)
                A = -(XC(i) - XB(j))*cos(Phi(j))-(YC(i)-YB(j))*sin(Phi(j));
                B = (XC(i) - XB(j))^2 + (YC(i)-YB(j))^2;
                Cn = -cos(Phi(i) - Phi(j));
                Dn = (XC(i) - XB(j))*cos(Phi(i))+(YC(i) - YB(j))*sin(Phi(i));
                Ct = -sin(Phi(i)-Phi(j));
                Dt = (XC(i) - XB(j))*sin(Phi(i)) - (YC(i)-YB(j))*cos(Phi(i));
                E  = sqrt(B-A^2);                                               
                if (~isreal(E))
                    E = 0;
                end
                K(i,j) = Cn/2*( log(S(j)^2 + 2*A*S(j) + B) - log(B)) + (Dn-A*Cn)/E*( atan2(S(j)+A,E) - atan2(A,E) );
                L(i,j) = Ct/2*( log(S(j)^2 + 2*A*S(j) + B) - log(B)) + (Dt-A*Ct)/E*( atan2(S(j)+A,E) - atan2(A,E) );
            end
        end
    end
end