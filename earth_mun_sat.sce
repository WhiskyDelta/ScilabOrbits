clear;

chdir(get_absolute_file_path('earth_mun_sat.sce'));
getd();

function dydt = dgl(y)
    dydt = y;
    dydt(:,1,:) = y(:,2,:);
    for j=1:number_objects(1);
        dydt(:,2,j) = [0;0;0];
        for k=1:number_objects(1);
            if (k ~= j) then
                direction = (y(:,1,k)-y(:,1,j))/norm(y(:,1,k)-y(:,1,j));
                partial_a = G * m(k) / norm(y(:,1,k)-y(:,1,j))^2;
                dydt(:,2,j) = dydt(:,2,j) + partial_a * direction;
            end
        end       
    end 
endfunction

iteration_counter=0

dt= 60*30;

G =6.67384*10^-11;

//----- Object Creation -----

m(3) =5.974*10^24; //Erde
m(2) =7.349*10^22; //Mond
m(1) =5e-20; //Satellit

number_objects = size(m);

mean_lunar_orbit=384400000;

state(:,1,3)=[0;0;0];
state(:,1,2)=[mean_lunar_orbit;0;0];
state(:,1,1) = [cosd(-60),-sind(-60),0;sind(-60),cosd(-60),0;0,0,1] * (state(:,1,2) - state(:,1,3)) + state(:,1,3);

state(:,2,2) =[0;1017;0];
state(:,2,1)=[-sind(-60)*state(2,2,2);cosd(-60)*state(2,2,2);0];
state(:,2,3)=[0;-state(2,2,2)*m(2)/m(3);0];

states = list(state);
statesdot = list(dgl(state));

mu = m(2)/(m(2)+m(3));
r = state(:,1,2)-state(:,1,3);
xl(:,1) = state(:,1,3)+r-r*(mu/3)^(1/3);
xl(:,2) = state(:,1,3)+r+r*(mu/3)^(1/3);
xl(:,3) = state(:,1,3)-r+r*mu*5/12;
xl(:,4) = rotateAroundPivot(r,%pi/3,0,0,state(:,1,3));
xl(:,5) = rotateAroundPivot(r,-%pi/3,0,0,state(:,1,3));



//----- Initial Object Drawing -----


id = 1;
resolution = [1920;1200];
aspectratio =resolution(1)/resolution(2);
axis_scale = 3;
object_scale = 1e0;
offset_object_ID=0;
rotation_object_ID=0;
l_size = 384400000/50;
objects_with_l_points = [2];
tracked_objects=[2];

draw_data = list(id,resolution,aspectratio,axis_scale,object_scale,offset_object_ID,rotation_object_ID,l_size,objects_with_l_points,tracked_objects);

figure_handle(1) = init_orbits_draw(draw_data,state)


i=0;
while 1
    i=i+1;

    //----- Calculation ------

    [states,statesdot] = adamsBashforth(2,states,statesdot,dgl,dt)
    state=states(1)
    

    iteration_counter = iteration_counter + 1;

    //----- Drawing ------
    
    if i == 300 then
        for j = 1 : length(figure_handle)
            status=orbits_draw(figure_handle(j),state)
        end
        i=0;
    end
    
end
