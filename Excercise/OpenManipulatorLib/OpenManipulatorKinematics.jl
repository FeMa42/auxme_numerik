# OpenManipulatorKineamtics.jl
module OpenManipulatorKineamtics
using Rotations

export RotationMatrix, get_tranformation_matrix, forward_kinematics, forward_kinematics_rpy, complete_forward_kinematics

function RotationMatrix(θ, axis::String)
    if axis == "z"
        R_variable = [cos(θ) -sin(θ) 0; sin(θ) cos(θ) 0; 0 0 1]
    elseif axis == "y"
        R_variable = [cos(θ) 0 sin(θ); 0 1 0; -sin(θ) 0 cos(θ)]
    elseif axis == "x"
        R_variable = [1 0 0; 0 cos(θ) -sin(θ); 0 sin(θ) cos(θ)]
    else
        println("Invalid axis")
    end
    return R_variable
end

function get_tranformation_matrix(rel_pos, θ, axis::String)
    if axis=="None"
        R_variable = [1 0 0; 0 1 0; 0 0 1]
    else
        R_variable = RotationMatrix(θ, axis)
    end
    T = [R_variable rel_pos; 0 0 0 1]
    return T
end

function forward_kinematics(q)
    # We do not have to consider the origin of the first joint since it is the same as the origin of the base frame
    T01 = get_tranformation_matrix([0.012, 0.0, 0.017], q[1], "z")
    
    T12 = get_tranformation_matrix([0.0, 0.0, 0.0595], q[2], "y")

    T23 = get_tranformation_matrix([0.024, 0.0, 0.128], q[3], "y")

    T34 = get_tranformation_matrix([0.124, 0.0, 0.0], q[4], "y")
    
    T4E = get_tranformation_matrix([0.126, 0.0, 0.0], 0.0, "None")

    T0E = T01 * T12 * T23 * T34 * T4E
    return T0E
end

function forward_kinematics_rpy(T0E)
    # Extract the rotation matrix from the transformation matrix
    R0E = T0E[1:3, 1:3]

    # Convert the rotation matrix to RPY angles
    roll = atan(R0E[3, 2] / R0E[3, 3])
    pitch = asin(-R0E[3, 1])
    yaw = atan(R0E[2, 1] / R0E[1, 1])

    return [roll, pitch, yaw]
end

function complete_forward_kinematics(q)
    T0E = forward_kinematics(q)
    position = T0E[1:3, 4]
    orientation = forward_kinematics_rpy(T0E)
    return [position, orientation]
end
end # module