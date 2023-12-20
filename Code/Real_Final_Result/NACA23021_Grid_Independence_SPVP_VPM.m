%**************************************************
%Time:2023年12月20日
%Puncton:验证SPVP和VPM进行网格无关性的验证
%People:敖洋智
%*************************************************

%将从Nodes = 50，100，150，200，250，300，350，400，450进行网格无关性的验证
Nodes= [50:50:450];
AoA = 10;

%VPM的网格无关性的验证
figure("Name",'VPM')
for i = 1:1:length(Nodes)
    subplot(3,3,i)
    subtitle(['控制点数为',num2str(Nodes(i))])
    [X_0,Y_0,XB,YB,Cp_0,Cp,XC]  = VPM_Cp(Nodes(i),AoA);
    My_plot_Cp(X_0,Cp_0,Cp,XC);
end

%SPVP的网格无关性的验证
figure("Name",'SPVP')
for i = 1:1:length(Nodes)
    subplot(3,3,i)
    subtitle(['控制点数为',num2str(Nodes(i))])
    [X_0,Y_0,XB,YB,Cp_0,Cp,XC]  = SPVP_Cp(Nodes(i),AoA);
    My_plot_Cp(X_0,Cp_0,Cp,XC);
end