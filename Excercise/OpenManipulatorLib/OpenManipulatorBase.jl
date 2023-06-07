# OpenManipulatorBase.jl
module OpenManipulatorBase
using RobotOS

# Type Generation
@rosimport std_msgs.msg: Float64
@rosimport open_manipulator_msgs.msg: KinematicsPose, JointPosition
@rosimport geometry_msgs.msg: Pose, Vector3, Point, Quaternion 
@rosimport open_manipulator_msgs.srv: SetJointPosition, SetKinematicsPose, GetJointPosition
@rosimport sensor_msgs.msg: JointState
rostypegen(@__MODULE__)

using .std_msgs.msg: Float64Msg
import .open_manipulator_msgs.msg: KinematicsPose, JointPosition
import .geometry_msgs.msg: Pose, Point, Quaternion
import .open_manipulator_msgs.srv: SetJointPosition, SetJointPositionRequest, SetKinematicsPose, SetKinematicsPoseRequest, GetJointPosition, GetJointPositionRequest
import .sensor_msgs.msg: JointState

export start_gazebo, start_controller, init, set_gripper_position, reset_robot, 
       set_joint_angles, send_goal_joint_space_path, send_goal_task_space_path, 
       send_goal_tool_control, send_goal_task_space_path_position_only, subscribe_to_joint_states, 
       subscribe_to_joint_states_ownCB, JointState, Subscriber, rossleep, close_gazebo

function joint_state_sub_callback(sensor_msg::JointState)
    names = sensor_msg.name
    positions = sensor_msg.position
    velocities = sensor_msg.velocity
    println("Name: $names,  Position: $positions")
    # print("Velocity: ", sensor_msg.velocity)
    # println("Effort: ", sensor_msg.effort)
    return positions, velocities
end

function subscribe_to_joint_states()
    sub = Subscriber{JointState}("/joint_states", joint_state_sub_callback, queue_size=20)
    OpenManipulatorBase.rossleep(0.1)
    # spin()
end

function subscribe_to_joint_states_ownCB(joint_state_sub_callback)
    sub = Subscriber{JointState}("/joint_states", joint_state_sub_callback, queue_size=20)
    OpenManipulatorBase.rossleep(0.1)
    # spin()
end

function start_gazebo()
    run(`roslaunch open_manipulator_gazebo open_manipulator_gazebo.launch`, wait = false)

    println("Waiting for Gazebo to start...")
    sleep(5)
    println("Gazebo hopefully started")
end

function close_gazebo()
    run(`killall -9 gazebo`, wait = false)
    run(`killall -9 gzserver`, wait = false)
    run(`killall -9 gzclient`, wait = false)
    println("Gazebo hopefully closed")
end

function start_controller(is_gazebo=true)
    if is_gazebo
        run(`roslaunch open_manipulator_controller open_manipulator_controller.launch use_platform:=false`, wait = false)
    else
        run(`roslaunch open_manipulator_controller open_manipulator_controller.launch`, wait = false)
    end
    println("Waiting for controller to start...")
    sleep(2)
    println("Controller hopefully started")
end

function init()    
    # initialize node
    RobotOS.init_node("JuliaControl")
    reset_robot()
end

function generate_float_message(data=0.0)
    msg = Float64Msg()
    msg.data = data
    return msg
end

function set_gripper_position(position::Float64)
    pub_gripper = Publisher("/gripper_position/command", Float64Msg, queue_size=10)
    publish(pub_gripper, generate_float_message(position))
    OpenManipulatorBase.rossleep(0.02)
end

function reset_robot()
    OpenManipulatorBase.send_goal_joint_space_path([0.0, 0.0, 0.0, 0.0], 1.0)
    OpenManipulatorBase.rossleep(0.02)
end

function set_joint_angles(angles::Array{Float64})
    if length(angles) != 4
        println("Error: Wrong number of joint angles")
        return
    end
    OpenManipulatorBase.send_goal_joint_space_path(angles, 1.0)
    OpenManipulatorBase.rossleep(0.02)
end

function build_kinematics_pose(goal_point::Array{Float64}, goal_quaternion::Array{Float64})
    if length(goal_point) != 3
        println("Error: Wrong number of goal point")
        return
    end
    if length(goal_quaternion) != 4
        println("Error: Wrong number of goal quaternion")
        return
    end
    p = Point(goal_point[1], goal_point[2], goal_point[3])
    q = Quaternion(goal_quaternion[1], goal_quaternion[2], goal_quaternion[3], goal_quaternion[4])
    
    # generate messagePose
    max_accelerations_scaling_factor = 0.1
    max_velocity_scaling_factor = 0.1
    tolerance = 0.1
    kinematic_pose_message = KinematicsPose(Pose(p, q), max_accelerations_scaling_factor,
                                            max_velocity_scaling_factor, tolerance)
    return kinematic_pose_message
end

function build_joint_position(joint_name::Array{String}, joint_rad_position::Array{Float64}, max_acc::Float64, max_vel::Float64)
    if length(joint_name) != 4 # ["joint1", "joint2", "joint3", "joint4"] -> Example
        println("Error: Wrong number of joint name")
        return
    end
    if length(joint_rad_position) != 4 # [-0.2, -0.1, -0.1, 0.1] -> Example
        println("Error: Wrong number of joint rad position")
        return
    end
    joint_position = JointPosition(joint_name, joint_rad_position, max_acc, max_vel)
    return joint_position
end

function send_goal_joint_space_path(joint_rad_position::Array{Float64}, path_time::Float64)
    if length(joint_rad_position) != 4 # [-0.2, -0.1, -0.1, 0.1] -> Example
        println("Error: Wrong number of joint rad position")
        return False
    end
    my_service_proxy = ServiceProxy{SetJointPosition}("/goal_joint_space_path")
    joint_position = build_joint_position(["joint1", "joint2", "joint3", "joint4"], joint_rad_position, 0.1, 0.1)
    planning_group = "arm" # -> is default
    request = SetJointPositionRequest(planning_group, joint_position, path_time) 
    is_planned = my_service_proxy(request)
    return is_planned # response: is_planned::bool
end

function send_goal_task_space_path(goal_point::Array{Float64}, goal_quaternion::Array{Float64}, path_time::Float64)
    if length(goal_point) != 3
        println("Error: Wrong number of goal point")
        return False
    end
    if length(goal_quaternion) != 4
        println("Error: Wrong number of goal quaternion")
        return False
    end
    my_service_proxy = ServiceProxy{SetKinematicsPose}("/goal_task_space_path")
    kinematic_pose_message = build_kinematics_pose(goal_point, goal_quaternion)
    planning_group = "arm" # -> is default
    end_effector_name = "gripper" # -> is default
    # string end_effector_name    End-Effector name which is relative to the base frame
    request = SetKinematicsPoseRequest(planning_group, end_effector_name, kinematic_pose_message, path_time) 
    is_planned = my_service_proxy(request)
    return is_planned # response: is_planned::bool
end

function send_goal_task_space_path_position_only(goal_point::Array{Float64}, path_time::Float64)
    if length(goal_point) != 3
        println("Error: Wrong number of goal point")
        return False
    end
    my_service_proxy = ServiceProxy{SetKinematicsPose}("/goal_task_space_path_position_only")
    kinematic_pose_message = build_kinematics_pose(goal_point, [0.0, 0.0, 0.0, 0.0])
    planning_group = "arm" # -> is default
    end_effector_name = "gripper" # -> is default
    # string end_effector_name    End-Effector name which is relative to the base frame
    request = SetKinematicsPoseRequest(planning_group, end_effector_name, kinematic_pose_message, path_time) 
    is_planned = my_service_proxy(request)
    return is_planned # response: is_planned::bool
end

function send_goal_tool_control(goal_position::Float64)
    my_service_proxy = ServiceProxy{SetJointPosition}("/goal_tool_control")
    max_acc = 0.1
    max_vel = 0.1
    joint_position = JointPosition(["gripper"], [goal_position], max_acc, max_vel)
    planning_group = "arm" # -> is default
    request = SetJointPositionRequest(planning_group, joint_position, 1.0) 
    is_planned = my_service_proxy(request)
    return is_planned # response: is_planned::bool
end

end # module OpenManipulatorBase