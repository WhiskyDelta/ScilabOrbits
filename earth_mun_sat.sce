clear;
dt= 60*10;
counter = 0

G =6.67384*10^-11;

//----- Object Creation -----

m(3) =5.974*10^24; //Erde
m(2) =7.349*10^22; //Mond
m(1) =5e-20; //Satellit

number_objects = size(m);

mean_lunar_orbit=384400000;

x(:,3)=[0;0]
x(:,2)=[mean_lunar_orbit;0]
x(:,1) = [cosd(-60),-sind(-60);sind(-60),cosd(-60)] * (x(:,2) - x(:,3)) + x(:,3)

v(:,2) =[0;1017];
v(:,3) =[0;-v(2,2)*m(2)/m(3)];
v(:,1) =[-sind(-60)*v(2,2);cosd(-60)*v(2,2)]; // Nicht die korrekte Orbitgeschwindigkeit

a = zeros(2,number_objects(1))

mu = m(2)/(m(2)+m(3))
r = x(:,2)-x(:,3)
xl(:,1) = x(:,3)+r-r*(mu/3)^(1/3)
xl(:,2) = x(:,3)+r+r*(mu/3)^(1/3)
xl(:,3) = x(:,3)-r+r*mu*5/12
xl(:,4) = rotate(r,%pi/3,x(:,3))
xl(:,5) = rotate(r,-%pi/3,x(:,3))





//----- Initial Object Drawing -----

f=gcf();

scale = 3

resolution = [1920;1200]

aspectratio =resolution(1)/resolution(2) // Monitor Aspect Ratio - makes the circles round, even when they should not be

axis=gca();axis.data_bounds=[-384400000*scale*aspectratio -384400000*scale; 384400000*scale*aspectratio 384400000*scale];

circsize = 384400000/50

object_scale = 1e-0

for j=1:number_objects(1)
    object_size = m(j)^(1/3)*object_scale
    xfarcs([x(1,j)-object_size/2;x(2,j)+object_size/2;object_size;object_size;0;360*64],j*5);
    object_handle(j)=gce();
    object_handle(j)=object_handle(j).children;
end

objects_with_l_points = [2]

if find(objects_with_l_points==2) then //doesn't yet support multiple objects with lagrangian points
    for k = 1:5
        xfarcs([xl(1,k);xl(2,k);circsize/2;circsize/2;0;360*64],1);l(k)=gce();l(k)=l(k).children;
    end
end

xarcs([-mean_lunar_orbit;mean_lunar_orbit;mean_lunar_orbit*2;mean_lunar_orbit*2;0;360*64],7); //Mean Lunar Orbit

ui_s1 = uicontrol('style','text','string','String 1','position',[resolution(1)-200,resolution(2)-250,200,100])

i=0
while 1

    i=i+1 

    //----- Calculation ------
    for j=1:number_objects(1)
        a(:,j) = [0;0]
        for k=1:number_objects(1)
            if (k ~= j) then
                direction = (x(:,k)-x(:,j))/norm(x(:,j)-x(:,k))
                partial_a = G * m(k) / norm(x(:,j)-x(:,k))^2
                a(:,j) = a(:,j) + partial_a * direction
            end
        end
        v(:,j) = v(:,j) + a(:,j)*dt;
        x(:,j) = x(:,j) + v(:,j)*dt;
        
        update=[1,0,0;dt,1,0;.5*dt^2,dt,1]     
           
        state(j,1,:) = x(:,j)
        state(j,2,:) = v(:,j)
        state(j,3,:) = a(:,j)
        
    end
    
    if find(objects_with_l_points==2) then //doesn't yet support multiple objects with lagrangian points
        r = x(:,2)-x(:,3)
        xl(:,1) = x(:,3)+r-r*(mu/3)^(1/3)
        xl(:,2) = x(:,3)+r+r*(mu/3)^(1/3)
        xl(:,3) = x(:,3)-r+r*mu*5/12
        xl(:,4) = rotate(r,%pi/3,x(:,3))
        xl(:,5) = rotate(r,-%pi/3,x(:,3))
    end

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

//    x_transformed(:,1) = rotate(x(:,1)-offset_object,-phi)
//    x_transformed(:,2) = rotate(x(:,2)-offset_object,-phi)
//    x_transformed(:,3) = rotate(x(:,3)-offset_object,-phi)
    for j=1:number_objects(1)
        x_transformed(:,j) = rotate(x(:,j)-offset_object,-phi)
    end
    
    xnl1 = rotate(xl(:,1)-offset_object,-phi)
    xnl2 = rotate(xl(:,2)-offset_object,-phi)
    xnl3 = rotate(xl(:,3)-offset_object,-phi)
    xnl4 = rotate(xl(:,4)-offset_object,-phi)
    xnl5 = rotate(xl(:,5)-offset_object,-phi)



    

    p1(:,i) = x_transformed(:,1) 
    p2(:,i) = xnl5
    //----- Drawing ------
    if i == 500 then
        
        
    for j=1:number_objects(1)
        object_size = m(j)^(1/3)*object_scale
        object_handle(j).data = [x_transformed(1,j)-object_size/2;x_transformed(2,j)+object_size/2;object_size;object_size;0;360*64]
    end


    l(1).data = [xnl1(1);xnl1(2);circsize/2;circsize/2;0;360*64]
    l(2).data = [xnl2(1);xnl2(2);circsize/2;circsize/2;0;360*64]
    l(3).data = [xnl3(1);xnl3(2);circsize/2;circsize/2;0;360*64]
    l(4).data = [xnl4(1);xnl4(2);circsize/2;circsize/2;0;360*64]
    l(5).data = [xnl5(1);xnl5(2);circsize/2;circsize/2;0;360*64]



        plot(p1(1,:),p1(2,:),"r")
        plot(p2(1,:),p2(2,:),"b")
        counter = counter + i
        i=0
        //----- UI Update -----
        ui_s1.string = string(counter)+" | "+string(counter*dt/60/60/24)
    end
end
