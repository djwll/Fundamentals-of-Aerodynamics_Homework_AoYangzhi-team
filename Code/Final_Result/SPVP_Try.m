%% 利用xfoil导入XB,YB,以及参考Cp
Vinf = 1;
AoA = 15;
nodes = 300;
[X_0,Y_0,XB,YB,Cp_0] = NACA23021_Input(nodes,0);
[X_1,Y_0,XB,YB,Cp_5] = NACA23021_Input(nodes,AoA);
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

Cp = SPVP_Cp(nodes,AoA);
My_plot_Cp(X_0,Cp_0,Cp,XC)

Cp = SPVP_Cp(nodes,0);
Cp_2 = VPM_Cp(nodes,0);
Cp_3 = SPVP_Cp(nodes,AoA);
Cp_4 = VPM_Cp(nodes,AoA);
subplot(2,2,1)
subtitle("SPVP-AoA-0")
My_plot_Cp(X_0,Cp_0,Cp,XC)
subplot(2,2,2)
subtitle("VPM-AoA-0")
My_plot_Cp(X_0,Cp_0,Cp_2,XC)
subplot(2,2,3)
subtitle("SPVP-AoA-10")
My_plot_Cp(X_1,Cp_5,Cp_3,XC)
subplot(2,2,4)
subtitle("VPM-AoA-10")
My_plot_Cp(X_1,Cp_5,Cp_4,XC)