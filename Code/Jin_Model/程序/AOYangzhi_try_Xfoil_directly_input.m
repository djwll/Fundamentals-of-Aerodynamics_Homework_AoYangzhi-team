%% 直接使用Xfoil导入数据


NACA = '23021';
nodes = '200';
AoA = '0';
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

%% 转化为自己的数据
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

XB_U = XB(YB>=0);
XB_L = XB(YB<0);
YB_U = YB(YB>=0);
YB_L = YB(YB<0);
Cp_U = Cp_0(YB>=0);
Cp_L = Cp_0(YB<0);
X_U = X_0(YB>=0);
X_L = X_0(YB<0);
%% plot
figure(1);
cla;hold on ; grid off;
set(gcf,'color','White');
set(gca,'Fontsize',12);
plot(XB_U,YB_U,'b.-');
plot(XB_L,YB_L,'r.-');
xlabel('X Coordinate');
ylabel('Y Coordinate');
axis equal

figure(2);
cla;hold on ; grid on;
set(gcf,'color','White');
set(gca,'Fontsize',12);
plot(X_U,-Cp_U,'b.-');
plot(X_L,-Cp_L,'r.-');
xlabel('X Coordinate');
ylabel('Y Coordinate');