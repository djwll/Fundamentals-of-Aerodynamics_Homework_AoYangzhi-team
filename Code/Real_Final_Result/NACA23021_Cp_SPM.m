%**************************************************
%Time:2023年12月20日
%Puncton:实现NACA23021的压力分布系数的计算，使用面源法SPM
%People:敖洋智
%*************************************************

%利用xfoil导入XB,YB,以及参考Cp
Vinf = 1;
AoA = 20;
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

%计算A矩阵并加入库塔条件

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
b = -2*pi*Vinf*cos(Beta);
%加入库塔条件
Ku_Row = numPanel;
A(Ku_Row,:) = 0;
A(Ku_Row,1) = 1;
A(Ku_Row,end) = 1;
b(Ku_Row) = 0;
Lambda = A\b;
Cp = zeros(numPanel,1);
Vt = zeros(numPanel,1);
% 计算切向速度Vt和压力系数Cp
for i = 1:1:numPanel
    My_sum = 0;
    for j = 1:1:numPanel
         My_sum = My_sum + Lambda(j)/(2*pi)*J(i,j);
    end
    Vt(i) = Vinf*sin(Beta(i))+My_sum;
    Cp(i) = 1-(Vt(i)/Vinf)^2;
end 
%%画图

    cla;hold on ; grid on;
    set(gcf,'color','White');
    set(gca,'Fontsize',12);                                             
    midIndX = floor(length(Cp_0)/2);                                    
    midIndS = floor(length(Cp)/2);                                          
    pXu = plot(X_0(1:midIndX),-Cp_0(1:midIndX),'b-','LineWidth',2);   
    pXl = plot(X_0(midIndX+1:end),-Cp_0(midIndX+1:end),'r-',...        
                        'LineWidth',2);
    pVl = plot(XC(1:midIndS),-Cp(1:midIndS),'ks','MarkerFaceColor','r');     
    pVu = plot(XC(midIndS+1:end),-Cp(midIndS+1:end),'ks',...                 
                    'MarkerFaceColor','b');
    legend([pXu,pXl,pVu,pVl],...                                            % Show legend
               {'XFOIL Upper','XFOIL Lower','Ours Upper','Ours Lower'});
    xlabel('X_C')
    ylabel('Cp')