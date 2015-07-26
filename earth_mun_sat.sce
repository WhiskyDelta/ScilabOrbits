clear;
dt= 60*10;

G =6.67384*10^-11;


m3 =5.974*10^24; //Erde
m2 =7.349*10^22; //Mond
m1 =5e2; //Satellit

x=384400000;
//x3 =[-x*m2/(m2+m3);0];
//x2 =[x*m3/(m2+m3);0];
x3=[0;0]
x2=[x;0]
x1 = [cosd(-60),-sind(-60);sind(-60),cosd(-60)] * (x2 - x3) + x3
//x1 = x2 + [1750000+100000;0]

mu = m2/(m2+m3)
r = x3-x2
xl1 = x3+r-r*(mu/3)^(1/3)
xl2 = x3+r+r*(mu/3)^(1/3)
xl3 = x3-r+r*mu*5/12
xl4 = [cosd(60),-sind(60);sind(60),cosd(60)] * (x2 - x3) + x3
xl5 = [cosd(-60),-sind(-60);sind(-60),cosd(-60)] * (x2 - x3) + x3


v2 =[0;1017];
v3 =[0;-v2(2)*m2/m3];
v1 =[-sind(-60)*v2(2);cosd(-60)*v2(2)]; // Nicht die korrekte Orbitgeschwindigkeit
//v1 = v2 + [0;-2500]


f=gcf();
scale = 3
a=gca();a.data_bounds=[-384400000*scale -384400000*scale; 384400000*scale 384400000*scale];

circsize = 384400000/50
//circsize =6371000
aspectratio =16/10 // Monitor Aspect Ratio - makes the circles round, even when they should not be

xfarcs([x1(1);x1(2);circsize;circsize*aspectratio;0;360*64],5);r1=gce();r1=r1.children;
//xstring(x1(1),x1(2),"Sat");s1=gce()


xfarcs([x2(1);x2(2);circsize;circsize*aspectratio;0;360*64],2);r2=gce();r2=r2.children;
//xstring(x2(1),x2(2),"Moon");s2=gce()


xfarcs([x3(1);x3(2);circsize;circsize*aspectratio;0;360*64],15);r3=gce();r3=r3.children;
//xstring(x3(1),x3(2),"Earth");s3=gce()

xfarcs([xl1(1);xl1(2);circsize/2;circsize/2*aspectratio;0;360*64],1);l1=gce();l1=l1.children;
xfarcs([xl2(1);xl2(2);circsize/2;circsize/2*aspectratio;0;360*64],1);l2=gce();l2=l2.children;
xfarcs([xl3(1);xl3(2);circsize/2;circsize/2*aspectratio;0;360*64],1);l3=gce();l3=l3.children;
xfarcs([xl4(1);xl4(2);circsize/2;circsize/2*aspectratio;0;360*64],1);l4=gce();l4=l4.children;
xfarcs([xl5(1);xl5(2);circsize/2;circsize/2*aspectratio;0;360*64],1);l5=gce();l5=l5.children;


xarcs([-circsize*50;circsize*50;circsize*100;circsize*100;0;360*64],7); //Mean Lunar Orbit

i=0
sleep(10000)
while 1    
   i=i+1 
a12 = G * m2 / norm(x1-x2)^2 * (x2-x1)/norm(x1-x2)
a13 = G * m3 / norm(x1-x3)^2 * (x3-x1)/norm(x1-x3)
a1 = a12 + a13;


a21 = G * m1 / norm(x2-x1)^2 * (x1-x2)/norm(x2-x1)
a23 = G * m3 / norm(x2-x3)^2 * (x3-x2)/norm(x2-x3)
a2 = a21 + a23;


a31 = G * m1 / norm(x3-x1)^2 * (x1-x3)/norm(x3-x1)
a32 = G * m2 / norm(x3-x2)^2 * (x2-x3)/norm(x3-x2)
a3 = a31 + a32;


v1 = v1 + a1*dt;
v2 = v2 + a2*dt;
v3 = v3 + a3*dt;


x1 = x1 + v1*dt;
x2 = x2 + v2*dt;
x3 = x3 + v3*dt;

//p2(:,i) = x2
//p3(:,i) = x3

r = x2-x3
xl1 = x3+r-r*(mu/3)^(1/3)
xl2 = x3+r+r*(mu/3)^(1/3)
xl3 = x3-r+r*mu*5/12
//xl4 = [cosd(60),-sind(60);sind(60),cosd(60)] * (x2 - x3) + x3
//xl5 = [cosd(-60),-sind(-60);sind(-60),cosd(-60)] * (x2 - x3) + x3
xl4 = rotate(r,%pi/3,x3)
xl5 = rotate(r,-%pi/3,x3)
if (r(1) > 0) then
    phi = atan(r(2)/r(1));
elseif r(1) < 0 then
    phi = %pi+atan(r(2)/r(1));
elseif r(2) > 0 then
    phi = %pi/2;
else
    phi = - %pi/2
end
phi=0


//----- Drawing ------

//move(r1,v1*dt)
//move(s1,v1*dt)
//move(r2,v2*dt)
//move(s2,v2*dt)
//move(r3,v3*dt)
//move(s3,v3*dt)
//r1.data = [x1(1);x1(2);circsize;circsize*aspectratio;0;360*64]
//r2.data = [x2(1);x2(2);circsize;circsize*aspectratio;0;360*64]
//r3.data = [x3(1);x3(2);circsize;circsize*aspectratio;0;360*64]
//r1.data = [x1(1);x1(2);circsize;circsize*aspectratio;0;360*64]
//l1.data = [xl1(1);xl1(2);circsize/2;circsize/2*aspectratio;0;360*64]
//l2.data = [xl2(1);xl2(2);circsize/2;circsize/2*aspectratio;0;360*64]
//l3.data = [xl3(1);xl3(2);circsize/2;circsize/2*aspectratio;0;360*64]
//l4.data = [xl4(1);xl4(2);circsize/2;circsize/2*aspectratio;0;360*64]
//l5.data = [xl5(1);xl5(2);circsize/2;circsize/2*aspectratio;0;360*64]
alpha=0
//alpha = -rotate(xl5,-phi)

xn1 = rotate(x1,-phi)+alpha
xn2 = rotate(x2,-phi)+alpha
xn3 = rotate(x3,-phi)+alpha
xnl1 = rotate(xl1,-phi)+alpha
xnl2 = rotate(xl2,-phi)+alpha
xnl3 = rotate(xl3,-phi)+alpha
xnl4 = rotate(xl4,-phi)+alpha
xnl5 = rotate(xl5,-phi)+alpha


p1(:,i) = xn1


r1.data = [xn1(1);xn1(2);circsize;circsize*aspectratio;0;360*64]
r2.data = [xn2(1);xn2(2);circsize;circsize*aspectratio;0;360*64]
r3.data = [xn3(1);xn3(2);circsize;circsize*aspectratio;0;360*64]
l1.data = [xnl1(1);xnl1(2);circsize/2;circsize/2*aspectratio;0;360*64]
l2.data = [xnl2(1);xnl2(2);circsize/2;circsize/2*aspectratio;0;360*64]
l3.data = [xnl3(1);xnl3(2);circsize/2;circsize/2*aspectratio;0;360*64]
l4.data = [xnl4(1);xnl4(2);circsize/2;circsize/2*aspectratio;0;360*64]
l5.data = [xnl5(1);xnl5(2);circsize/2;circsize/2*aspectratio;0;360*64]
if i = 100 then

plot(p1(1,:),p1(2,:),"r")
i=0
end

end


//    plot(x1(1),x1(2),"r+")
//    plot(x2(1),x2(2),"+")
//
//plot(p1(1,:),p1(2,:),"r")
//plot(p2(1,:),p2(2,:),"--")
//plot(p3(1,:),p3(2,:),"g")
//
