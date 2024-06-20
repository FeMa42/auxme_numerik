using Plots
using LinearAlgebra
using Statistics
using Random

# Constants for the motion
A = 2.0  # amplitude
ω = 2π  # angular frequency
ϕ = 0.0  # phase
t = 0:0.01:10  # time values

# Function to generate the motion
motion(t) = A * cos(ω * t + ϕ)

# Generate the "true" motion
x_true = motion.(t)
y_true = zeros(length(t))  # the ball doesn't move in the y direction

# Plot the "true" motion
p = plot(t, x_true, label="True Motion", title="True Motion of the Ball", xlabel="Time", ylabel="x")

# Function to generate noisy data
function generate_data(pos_true, θ, noise_level)
    # Rotation matrix
    R = [cos(θ) -sin(θ); sin(θ) cos(θ)]
    
    # Rotate the true position and add noise
    return R * pos_true .+ noise_level .* randn(size(pos_true))
end

# Generate data from three cameras with the different noise levels and different angles of view
data_cam1 = generate_data([x_true y_true]', π/4.3, 0.25)
data_cam2 = generate_data([x_true y_true]', π*1.3, 0.15)
data_cam3 = generate_data([x_true y_true]', π/3.5, 0.2)

# Scatter Plot the 2-dim data
p1 = scatter(data_cam1[1, :], data_cam1[2, :], label="Camera 1")
p2 = scatter(data_cam2[1, :], data_cam2[2, :], label="Camera 2")
p3 = scatter(data_cam3[1, :], data_cam3[2, :], label="Camera 3")
plot(p1, p2, p3, title="Scatter Plot of Data", xlabel="x", ylabel="y")

# Combine the data into a matrix
X = vcat(data_cam1', data_cam2', data_cam3')

# Perform PCA
μ = mean(X, dims=1)  # compute the mean
X_centered = X .- μ  # center the data
Σ = X_centered' * X_centered / (size(X, 1) - 1)  # compute the covariance matrix
λ, V = eigen(Σ)  # compute the eigenvalues and eigenvectors

# The principal components are given by the eigenvectors
PCs = V

# The first principal component corresponds to the direction of greatest variance
PC1 = PCs[:, end]

# Project the data onto the first principal component
X_projected = X_centered * PC1

# Plot the projected data
p = plot(X_projected, label="Projected Data", title="Data Projected onto First Principal Component")
display(p)

PC2 = PCs[:, 1]
X_projected2 = X_centered * PC2

# Plot the projected data
p = plot(X_projected2, label="Projected Data", title="Data Projected onto Second Principal Component")

# Compute the variance explained by each principal component
var_explained = λ ./ sum(λ)

println("Variance explained by each principal component: ", var_explained)

# Plot the variance explained
p1 = bar(1:length(var_explained), var_explained, title="Variance Explained by Each Principal Component", xlabel="Principal Component", ylabel="Variance Explained")

# Plot the projected data
p2 = plot(X_projected, label="Projected Data", title="Data Projected onto First Principal Component")

# Display the plots
plot(p1, p2, layout=(2, 1))
