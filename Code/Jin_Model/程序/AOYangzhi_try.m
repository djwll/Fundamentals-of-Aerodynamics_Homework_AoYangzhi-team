%% Load DATA FILE : AIRFOIL
saveFLnmAF = 'Save_Airfoil_160.txt';
fidAirfoil = fopen(saveFLnmAF);

dataBuffer = textscan(fidAirfoil,'%f %f','CollectOutput',1, ...
    'Delimiter','','HeaderLines',0);
fclose(fidAirfoil);

XB = dataBuffer{1}(:,1);
YB = dataBuffer{1}(:,2);

%% Read DATA FILE
saveFLnmCP = 'Save_cp.txt';
fidCp = fopen(saveFLnmCP);

dataBuffer = textscan(fidCp,'%f %f %f','CollectOutput',3, ...
    'Delimiter','','HeaderLines',3);
fclose(fidCp);

X_0 = dataBuffer{1,1}(:,1);
Y_0 = dataBuffer{1,1}(:,2);
Cp_0 = dataBuffer{1,1}(:,3);

%% Plot Data
XB_U = XB(YB>=0);
XB_L = XB(YB<0);
YB_U = YB(YB>=0);
YB_L = YB(YB<0);
Cp_U = Cp_0(YB>=0);
Cp_L = Cp_0(YB<0);
X_U = X_0(YB>=0);
X_L = X_0(YB<0);

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
