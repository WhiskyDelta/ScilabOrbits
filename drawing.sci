function [status]=orbits_draw(figure_handle,state)
    draw_data = get(figure_handle,'userdata')
    
    //TODO: Actually draw everything
    
    status = 1
endfunction

function [figure_handle]=init_orbits_draw(draw_data)
    
    //TODO: initialize the figure, append the created graphics objects to draw_data and return the handle

endfunction

disp("drawing.sci loaded")
