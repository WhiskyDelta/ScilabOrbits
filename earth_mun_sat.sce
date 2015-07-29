clear;

chdir(get_absolute_file_path('earth_mun_sat.sce'));
getd();

dt= 60*10;
iteration_counter = 0;

G =6.67384*10^-11;

//----- Object Creation -----

m(3) =5.974*10^24; //Erde
m(2) =7.349*10^22; //Mond
m(1) =5e-20; //Satellit

number_objects = size(m);

mean_lunar_orbit=384400000;

state(:,1,3)=[0;0];
state(:,1,2)=[mean_lunar_orbit;0];
state(:,1,1) = [cosd(-60),-sind(-60);sind(-60),cosd(-60)] * (state(:,1,2) - state(:,1,3)) + state(:,1,3);

state(:,2,2) =[0;1017];
state(:,2,3) =[0;-state(2,2,2)*m(2)/m(3)];
state(:,2,1) =[-sind(-60)*state(2,2,2);cosd(-60)*state(2,2,2)]; //not the right orbital velocity

for j=1:number_objects(1)
    state(:,3,j) = [0;0];
end
update=[1,0,0;dt,1,0;1*dt^2,dt,1]; //not 100% clear why it works for 1*dt^2 and not for 0.5*dt^2

mu = m(2)/(m(2)+m(3));
r = state(:,1,2)-state(:,1,3);
xl(:,1) = state(:,1,3)+r-r*(mu/3)^(1/3);
xl(:,2) = state(:,1,3)+r+r*(mu/3)^(1/3);
xl(:,3) = state(:,1,3)-r+r*mu*5/12;
xl(:,4) = rotate(r,%pi/3,state(:,1,3));
xl(:,5) = rotate(r,-%pi/3,state(:,1,3));



//----- Initial Object Drawing -----

id = 1;
resolution = [1920;1200];
aspectratio =resolution(1)/resolution(2);
axis_scale = 3;
object_scale = 1e0;
offset_object=0;
rotation_object=0;
l_size = 384400000/50;
objects_with_l_points = [2];
tracked_objects=[1];

draw_data = list(id,state,m,resolution,aspectratio,axis_scale,object_scale,l_size,offset_object,rotation_object,objects_with_l_points,tracked_objects);

//figure_handle(1) = init_orbits_draw(draw_data)

f=figure('figure_id',1,'Userdata',draw_data);

axis=gca();axis.data_bounds=[-384400000*axis_scale*aspectratio -384400000*axis_scale; 384400000*axis_scale*aspectratio 384400000*axis_scale];

for j=1:number_objects(1)
    object_size = m(j)^(1/3)*object_scale;
    xfarcs([state(1,1,j)-object_size/2;state(2,1,j)+object_size/2;object_size;object_size;0;360*64],j*5);
    object_handle(j)=gce();
    object_handle(j)=object_handle(j).children;
end


if find(objects_with_l_points==2) then //doesn't yet support multiple objects with lagrangian points
    for k = 1:5
        xfarcs([xl(1,k);xl(2,k);l_size/2;l_size/2;0;360*64],1);l(k)=gce();l(k)=l(k).children;
    end
end

xarcs([-mean_lunar_orbit;mean_lunar_orbit;mean_lunar_orbit*2;mean_lunar_orbit*2;0;360*64],7); //Mean Lunar Orbit

ui_s1 = uicontrol('style','text','string','String 1','position',[resolution(1)-200,resolution(2)-250,200,100]);

i=0;
while 1

    i=i+1;

    //----- Calculation ------
    
    //TODO: Call runge_kutta from here and make it work
    
    state = state * update;
    for j=1:number_objects(1)
        state(:,3,j) = [0;0];
        for k=1:number_objects(1)
            if (k ~= j) then
                direction = (state(:,1,k)-state(:,1,j))/norm(state(:,1,j)-state(:,1,k));
                partial_a = G * m(k) / norm(state(:,1,j)-state(:,1,k))^2;
                state(:,3,j) = state(:,3,j) + partial_a * direction;
            end
        end        
    end


    //doesn't yet support multiple objects with lagrangian points
    //probably should be done with transformed states
    if find(objects_with_l_points==2) then 
        r = state(:,1,2)-state(:,1,3);
        xl(:,1) = state(:,1,3)+r-r*(mu/3)^(1/3);
        xl(:,2) = state(:,1,3)+r+r*(mu/3)^(1/3);
        xl(:,3) = state(:,1,3)-r+r*mu*5/12;
        xl(:,4) = rotate(r,%pi/3,state(:,1,3));
        xl(:,5) = rotate(r,-%pi/3,state(:,1,3));
    end

    iteration_counter = iteration_counter + 1;

    //----- Drawing ------
    
//    status=orbits_draw(f,state)

    //----- Transformation ------

    if offset_object ~= 0 then

        if rotation_object ~= 0 then

            xi_axis = state(:,1,rotation_object)-state(:,1,offset_object);
            if (xi_axis(1) > 0) then
                phi = atan(xi_axis(2)/xi_axis(1));
            elseif xi_axis(1) < 0 then
                phi = %pi+atan(xi_axis(2)/xi_axis(1));
            elseif xi_axis(2) > 0 then
                phi = %pi/2;
            else
                phi = - %pi/2;
            end
        else
            phi = 0;
        end

        for j=1:number_objects(1)
            transformed_state(:,j) = rotate(state(:,1,j)-state(:,1,offset_object),-phi);
        end

        xl(:,1) = rotate(xl(:,1)-state(:,1,offset_object),-phi);
        xl(:,2) = rotate(xl(:,2)-state(:,1,offset_object),-phi);
        xl(:,3) = rotate(xl(:,3)-state(:,1,offset_object),-phi);
        xl(:,4) = rotate(xl(:,4)-state(:,1,offset_object),-phi);
        xl(:,5) = rotate(xl(:,5)-state(:,1,offset_object),-phi);
    else
        transformed_state = matrix(state(:,1,:),2,number_objects(1));
    end

    tracker1(:,i,1) = transformed_state(:,tracked_objects);
    //----- Drawing ------
    if i == 50 then

        for j=1:number_objects(1)
            object_size = m(j)^(1/3)*object_scale;
            object_handle(j).data = [transformed_state(1,j)-object_size/2;transformed_state(2,j)+object_size/2;object_size;object_size;0;360*64];
        end


        l(1).data = [xl(1,1);xl(2,1);l_size/2;l_size/2;0;360*64];
        l(2).data = [xl(1,2);xl(2,2);l_size/2;l_size/2;0;360*64];
        l(3).data = [xl(1,3);xl(2,3);l_size/2;l_size/2;0;360*64];
        l(4).data = [xl(1,4);xl(2,4);l_size/2;l_size/2;0;360*64];
        l(5).data = [xl(1,5);xl(2,5);l_size/2;l_size/2;0;360*64];


        plot(tracker1(1,:,1),tracker1(2,:,1),"r");

        i=0;
        //----- UI Update -----
        ui_s1.string = string(iteration_counter)+" | "+string(iteration_counter*dt/60/60/24);
    end

end
