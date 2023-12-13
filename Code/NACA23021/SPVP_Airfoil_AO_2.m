%%调用函数，导入数据
AoA = 0;
nodes = 100:10:100+9*10;
figure("Name","SPM")
for i = 1:1:9
    [X_0,Y_0,Cp_0,XB,YB] = NACA23021_Input(nodes(i),AoA);
    [Cp,XC] = COMPUTE_SPM_Cp(X_0,Y_0,Cp_0,XB,YB,AoA);
    subplot(3,3,i)
    subtitle(['控制点数为',num2str(nodes(i))])
    My_plot(X_0,Cp_0,Cp,XC)
end
figure("Name","VPM")
for i = 1:1:9
    [X_0,Y_0,Cp_0,XB,YB] = NACA23021_Input(nodes(i),AoA);
    [Cp,XC] = COMPUTE_VPM_Cp(X_0,Y_0,Cp_0,XB,YB,AoA);
    subplot(3,3,i)
    subtitle(['控制点数为',num2str(nodes(i))])
    My_plot(X_0,Cp_0,Cp,XC)
end
figure("Name","SPVP")
for i = 1:1:9
    [X_0,Y_0,Cp_0,XB,YB] = NACA23021_Input(nodes(i),AoA);
    [Cp,XC] = COMPUTE_SPVP_Cp(X_0,Y_0,Cp_0,XB,YB,AoA);
    subplot(3,3,i)
    subtitle(['控制点数为',num2str(nodes(i))])
    My_plot(X_0,Cp_0,Cp,XC)
end

%% Cp 计算
function My_plot(X_0,Cp_0,Cp,XC)
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
    % legend([pXu,pXl,pVu,pVl],...                                            % Show legend
    %            {'XFOIL Upper','XFOIL Lower','Ours Upper','Ours Lower'});
    xlabel('X_C')
    ylabel('Cp')
end