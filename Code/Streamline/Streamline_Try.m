%%  计算λ和γ
% 利用xfoil导入XB,YB,以及参考Cp
Vinf = 1;
nodes = 200;
AoA = 0;
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

%得出相关的结果
Lambda = Result(1:end-1);
Gamma = Result(end);

% 初始化例子点
XP = [0 ,0];
YP = [0, 0.01];
figure
scatterPlot = scatter(nan,nan,'filled');

axis([0 1.2 -0.5 0.5])
for i = 1:1:13
    for j = 1:1:length(XP)
        [Mx,My] = STREAMLINE_SPM(XP(j),YP(j),XB,YB,Phi,S);                    
        [Nx,Ny] = STREAMLINE_VPM(XP(j),YP(j),XB,YB,Phi,S);                    
                    
        [in,on] = inpolygon(XP(j),YP(j),XB,YB);
        if (in == 1 || on == 1||XP(j)>=1)                                         
                        Vx = 0;                                               
                        Vy = 0;                                               
        else                                                            
                        Vx= Vinf*cosd(AoA) + sum(Lambda.*Mx./(2*pi)) + ...    
                                    sum(-Gamma.*Nx./(2*pi));
                        Vy = Vinf*sind(AoA) + sum(Lambda.*My./(2*pi)) + ...    
                                    sum(-Gamma.*Ny./(2*pi));
        end
        XP(j) = XP(j) + Vx*0.1;
        YP(j) = YP(j) + Vy*0.1;
        
        
    end
    
    set(scatterPlot,'XData',XP,'YData',YP)
    hold on 
    plot(XB,YB,'-b')
    drawnow;
    pause(1);
end                                     


%% figure
% scatterPlot = scatter(nan,nan,'filled');
% 
% axis([0 10 0 10]);
% 
% for i = 1:10
%     x = rand(1,5)*10;
%     y = rand(1,5)*10;
%     set(scatterPlot,'XData',x,'YData',y)
%     drawnow;
%     pause(1);
% end