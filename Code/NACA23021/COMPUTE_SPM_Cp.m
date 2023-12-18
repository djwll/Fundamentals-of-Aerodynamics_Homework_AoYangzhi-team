function [Cp,XC] = COMPUTE_SPM_Cp(XB,YB,angle_input)
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
    XC(i)   = 0.5*(XB(i)+XB(i+1));                                          %控制点为边界点的中点
    YC(i)   = 0.5*(YB(i)+YB(i+1));                                          
    dx      = XB(i+1)-XB(i);                                              
    dy      = YB(i+1)-YB(i);                                               
    S(i)    = (dx^2 + dy^2)^0.5;                                          
	phiD(i) = atan2d(dy,dx);                                                
    if (phiD(i) < 0)                                                        %转化为正值
        phiD(i) = phiD(i) + 360;
    end
end

% 计算角度，并加入攻角
deltaD             = phiD + 90;                                             
betaD              = deltaD - AoA;                                          
betaD(betaD > 360) = betaD(betaD > 360) - 360;                              

%将角度转化为弧度制
phi  = phiD.*(pi/180);                                                      
beta = betaD.*(pi/180);                                                    

[I,J] = COMPUTE_IJ_SPM(XC,YC,XB,YB,phi,S);                                  %进行积分运算

A = zeros(numPan,numPan);                                                  %构建A矩阵，A矩阵和I矩阵还是有部分差别的
for i = 1:1:numPan                                                          
    for j = 1:1:numPan                                                     
        if (i == j)                                                         
            A(i,j) = pi;                                                    
        else                                                                
            A(i,j) = I(i,j);                                                
        end
    end
end

b = zeros(numPan,1);                                                        
for i = 1:1:numPan-1                                                          
    b(i) = -Vinf*2*pi*cos(beta(i));                                         
end
%加入库塔条件
b(numPan) = 0;                                                         
for j = 1:1:numPan                                                     
    if j==1||j==numPan 
        A(numPan,j) = 1;
    else
        A(numPan,j)=0;
    end
end

lambda  = A\b;                                                              
Vt = zeros(numPan,1);                                                       
Cp = zeros(numPan,1);                                                       
for i = 1:1:numPan                                                          
    addVal  = 0;                                                           
    for j = 1:1:numPan                                                     
        addVal = addVal + (lambda(j)/(2*pi))*(J(i,j));                      
    end
    
    Vt(i) = Vinf*sin(beta(i)) + addVal;                                     
    Cp(i) = 1-(Vt(i)/Vinf)^2;                                               
end
end