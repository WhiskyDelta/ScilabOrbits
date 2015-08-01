function [figure_handle]=init_orbits_draw(draw_data,state)

    //----- Draw_data -----
    //id
    //m
    //resolution
    //aspectratio
    //axis_scale
    //object_scale
    //offset_object_ID
    //rotation_object_ID
    //l_size
    //objects_with_l_points
    //tracked_objects

    f=figure('figure_id',draw_data(1),'Userdata',draw_data);

    axis_handle=gca();axis_handle.data_bounds=[-384400000*axis_scale*aspectratio -384400000*axis_scale; 384400000*axis_scale*aspectratio 384400000*axis_scale];

    for j=1:number_objects(1)
        object_size = m(j)^(1/3)*object_scale;
        xfarcs([state(1,1,j)-object_size/2;state(2,1,j)+object_size/2;object_size;object_size;0;360*64],j*5);
        object_handle(j)=gce();
        object_handle(j)=object_handle(j).children;
    end


    if find(objects_with_l_points==2) then //doesn't yet support multiple objects with lagrangian points
        for k = 1:5
            xfarcs([xl(1,k);xl(2,k);l_size/2;l_size/2;0;360*64],1);l_handle(k)=gce();l_handle(k)=l_handle(k).children;
        end
    end

    xarcs([-mean_lunar_orbit;mean_lunar_orbit;mean_lunar_orbit*2;mean_lunar_orbit*2;0;360*64],7); //Mean Lunar Orbit

    ui_handle(1) = uicontrol('style','text','string','String 1','position',[resolution(1)-200,resolution(2)-250,200,100]);

    set(f,'userdata',lstcat(draw_data,list(axis_handle,object_handle,l_handle,ui_handle)));

    figure_handle = f;

endfunction

disp("init_orbits_draw.sci loaded");
