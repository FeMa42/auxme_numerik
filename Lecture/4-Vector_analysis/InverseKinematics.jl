using NLsolve

function InverseKinematics!(res,phi)
    l1=1
    l2=1

    x_TCP = 0.8
    y_TCP = 1

    res[1] = l1*sin(phi[1])+l2*sin(phi[1]+phi[2]) - x_TCP
    res[2] = -l1*cos(phi[1])-l2*cos(phi[1]+phi[2]) - y_TCP
end

nlsolve(InverseKinematics!, [ 1.0; 1.2])