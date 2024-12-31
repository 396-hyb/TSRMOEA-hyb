function f=DT4(x)
[s1,n]=size(x);
% x(1,n+1)=x(1,1); %f1

x(1,n+1) = 1 - exp(-4*x(1,1))*sin(6*pi*x(1,1))^6;
g = 1 + 9*mean(x(1,2:n),2)^0.25;
h = 1 - (x(1,n+1)/g)^2;
x(1,n+2) = g*h;

f=x;
