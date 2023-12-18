
% 使用Xfoil导入数据


NACA = '23021';
nodes = '200';
AoA = '15';
save_airfoil = 'airfoil.txt';
save_Cp = 'Cp.txt';
if exist(save_airfoil,'file')
    delete(save_airfoil);
end
if exist(save_Cp,'file')
    delete(save_Cp);
end

fid = fopen('xfoil_input.txt','w');

fprintf(fid,['NACA ' NACA '\n']);
fprintf(fid,'PPAR\n');
fprintf(fid,['N ' nodes '\n']);
fprintf(fid,'\n\n');
fprintf(fid,['PSAV ' save_airfoil '\n']);

%load Xfoil Cp
fprintf(fid,'OPER\n');
fprintf(fid,['Alfa ' AoA '\n']);
fprintf(fid,['CPWR ' save_Cp]);


fclose(fid);

cmd = 'xfoil.exe < xfoil_input.txt';
[status,result] = system(cmd);

%转化为自己的数据
a = load(save_airfoil);
saveFLnmCP = save_Cp;
fidCp = fopen(saveFLnmCP);

dataBuffer = textscan(fidCp,'%f %f %f','CollectOutput',3, ...
    'Delimiter','','HeaderLines',3);
fclose(fidCp);

X_0 = dataBuffer{1,1}(:,1);
Y_0 = dataBuffer{1,1}(:,2);
Cp_0 = dataBuffer{1,1}(:,3);

XB = flip(a(:,1));
YB = flip(a(:,2));

%% 进行相关计算
% 边界点和板子数量
numPts = length(XB);                                                        
numPan = numPts - 1; 
AoA = 15;
Vinf = 1;


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

% Right column of A matrix
for i = 1:1:numPan                                                          
    A(i,numPan+1) = -sum(K(i,:));                                           
end

% Bottom row of A matrix (Kutta condition)
for j = 1:1:numPan                                                          
    A(numPan+1,j) = (J(1,j) + J(numPan,j));                                 
end
A(numPan+1,numPan+1) = -sum(L(1,:) + L(numPan,:)) + 2*pi; 

%计算b向量
b = zeros(numPan,1);                                                        
for i = 1:1:numPan                                                          
    b(i) = -Vinf*2*pi*cos(beta(i));                                         
end

%加入b的库塔条件
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

%% 分别使用压强法和茹科夫斯基定理计算升力系数
%压强积分法
CN=-Cp.*S.*sin(beta);
CA=-Cp.*S.*cos(beta);
CL_Interal = sum(CN.*cosd(AoA)) - sum(CA.*sind(AoA));  
CL_Ku = sum(gamma.*S)*2;
CM = sum(Cp.*(XC).*S.*cos(phi));
fprintf('\t压强法升力系数 : %2.4f\n',CL_Interal); 
fprintf('\t茹科夫斯基法 : %2.4f\n',CL_Ku); 
fprintf('\tLE力矩 : %2.4f\n',CM);  

%% 验证上下表面质点同时到达后缘
midIndX = floor(length(Cp_0)/2);                                    
length(S)
length(Vt)
Tu = S(1:midIndX)./-Vt(1:midIndX);
Tl = S(midIndX+1:end)./Vt(midIndX+1:end);
sum(Tu)
sum(Tl)

%% Cp 计算
figure(3);                                                              
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
