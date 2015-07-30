function vnew=rotateAroundAxis(vold,angle,axis)
    axis = axis/norm(axis);
    crossProductMatrix = [0,-axis(3),axis(2);axis(3),0,-axis(1);-axis(2),axis(1),0];
    R = cos(angle)*eye(3,3) + sin(angle)*crossProductMatrix + (1-cos(angle))*axis.*.axis';
    vnew=(R*vold')'
endfunction

function vnew=rotateAroundPivot(vold,yaw,pitch,roll,pivot)
        Ryaw = [cos(yaw),-sin(yaw),0;sin(yaw),cos(yaw),0;0,0,1];
        Rpitch = [cos(pitch),0,sin(pitch);0,1,0;-sin(pitch),0,cos(pitch)];
        Rroll = [1,0,0;0,cos(roll),-sin(roll);0,sin(roll),cos(roll)];
        vnew = (Rroll*Rpitch*Ryaw*(vold-pivot)')'+pivot
endfunction

function x=f(y)
    x=y
endfunction

a = list(1)
for i=1:20
    a=adamsBashforth(1,a,f,.1)
end
disp(a)
