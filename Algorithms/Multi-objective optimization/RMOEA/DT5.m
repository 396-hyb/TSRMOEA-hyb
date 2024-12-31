function f=DT5(x)
[s1,n]=size(x);
% x(1,n+1)=x(1,1); %f1

u = zeros(1, 1+(n-30)/5);

u(1,1) = sum(x(1,1:30),2);

for i = 2 : size(u,2)
    u(:,i) = sum(x(1,(i-2)*5+31:(i-2)*5+35),2);
end
v = zeros(size(u));
v(u<5)      = 2 + u(u<5);
v(u==5)     = 1;
x(1,n+1) = 1 + u(1,1);  %f1

g           = sum(v(1,2:end),2);
h           = 1/x(1,n+1);

x(1,n+2) = g*h; %f2

f=x;

