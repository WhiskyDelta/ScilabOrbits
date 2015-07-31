function [status]=orbits_draw(figure_handle,state)

    //----- Figure_data -----
    //id
    //m
    //resolution
    //aspectratio
    //axis_scale
    //object_scale
    //offset_object
    //rotation_object
    //l_size
    //objects_with_l_points
    //tracked_objects
    //axis_handle
    //object_handle
    //l_handle
    //ui_handle

    figure_data = get(figure_handle,'userdata');


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

    //----- Transformation ------

    if offset_object ~= 0 then

        if rotation_object ~= 0 then

            xi_axis = state(:,1,rotation_object)-state(:,1,offset_object)
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

        status = 1;
    end
endfunction





function [figure_handle]=init_orbits_draw(draw_data)

    //----- Draw_data -----
    //id
    //state
    //m
    //resolution
    //aspectratio
    //axis_scale
    //object_scale
    //offset_object
    //rotation_object
    //l_size
    //objects_with_l_points
    //tracked_objects

    f=figure('figure_id',draw_data(1),'Userdata',draw_data);

    axis_handle=gca();axis_handle.data_bounds=[-384400000*axis_handle_scale*aspectratio -384400000*axis_handle_scale; 384400000*axis_handle_scale*aspectratio 384400000*axis_handle_scale];

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

    draw_data(2) = null() //delete state from draw_data, since it will be passed each iteration

    set(f,'userdata',lstcat(draw_data,list(axis_handle,object_handle,l_handle,ui_handle)));

    figure_handle = f;

endfunction

disp("drawing.sci loaded");
