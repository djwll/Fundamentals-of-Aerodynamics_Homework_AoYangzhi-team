%************************************************
%Time:2023年12月15日
%Puncton:利用面源法和涡面法结合法实现Cp的计算
%People:敖洋智
%*************************************************

function [X_0,Y_0,XB,YB,Cp_0,Cp,XC] = SPVP_Cp(nodes,AoA)
%% 利用xfoil导入XB,YB,以及参考Cp
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
[I,J] = Calculate_SPM_IJ(XB,YB,XC,YC,S,Phi);
[K,L] = Calculate_VPM_KL(XB,YB,XC,YC,S,Phi);

%计算A矩阵
A = zeros(numPanel,numPanel);
for i = 1:1:numPanel
    for j = 1:1:numPanel
        if(i == j)
            A(i,j) = pi;
        else
            A(i,j) = I(i,j);
        end
    end
end
for j = 1:1:numPanel 
    A(numPanel + 1,j)  = J(1,j) + J(numPanel,j);
end
A(numPanel + 1,numPanel + 1) = 2*pi - sum(L(1,:))-sum(L(numPanel,:));
b = -2*pi*Vinf*cos(Beta);
b(numPanel+1) = -2*pi*Vinf*(sin(Beta(1)) + sin(Beta(end)));
for i = 1:1:numPanel
    My_sum_3 = 0;
    for j= 1:1:numPanel
        if(i~=j)
        My_sum_3 = My_sum_3 - K(i,j);
        end
    end
    A(i,numPanel+1) = My_sum_3;
end
Result = A\b;
Lambda = Result(1:end-1);
Gamma = Result(end);

%计算切向速度
Vt = zeros(numPanel,1);
Cp = zeros(numPanel,1);
for i = 1:1:numPanel
    My_sum_1 = 0;
    My_sum_2 = 0;
    for j = 1:1:numPanel
         My_sum_1 = My_sum_1 + Lambda(j)/(2*pi)*J(i,j);
         My_sum_2 = My_sum_2 - Gamma/(2*pi)*L(i,j);
    end
    Vt(i) = Vinf*sin(Beta(i))+ My_sum_2 + My_sum_1 + Gamma/2;
    Cp(i) = 1 - (Vt(i)/Vinf)^2;
end

end