clear;
exec("rotateAroundPivot.sci");
exec("rotateAroundAxis.sci");
exec("adamsBashforth.sci");
function dydt=dgl(y)
    dydt = list()
    for j=1:size(y)
        dydt(j)=zeros(2,3);
        dydt(j)(1,:)=y(j)(2,:);
        dydt(j)(2,:) = [0,0,0];
        for k=1:number_objects(1);
            if (k ~= j) then
                direction = (y(k)(1,:)-y(j)(1,:))/norm(y(k)(1,:)-y(j)(1,:))
                partial_a = G * m(k) / norm(y(k)(1,:)-y(j)(1,:))^2
                dydt(j)(2,:) = dydt(j)(2,:) + partial_a * direction
            end
        end        
    end
endfunction

dt= 60*30;
counter = 0

G =6.67384*10^-11;

//----- Object Creation -----

m(3) =5.974*10^24; //Erde
m(2) =7.349*10^22; //Mond
m(1) =5e-20; //Satellit

number_objects = size(m);

mean_lunar_orbit=384400000;

x0earth=[0,0,0];
x0moon=[mean_lunar_orbit,0,0];
x0sat=([cosd(-60),-sind(-60),0;sind(-60),cosd(-60),0;0,0,0] * (x0moon - x0earth)')' + x0earth;

v0moon=[0,1023,0];
v0sat=[-sind(-60)*v0moon(2),cosd(-60)*v0moon(2),0];
v0earth=[0,-v0moon(2)*m(2)/m(3),0];

state = list();
statedot = list();
state(1)=[x0sat;v0sat];
state(2)=[x0moon;v0moon];
state(3)=[x0earth;v0earth];
statesN = list(state)

//state(:,1,3)=[0;0]
//state(:,1,2)=[mean_lunar_orbit;0]
//state(:,1,1) = [cosd(-60),-sind(-60);sind(-60),cosd(-60)] * (state(:,1,2) - state(:,1,3)) + state(:,1,3)
//
//state(:,2,2) =[0;1077];
//state(:,2,3) =[0;-state(2,2,2)*m(2)/m(3)];
//state(:,2,1) =[-sind(-60)*state(2,2,2);cosd(-60)*state(2,2,2)]; //not the right orbital velocity
//
//for j=1:number_objects(1)
//    state(:,3,j) = [0;0]
//end
//        update=[1,0,0;dt,1,0;1*dt^2,dt,1] //not 100% clear why it works for 1*dt^2 and not for 0.5*dt^2

lpoint = list()
mu = m(2)/(m(2)+m(3))
r = (state(2)(1,:)-state(3)(1,:))
lpoint(1) = state(3)(1,:)+r-r*(mu/3)^(1/3)
lpoint(2) = state(3)(1,:)+r+r*(mu/3)^(1/3)
lpoint(3) = state(3)(1,:)-r+r*mu*5/12
lpoint(4) = rotateAroundPivot(r,%pi/3,0,0,state(3)(1,:))
lpoint(5) = rotateAroundPivot(r,-%pi/3,0,0,state(3)(1,:))





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
    xfarcs([state(j)(1,1)-object_size/2;state(j)(1,2)+object_size/2;object_size;object_size;0;360*64],j*5);
    object_handle(j)=gce();
    object_handle(j)=object_handle(j).children;
end

objects_with_l_points = [2]

if find(objects_with_l_points==2) then //doesn't yet support multiple objects with lagrangian points
    for k = 1:5
        xfarcs([lpoint(k)(1);lpoint(k)(2);circsize/2;circsize/2;0;360*64],1);l(k)=gce();l(k)=l(k).children;
    end
end

xarcs([-mean_lunar_orbit;mean_lunar_orbit;mean_lunar_orbit*2;mean_lunar_orbit*2;0;360*64],7); //Mean Lunar Orbit

ui_s1 = uicontrol('style','text','string','String 1','position',[resolution(1)-200,resolution(2)-250,200,100])
time=[0,0,0,0]
i=0
while 1
    timer()
    i=i+1 

    //----- Calculation ------
//    state = state * update
//    for j=1:number_objects(1)
//        state(:,3,j) = [0;0]
//        for k=1:number_objects(1)
//            if (k ~= j) then
//                direction = (state(:,1,k)-state(:,1,j))/norm(state(:,1,j)-state(:,1,k))
//                partial_a = G * m(k) / norm(state(:,1,j)-state(:,1,k))^2
//                state(:,3,j) = state(:,3,j) + partial_a * direction
//            end
//        end        
//    end
    
//    state_dot=dgl(state);
//    for j = 1:size(state)
//        state(j)=state(j)+state_dot(j)*dt;
//    end

    statesN = adamsBashforth(4,statesN,dgl,dt)
    state=statesN(1)

    time(1) = time(1)+timer()

    if find(objects_with_l_points==2) then //doesn't yet support multiple objects with lagrangian points
        r = state(2)(1,:)-state(3)(1,:)
        lpoint(1) = state(3)(1,:)+r-r*(mu/3)^(1/3)
        lpoint(2) = state(3)(1,:)+r+r*(mu/3)^(1/3)
        lpoint(3) = state(3)(1,:)-r+r*mu*5/12
        lpoint(4) = rotateAroundPivot(r,%pi/3,0,0,state(3)(1,:))
        lpoint(5) = rotateAroundPivot(r,-%pi/3,0,0,state(3)(1,:))
    end
    time(2) = time(2)+timer()
    
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

    offset_object=state(2)(1,:)
//    offset_object=0
//    phi = 0

    for j=1:number_objects(1)
        x_transformed(:,j) = rotateAroundPivot(state(j)(1,:),-phi,0,0,-offset_object)'
    end
    
    xnl1 = rotate(lpoint(1)(1:2)'-offset_object(1:2)',-phi)
    xnl2 = rotate(lpoint(2)(1:2)'-offset_object(1:2)',-phi)
    xnl3 = rotate(lpoint(3)(1:2)'-offset_object(1:2)',-phi)
    xnl4 = rotate(lpoint(4)(1:2)'-offset_object(1:2)',-phi)
    xnl5 = rotate(lpoint(5)(1:2)'-offset_object(1:2)',-phi)

    time(3) = time(3)+timer()

    

    p1(:,i) = x_transformed(:,1) 
    p2(:,i) = xnl5
    //----- Drawing ------
    if i == 300 then
        
        
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
    time(4) = time(4)+timer()
    disp(time)
end
