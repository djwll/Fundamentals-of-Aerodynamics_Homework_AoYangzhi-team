function [X_0,Y_0,Cp_0,XB,YB] = NACA23021_Input(nodes,AoA)
% 使用Xfoil导入数据


NACA = '23021';
nodes = num2str(nodes,'%.0f');
AoA_xfoil = num2str(AoA);
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
fprintf(fid,['Alfa ' AoA_xfoil '\n']);
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
end