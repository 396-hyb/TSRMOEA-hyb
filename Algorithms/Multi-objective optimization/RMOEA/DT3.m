function f=DT3(x)
[s1,n]=size(x);
x(1,n+1) = x(1,1); %f1

g = 1 + 9*mean(x(1,2:n),2);
h = 1 - (x(1,n+1)/g)^0.5 - x(1,n+1)/g*sin(10*pi*x(1,n+1));

x(1,n+2) = g*h;  %f2

f=x;

