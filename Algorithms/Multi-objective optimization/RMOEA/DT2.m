function f=DT2(x)
[s1,n]=size(x);
x(1,n+1) = x(1,1); %f1

g = 1 + 9*mean(x(1,2:n),2);
h = 1 - (x(1,n+1)/g)^2;

x(1,n+2) = g*h;  %f2

f=x;
