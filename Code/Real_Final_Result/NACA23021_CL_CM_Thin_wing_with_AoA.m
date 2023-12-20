%**************************************************
%Time:2023年12月20日
%Puncton:使用SPVP计算得到的Cp利用压强积分计算升力系数和力矩系数，并和薄翼理论进行对比
%People:敖洋智
%*************************************************

figure(1);
AoA = -5:1:15;
CL=zeros(length(AoA),1);
CM=zeros(length(AoA),1);
for i = 1:1:length(AoA)
    [CL_My,CM_My] = COMPUTE_CL_CM(AoA(i));
    CL(i) = CL_My;
    CM(i) = CM_My;
end


cla;hold on ; grid on;
set(gcf,'color','White');
set(gca,'Fontsize',12); 
plot(AoA,CL,'ks','MarkerFaceColor','r');
hold on 
plot(AoA,2*pi*AoA/180*pi,'ks','MarkerFaceColor','b');
legend('CLAoA','CL-Thin-wing')
figure(2)
plot(AoA,CM,'ks','MarkerFaceColor','r');
hold on 
plot(AoA,-2*pi*AoA/180*pi/4,'ks','MarkerFaceColor','b');
legend('CMAoA','CM-Thin-wing')