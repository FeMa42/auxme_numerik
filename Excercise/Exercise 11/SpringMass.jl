# SpringMass.Jl 
# This code generates a dataset for the spring-mass problem which is captured by three cameras. 
# This example is from "A Tutorial on Principal Component Analyses" to illustrate the use of 
# PCA by Jonathon Shlens (https://arxiv.org/pdf/1404.1100.pdf). 
# In generate_dataset we first generate the "true" motion of the spring in both the x and y directions 
# (the motion in the y direction is always zero, since the ball doesn't move in this direction). 
# Please, note that we use a simplyfied motion model of a ideal system here. 
# We then generate three sets of data by rotating the true position of the ball into the coordinate 
# system of a camera using an "arbitrary view angle" and adding different levels of Gaussian noise. 
# We combine these three sets of data into a matrix (of shape (1000,6), 1000 samples, 6 since we measure 
# the x and y position in each camera frame) which is then returned by the function generate_dataset. 
# This function also returns the "true" motion of the ball in the x and y direction.

module SpringMass

export generate_true_motion, generate_dataset

using Plots
using LinearAlgebra
using Statistics
using Random

function generate_true_motion(A=2.0)
    # Constants for the motion
    ω = 2π  # angular frequency
    ϕ = 0.0  # phase
    t = 0:0.01:10  # time values

    # Function to generate the motion
    motion(t) = A * cos(ω * t + ϕ)

    # Generate the "true" motion
    x_true = motion.(t)
    y_true = zeros(length(t))  # the ball doesn't move in the y direction
    return x_true, y_true
end

function generate_deviation_motion(A=0.5)
    # Constants for the motion
    ω = 2π  # angular frequency
    ϕ = 0.5π # phase
    t = 0:0.01:10  # time values

    # Function to generate the motion
    motion(t) = A * cos(ω * t + ϕ)

    y_deviation = motion.(t) # now we move the ball also in the y direction
    return y_deviation
end

# Function to generate noisy data
function generate_data(pos_true, θ, noise_level)
    # Rotation matrix
    R = [cos(θ) -sin(θ); sin(θ) cos(θ)]

    # Rotate the true position and add noise
    return R * pos_true .+ noise_level .* randn(size(pos_true))
end


function generate_dataset(amplitude=2.0, noise_level=0.25, amplitude_deviation=0.0)
    # Generate the "true" motion
    x_true, y_true = generate_true_motion(amplitude)

    if amplitude_deviation > 0.0
        y_deviation = generate_deviation_motion(amplitude_deviation)
        y_true = y_true .+ y_deviation
    end

    # Generate data from three cameras with the different noise levels and different angles of view
    data_cam1 = generate_data([x_true y_true]', π / 7.3, noise_level)
    data_cam2 = generate_data([x_true y_true]', π * 1.3, noise_level)
    data_cam3 = generate_data([x_true y_true]', π / 2.5, noise_level)

    # Combine the data into a matrix
    X = hcat(data_cam1', data_cam2', data_cam3')

    return X, x_true, y_true
end # function

end # module