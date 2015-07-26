clear;
dt= 60*10;

G =6.67384*10^-11;


m(3) =5.974*10^24; //Erde
m(2) =7.349*10^22; //Mond
m(1) =5e2; //Satellit

mean_lunar_orbit=384400000;
//x(:,3) =[-x*m(2)/(m(2)+m(3));0];
//x(:,2) =[x*m(3)/(m(2)+m(3));0];
x(:,3)=[0;0]
x(:,2)=[mean_lunar_orbit;0]
x(:,1) = [cosd(-60),-sind(-60);sind(-60),cosd(-60)] * (x(:,2) - x(:,3)) + x(:,3)
//x(:,1) = x(:,2) + [1750000+100000;0]

mu = m(2)/(m(2)+m(3))
r = x(:,3)-x(:,2)
xl(:,1) = x(:,3)+r-r*(mu/3)^(1/3)
xl(:,2) = x(:,3)+r+r*(mu/3)^(1/3)
xl(:,3) = x(:,3)-r+r*mu*5/12
xl(:,4) = [cosd(60),-sind(60);sind(60),cosd(60)] * (x(:,2) - x(:,3)) + x(:,3)
xl(:,5) = [cosd(-60),-sind(-60);sind(-60),cosd(-60)] * (x(:,2) - x(:,3)) + x(:,3)


v(:,2) =[0;1017];
v(:,3) =[0;-v(2,2)*m(2)/m(3)];
v(:,1) =[-sind(-60)*v(2,2);cosd(-60)*v(2,2)]; // Nicht die korrekte Orbitgeschwindigkeit
//v1 = v2 + [0;-2500]


f=gcf();
scale = 3
axis=gca();axis.data_bounds=[-384400000*scale -384400000*scale; 384400000*scale 384400000*scale];

circsize = 384400000/50
//circsize =6371000
aspectratio =16/10 // Monitor Aspect Ratio - makes the circles round, even when they should not be

xfarcs([x(1,1);x(2,1);circsize;circsize*aspectratio;0;360*64],5);r1=gce();r1=r1.children;
//xstring(x(1,1),x(2,1),"Sat");s1=gce()


xfarcs([x(1,2);x(2,2);circsize;circsize*aspectratio;0;360*64],2);r2=gce();r2=r2.children;
//xstring(x(1,2),x(2,2),"Moon");s2=gce()


xfarcs([x(1,3);x(2,3);circsize;circsize*aspectratio;0;360*64],15);r3=gce();r3=r3.children;
//xstring(x(1,3),x(2,3),"Earth");s3=gce()

xfarcs([xl(1,1);xl(2,1);circsize/2;circsize/2*aspectratio;0;360*64],1);l(1)=gce();l(1)=l(1).children;
xfarcs([xl(1,2);xl(2,2);circsize/2;circsize/2*aspectratio;0;360*64],1);l2=gce();l2=l2.children;
xfarcs([xl(1,3);xl(2,3);circsize/2;circsize/2*aspectratio;0;360*64],1);l3=gce();l3=l3.children;
xfarcs([xl(1,4);xl(2,4);circsize/2;circsize/2*aspectratio;0;360*64],1);l4=gce();l4=l4.children;
xfarcs([xl(1,5);xl(2,5);circsize/2;circsize/2*aspectratio;0;360*64],1);l5=gce();l5=l5.children;

xarcs([-circsize*50;circsize*50;circsize*100;circsize*100;0;360*64],7); //Mean Lunar Orbit


i=0
while 1   
     
    i=i+1 
    
    a12 = G * m(2) / norm(x(:,1)-x(:,2))^2 * (x(:,2)-x(:,1))/norm(x(:,1)-x(:,2))
    a13 = G * m(3) / norm(x(:,1)-x(:,3))^2 * (x(:,3)-x(:,1))/norm(x(:,1)-x(:,3))
    a(:,1) = a12 + a13;

    a21 = G * m(1) / norm(x(:,2)-x(:,1))^2 * (x(:,1)-x(:,2))/norm(x(:,2)-x(:,1))
    a23 = G * m(3) / norm(x(:,2)-x(:,3))^2 * (x(:,3)-x(:,2))/norm(x(:,2)-x(:,3))
    a(:,2) = a21 + a23;

    a31 = G * m(1) / norm(x(:,3)-x(:,1))^2 * (x(:,1)-x(:,3))/norm(x(:,3)-x(:,1))
    a32 = G * m(2) / norm(x(:,3)-x(:,2))^2 * (x(:,2)-x(:,3))/norm(x(:,3)-x(:,2))
    a(:,3) = a31 + a32;
    

    v(:,1) = v(:,1) + a(:,1)*dt;
    v(:,2) = v(:,2) + a(:,2)*dt;
    v(:,3) = v(:,3) + a(:,3)*dt;


    x(:,1) = x(:,1) + v(:,1)*dt;
    x(:,2) = x(:,2) + v(:,2)*dt;
    x(:,3) = x(:,3) + v(:,3)*dt;

    r = x(:,2)-x(:,3)
    xl(:,1) = x(:,3)+r-r*(mu/3)^(1/3)
    xl(:,2) = x(:,3)+r+r*(mu/3)^(1/3)
    xl(:,3) = x(:,3)-r+r*mu*5/12
    xl(:,4) = rotate(r,%pi/3,x(:,3))
    xl(:,5) = rotate(r,-%pi/3,x(:,3))
    
      
    
    //----- Projection ------
    if (r(1) > 0) then
        phi = atan(r(2)/r(1));
    elseif r(1) < 0 then
        phi = %pi+atan(r(2)/r(1));
    elseif r(2) > 0 then
        phi = %pi/2;
    else
        phi = - %pi/2
    end
        
    offset_object=x(:,2)

    xn1 = rotate(x(:,1)-offset_object,-phi)
    xn2 = rotate(x(:,2)-offset_object,-phi)
    xn3 = rotate(x(:,3)-offset_object,-phi)
    xnl1 = rotate(xl(:,1)-offset_object,-phi)
    xnl2 = rotate(xl(:,2)-offset_object,-phi)
    xnl3 = rotate(xl(:,3)-offset_object,-phi)
    xnl4 = rotate(xl(:,4)-offset_object,-phi)
    xnl5 = rotate(xl(:,5)-offset_object,-phi)
p1(:,i) = xn1  

    //----- Drawing ------
    r1.data = [xn1(1);xn1(2);circsize;circsize*aspectratio;0;360*64]
    r2.data = [xn2(1);xn2(2);circsize;circsize*aspectratio;0;360*64]
    r3.data = [xn3(1);xn3(2);circsize;circsize*aspectratio;0;360*64]
    l(1).data = [xnl1(1);xnl1(2);circsize/2;circsize/2*aspectratio;0;360*64]
    l2.data = [xnl2(1);xnl2(2);circsize/2;circsize/2*aspectratio;0;360*64]
    l3.data = [xnl3(1);xnl3(2);circsize/2;circsize/2*aspectratio;0;360*64]
    l4.data = [xnl4(1);xnl4(2);circsize/2;circsize/2*aspectratio;0;360*64]
    l5.data = [xnl5(1);xnl5(2);circsize/2;circsize/2*aspectratio;0;360*64]
    
    if i == 500 then
        plot(p1(1,:),p1(2,:),"r")
        i=0
    end

end


//    plot(x(1,1),x(2,1),"r+")
//    plot(x(1,2),x(2,2),"+")
//
//plot(p1(1,:),p1(2,:),"r")
//plot(p2(1,:),p2(2,:),"--")
//plot(p3(1,:),p3(2,:),"g")
//
