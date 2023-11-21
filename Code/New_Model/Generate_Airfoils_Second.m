%% 封装为函数
clc
y_Function(1000);
[xl,xu,yl,yu] = y_Function(1000);
length(xl)
length(xu)
plot(xl,yl,xu,yu)
axis([0 1 -1 1])
function [output1,output2,output3,output4] = y_Function(num)
    y_temp= [];
    xu = [];
    xl = [];
    yu = [];
    yl = [];
    for i = 0:1/num:1
        y_temp(end +1 ) = yc(i);
        %theta = atan2(yc(i+0.01) -yc(i),0.01 );
        save_tan = (yc(i+0.01) -yc(i))/0.01 ;
        save_sin = save_tan / sqrt(save_tan ^ 2 + 1);
        save_cos = 1 / sqrt(save_tan ^ 2 + 1);
        xu(end+1) = i - yt(i)*save_sin;
        xl(end+1) = i + yt(i)*save_sin;
        yu(end+1) = y_temp(end) + yt(i)*save_cos;
        yl(end+1) = y_temp(end) - yt(i)*save_cos;
    end
    % yl(end +1) = 0;
    % yu(end+1)=0;
    % xu(end+1) = 1;
    % xl(end+1) =1 ;
    output1=xu;output2=xl;output3=yu;output4=yl;
    function output = yc(x)
        k1 = 15.957;
        m = 0.2025;
         if x < m
             output = k1/6*(x^3-3*m*x^2+m^2*(3-m)*x);
         elseif x>m
             output =  k1*m^3/6*(1-x);
         end
            
    end
    function output = yt(x)
        t = 0.21;
        output = t/0.2*(0.2969*(x)^0.5 - 0.126*(x)-0.3516*(x)^2 + 0.2843*(x)^3 ...
    -0.1036*(x)^4); 
            
    end
    
end

