function x=f(y)
    x=y
endfunction

global state
state=list(1,1.1,1.215,1.342875)
for i=1:20
    a=adamsBashforth(4,f,.1)
end
disp(a)
