function f=TP1(x)
[s1,n]=size(x);
x(1,n+1)=x(1,1); %f1

h = -((x(1,i) -0.6).^3-0.4^3)/(0.6^3+0.4^3);
g=0;
for i = 2:n
    g = g + x(1,i);
end
g = (g/(n-1))^2;
s=1/(0.2+x(1,1));

x(1,n+2)=h+g*s;  %f2

f=x;
