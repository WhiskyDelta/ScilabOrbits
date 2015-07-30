function future=adamsBashforth(s,f,h)
    
    if s == 4 & size(state) == 4 then
        state(4) = state(4) + h*(55/24*f(state(4))-59/24*f(state(3))+37/24*f(state(2))-3/8*f(state(1)))
        future=state(4)
        disp(future)
    end
    
    if s == 3 & size(state) == 3 then
        state(3) = state(3) + h*(23/12*f(state(3))-4/3*f(state(2))+5/12*f(state(1)))
        future=state(3)
    end
    
    if s == 2 & size(state) == 2 then
        state(2) = state(2) + h*(1.5*f(state(2))-.5*f(state(1)))
        future=state(2)
    end
    
    if s == 1 then
        state(1) = state(1) + h*f(state(1));
        future=state(1)
    end
    
    if size(state) == 1 & s > 1 then
        state(2) = state(1) + h*f(state(1));
        future=state(2)
        disp("verlängerung1")
    end
    
    if size(state) == 2 & s > 2 then
        state(3) = state(2) + h*(1.5*f(state(2))-.5*f(state(1)))
        future=state(3)
        disp("verlängerung2")
    end
    
    if size(state) == 3 & s > 3
        state(4) = state(3) + h*(23/12*f(state(3))-4/3*f(state(2))+5/12*f(state(1)))
        future=state(4)
        disp("verlängerung3")
    end
    
endfunction
