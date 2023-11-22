%导入翼型数据
a = load("./NACA/NACA23021_300.txt");
XB = flip(a(:,1));
YB = flip(a(:,2));
AoA = 0
alpha = 0;
numPan = length(XB)-1;
Vinf = 1

XC   = zeros(numPan,1);                                                     
YC   = zeros(numPan,1);                                                     
S    = zeros(numPan,1);                                                     
phi = zeros(numPan,1);
beta = zeros(numPan,1); 

%生成控制点和相应的参数
for i = 1:1:numPan                                                          
    XC(i)   = 0.5*(XB(i)+XB(i+1));                                          
    YC(i)   = 0.5*(YB(i)+YB(i+1));                                          
    dx      = XB(i+1)-XB(i);                                                
    dy      = YB(i+1)-YB(i);                                                
    S(i)    = (dx^2 + dy^2)^0.5;                                           
	phi(i) = atan2(dy,dx);
    beta(i) = phi(i) + pi/2;
end
                                                                                                                   
K = zeros(numPan,numPan);                                                   
L = zeros(numPan,numPan);                                                   
%进行积分运算
for i = 1:1:numPan                                                          
    for j = 1:1:numPan                                                      
        if (j ~= i)                                                         
            A  = -(XC(i)-XB(j))*cos(phi(j))-(YC(i)-YB(j))*sin(phi(j));     
            B  = (XC(i)-XB(j))^2+(YC(i)-YB(j))^2;                           
            Cn = -cos(phi(i)-phi(j));                                       
            Dn = (XC(i)-XB(j))*cos(phi(i))+(YC(i)-YB(j))*sin(phi(i));      
            Ct = sin(phi(j)-phi(i));                                       
            Dt = (XC(i)-XB(j))*sin(phi(i))-(YC(i)-YB(j))*cos(phi(i));      
            E  = sqrt(B-A^2);                                               
            if (~isreal(E))
                E = 0;
            end
                   
            K(i,j) = 0.5*Cn*log((S(j)^2+2*A*S(j)+B)/B) + ((Dn-A*Cn)/E)*(atan2((S(j)+A),E)-atan2(A,E));                                               
            L(i,j) = 0.5*Ct*log((S(j)^2+2*A*S(j)+B)/B) + ((Dt-A*Ct)/E)*(atan2((S(j)+A),E)-atan2(A,E));                                        
        end
    end
end

a = zeros(numPan,numPan);                                                   
for i = 1:1:numPan                                                         
    for j = 1:1:numPan                                                                                                 
        a(i,j) = -K(i,j);                                               
    end
end

b = zeros(numPan,1);                                                        
for i = 1:1:numPan                                                          
    b(i) = -Vinf*2*pi*cos(beta(i));                                         
end

a(numPan,:)   = 0;                                                          
a(numPan,1)   = 1;                                                         
a(numPan,end) = 1;                                                          
b(numPan)     = 0;                                                         

gamma = inv(a)*b;                                                                

Vt = zeros(numPan,1);                                                       
Cp = zeros(numPan,1);                                                       
for i = 1:1:numPan                                                          
    sum  = 0;                                                            
    for j = 1:1:numPan                                                      
        sum = sum - (gamma(j)/(2*pi))*L(i,j);                         
    end
    
    Vt(i) = Vinf*sin(beta(i)) + sum + gamma(i)/2;                       
    Cp(i) = 1-(Vt(i)/Vinf)^2;                                              
end

figure(1)
XC
scatter(XC,Cp)
