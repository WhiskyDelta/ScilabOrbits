function [status]=orbits_draw(figure_handle,state)

    //----- Figure_data -----
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
    //axis_handle
    //object_handle
    //l_handle
    //ui_handle

    figure_data = get(figure_handle,'userdata');



    id = figure_data(1)
    resolution = figure_data(2)
    aspectratio = figure_data(3)
    axis_scale = figure_data(4)
    object_scale = figure_data(5)
    offset_object_ID = figure_data(6)
    rotation_object_ID = figure_data(7)
    l_size = figure_data(8)
    objects_with_l_points = figure_data(9)
    tracked_objects = figure_data(10)
    axis_handle = figure_data(11)
    object_handle = figure_data(12)
    l_handle = figure_data(13)
    ui_handle = figure_data(14)


    //doesn't yet support multiple objects with lagrangian points
    //probably should be done with transformed states
    if find(objects_with_l_points==2) then 
        r = state(:,1,2)-state(:,1,3);
        xl(:,1) = state(:,1,3)+r-r*(mu/3)^(1/3);
        xl(:,2) = state(:,1,3)+r+r*(mu/3)^(1/3);
        xl(:,3) = state(:,1,3)-r+r*mu*5/12;
        xl(:,4) = rotateAroundPivot(r,%pi/3,0,0,state(:,1,3));
        xl(:,5) = rotateAroundPivot(r,-%pi/3,0,0,state(:,1,3));
    end

    //----- Transformation ------

    if offset_object_ID ~= 0 then

        if rotation_object_ID ~= 0 then

            xi_axis = state(:,1,rotation_object_ID)-state(:,1,offset_object_ID)
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
            transformed_state(:,j) = rotateAroundPivot(state(:,1,j)-state(:,1,offset_object_ID),-phi,0,0,[0;0;0]); // Zerovector should possibly be the positional vector of offset_object?
        end

        xl(:,1) = rotateAroundPivot(xl(:,1)-state(:,1,offset_object_ID),-phi,0,0,[0;0;0]);
        xl(:,2) = rotateAroundPivot(xl(:,2)-state(:,1,offset_object_ID),-phi,0,0,[0;0;0]);
        xl(:,3) = rotateAroundPivot(xl(:,3)-state(:,1,offset_object_ID),-phi,0,0,[0;0;0]);
        xl(:,4) = rotateAroundPivot(xl(:,4)-state(:,1,offset_object_ID),-phi,0,0,[0;0;0]);
        xl(:,5) = rotateAroundPivot(xl(:,5)-state(:,1,offset_object_ID),-phi,0,0,[0;0;0]);
    else
        transformed_state = matrix(state(:,1,:),3,number_objects(1));
    end


    tracker1(:,i,1) = transformed_state(:,tracked_objects);
    //----- Drawing ------

    for j=1:number_objects(1)
        object_size = m(j)^(1/3)*object_scale;
        object_handle(j).data = [transformed_state(1,j)-object_size/2;transformed_state(2,j)+object_size/2;object_size;object_size;0;360*64];
    end


    l(1).data = [xl(1,1);xl(2,1);l_size/2;l_size/2;0;360*64];
    l(2).data = [xl(1,2);xl(2,2);l_size/2;l_size/2;0;360*64];
    l(3).data = [xl(1,3);xl(2,3);l_size/2;l_size/2;0;360*64];
    l(4).data = [xl(1,4);xl(2,4);l_size/2;l_size/2;0;360*64];
    l(5).data = [xl(1,5);xl(2,5);l_size/2;l_size/2;0;360*64];

    disp(tracker1)
    plot(tracker1(1,:,1),tracker1(2,:,1),"+");

    //----- UI Update -----
    ui_s1.string = string(iteration_counter)+" | "+string(iteration_counter*dt/60/60/24);
    status = 1;
endfunction

disp("drawing.sci loaded");
