function [Cp,XC] = COMPUTE_SPVP_Cp(XB,YB,angle_input)
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


% 将攻角考虑进去
deltaD             = phiD + 90;                                             
betaD              = deltaD - AoA;                                          
betaD(betaD > 360) = betaD(betaD > 360) - 360; 
% 将角度转化为弧度制
phi  = phiD.*(pi/180);                                                      
beta = betaD.*(pi/180); 

% 计算相关的积分项,调取函数，得到IJ，KL
[I,J] = COMPUTE_IJ_SPM(XC,YC,XB,YB,phi,S);                                  
[K,L] = COMPUTE_KL_VPM(XC,YC,XB,YB,phi,S); 


%计算A矩阵
A = zeros(numPan,numPan);                                                  
for i = 1:1:numPan                                                         
    for j = 1:1:numPan                                                      
        if (j == i)                                                        
            A(i,j) = pi;                                                    
        else                                                                
            A(i,j) = I(i,j);                                               
        end
    end
end

%加入库塔条件，并且拓展矩阵的维度
for i = 1:1:numPan                                                          
    A(i,numPan+1) = -sum(K(i,:));                                           
end

for j = 1:1:numPan                                                          
    A(numPan+1,j) = (J(1,j) + J(numPan,j));                                
end
A(numPan+1,numPan+1) = -sum(L(1,:) + L(numPan,:)) + 2*pi; 

%计算b向量
b = zeros(numPan,1);                                                       
for i = 1:1:numPan                                                        
    b(i) = -Vinf*2*pi*cos(beta(i));                                        
end


b(numPan+1) = -Vinf*2*pi*(sin(beta(1)) + sin(beta(numPan))); 
%计算结果
resArr = A\b;

%将λ和Γ分离出来
lambda = resArr(1:end-1);                                                   
gamma  = resArr(end); 


%计算速度和压力系数
Vt = zeros(numPan,1);                                                     
Cp = zeros(numPan,1);                                                      
for i = 1:1:numPan
    term1 = Vinf*sin(beta(i));                                             
    term2 = (1/(2*pi))*sum(lambda.*J(i,:)');                                
    term3 = gamma/2;                                                        
    term4 = -(gamma/(2*pi))*sum(L(i,:));                                    
    
    Vt(i) = term1 + term2 + term3 + term4;                                  
    Cp(i) = 1-(Vt(i)/Vinf)^2;                                               
end
end