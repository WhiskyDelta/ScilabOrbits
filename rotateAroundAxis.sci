function vnew=rotateAroundAxis(vold,angle,axis)
    axis = axis/norm(axis);
    crossProductMatrix = [0,-axis(3),axis(2);axis(3),0,-axis(1);-axis(2),axis(1),0];
    R = cos(angle)*eye(3,3) + sin(angle)*crossProductMatrix + (1-cos(angle))*axis.*.axis';
    vnew=(R*vold')'
endfunction
