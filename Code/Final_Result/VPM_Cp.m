function Cp = VPM_Cp(nodes,AoA)
Vinf = 1;
[X_0,Y_0,XB,YB,Cp_0] = NACA23021_Input(nodes,AoA);
%获取翼型的几何特征
numB = length(XB);
numPanel = numB - 1;
%初始化变量
XC = zeros(numPanel,1);
YC = zeros(numPanel,1);
S = zeros(numPanel,1);
PhiD = zeros(numPanel,1);

for i = 1:1:numPanel
    XC(i) = 0.5*(XB(i)+XB(i+1));
    YC(i) = 0.5*(YB(i)+YB(i+1));
    dx = XB(i+1)-XB(i);
    dy = YB(i+1)-YB(i);
    S(i) = (dx^2+dy^2)^0.5;
    PhiD(i) = atan2d(dy,dx);
    if (PhiD(i) < 0)                                                       
        PhiD(i) = PhiD(i) + 360;
    end
end

% β为自由来流与法向量的夹角、δ为X正轴与panel内部的夹角
deltaD             = PhiD + 90;                                             
betaD              = deltaD - AoA;                                          
betaD(betaD > 360) = betaD(betaD > 360) - 360; 

% 将角度转化为弧度制
Phi  = PhiD.*(pi/180);                                                  
Beta = betaD.*(pi/180); 

%计算积分项
[K,L] = Calculate_VPM_KL(XB,YB,XC,YC,S,Phi);
A = zeros(numPanel,numPanel);
for i = 1:1:numPanel
    for j = 1:1:numPanel
        if(i == j)
            A(i,j) = 0;
        else
            A(i,j) = -K(i,j);
        end
    end
end
b = -2*pi*Vinf*cos(Beta);

% 加入库塔条件
Ku_Row = numPanel + 1;
A(Ku_Row,:) = 0;
A(Ku_Row,1) = 1;
A(Ku_Row,numPanel) = 1;
b(Ku_Row) = 0; 
%计算Gamma值
Gamma = A\b;

Cp = zeros(numPanel,1);
Vt = zeros(numPanel,1);
% 计算切向速度Vt和压力系数Cp
for i = 1:1:numPanel
    My_sum = 0;
    for j = 1:1:numPanel
         My_sum = My_sum - Gamma(j)/(2*pi)*L(i,j);
    end
    Vt(i) = Vinf*sin(Beta(i))+My_sum+Gamma(i)/2;
    Cp(i) = 1-(Vt(i)/Vinf)^2;
end 
end