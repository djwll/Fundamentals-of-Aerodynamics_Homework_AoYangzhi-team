%% Cp 计算
function My_plot_Cp(X_0,Cp_0,Cp,XC)
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