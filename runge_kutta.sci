function [y1]=runge_kutta(butcher,fct,y0,t0,stepsize)
    //TODO: check butcher integrity (should be explicit) here
    rksteps=max(size(butcher))-1
    g(1,:,:,:)=y0
    for j=2:rksteps
        for k=1:j-1
            g(j,:,:,:)=y0+stepsize*butcher(j,k+1)*fct(t0+butcher(k,1)*stepsize,g(k,:,:,:))
        end
    end
    y1=y0
    for i = 1:rksteps
        y1 = y1 + stepsize*butcher(rksteps+1,i+1)*fct(t0+butcher(i,1)*stepsize,g(i,:,:,:))
    end
endfunction

disp("runge_kutta.sce loaded")
