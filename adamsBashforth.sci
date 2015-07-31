function newY=adamsBashforth(s,oldY,f,h)
        
    newY = list();

    hasEnoughSteps = size(oldY) >= s;
    
    if hasEnoughSteps then
        for i=1:s-1
            newY(i+1)=oldY(i);
        end
    end
    
    if s == 4 & hasEnoughSteps then        
        newY(1) = oldY(1) + h*(55/24*f(oldY(1)) - 59/24*f(oldY(2)) + 37/24*f(oldY(3)) - 3/8*f(oldY(4)));
    end
    
    if s == 3 & hasEnoughSteps then
        newY(1) = oldY(1) + h*(23/12*f(oldY(1)) - 4/3*f(oldY(2)) + 5/12*f(oldY(3)));
    end
    
    if s == 2 & hasEnoughSteps then
        newY(1) = oldY(1)  +h*(1.5*f(oldY(1)) - .5*f(oldY(2)));
    end
    
    if s == 1 then
        newY(1) = oldY(1) + h*f(oldY(1));
    end
    
    if ~hasEnoughSteps then
        for i=1:size(oldY)
            newY(i+1) = oldY(i);
        end
    end
    
    
    if size(oldY) == 1 & s >= 2 then
        newY(1) = oldY(1) + h*f(oldY(1));
    end
    
    if size(oldY) == 2 & s >= 3 then
        newY(1) = oldY(1)  +h*(1.5*f(oldY(1)) - .5*f(oldY(2)));
    end
    
    if size(oldY) == 3 & s >= 4
        newY(1) = oldY(1) + h*(23/12*f(oldY(1)) - 4/3*f(oldY(2)) + 5/12*f(oldY(3)));
    end
    
endfunction
//
//function out=sL2(in1,in2)
//    out = list()
//    for i = 1:size(in1)
//        out(i)=in1(i)+in2(i)
//    end    
//endfunction
//
//function out=sL3(in1,in2,in3)
//    out = list()
//    out = sL2(sL2(in1, in2),in3)
//endfunction
//
//function out=sL4(in1,in2,in3,in4)
//    out = list()
//    out = sL2(sL2(in1, in2),sL2(in3,in4))
//endfunction
//
//function out=sL5(in1,in2,in3,in4,in5)
//    out = list()
//    out = sL2(sL3(in1, in2, in3),sL2(in4,in5))
//endfunction
//
//
//function out=sML(scalar,liste)
//    out = list()
//    for i = 1:size(liste)
//        out(i)=scalar*liste(i)
//    end
//endfunction
//
