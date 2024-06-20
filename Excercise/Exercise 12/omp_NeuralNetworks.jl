import Pkg                                          # Package manager
Pkg.activate(joinpath(@__DIR__, "NeuronaleNetze"))  # activate package environment
using CSV                                           # CSV Parser
using Plots                                         # Graph Plotter
using Statistics                                    # statisitical functions, like "mean"
using Flux                                          # Machine Learning Library
using ReverseDiff                                   # Reverse Mode Automatic Differentiation
using Metal                                         # GPU Programming Library

# data pre procseeing (make it machine frindly)
function dataPreProcess(x, y)
    # x = Float32.(x)
    # y = Float32.(y)
    x = (x .- mean_x) ./ std_x
    y = (y .- mean_y) ./ std_y
    x, y
end

# data post procseeing (make it human frindly)
function dataPostProcess(x, y)
    x = (x .* std_x) .+ mean_x
    y = (y .* std_y) .+ mean_y
    x, y
end

# forward propagation, our new forward function
function forward(X)
    model(X)
end

# loss function for optimization
function loss(y_hat, y)
    sum((y_hat .- y) .^ 2)
end

function load_csv_data(filename)
    csv = CSV.File(filename)      # load and parse csv
    x_1 = Float32.(csv.columns[3].column)                      # mask column 4 (Present Position)
    x_2 = Float32.(csv.columns[4].column)                      # mask column 6 (Goal Position)
    x_3 = Float32.(csv.columns[7].column)                      # mask column 6 (Present Velocity)
    y = Float32.(csv.columns[5].column)                      # mask column 6 (Present Current)
    x_train = hcat(x_1, x_2, x_3)'
    y_train = y
    y_train = reshape(y_train, 1, :)
    x_train, y_train
end

# load training data
x_train, y_train = load_csv_data(joinpath(@__DIR__, "OMP_Daten/pc-train.csv"))                   

x_train = x_train |> gpu 
y_train = y_train |> gpu

# Data Preprocessing
mean_x = Float32.(mean(x_train))
mean_y = Float32.(mean(y_train))
std_x = Float32.(std(x_train))
std_y = Float32.(std(y_train))
x_train, y_train = dataPreProcess(x_train, y_train)

# load test data
x_test, y_test = load_csv_data(joinpath(@__DIR__, "OMP_Daten/pc-test.csv"))
x_test, y_test = dataPreProcess(x_test, y_test)

x_test = x_test |> gpu
y_test = y_test |> gpu

# define our model
opt = ADAM(0.001) # optimizer
model = Chain(Dense(3, 32, relu), # input layer
              Dense(32, 32, relu), # one hidden layer
    Dense(32, 1, identity)) |> gpu # output layer 

# train the model
numIter = 10000
trainLoss = zeros(numIter)
testLoss = zeros(numIter)
opt_state = Flux.setup(opt, model)
for i in 1:numIter
    Flux.train!(model, [(x_train, y_train)], opt_state) do m, x, y
        loss(m(x), y)
    end
    trainLoss[i] = loss(model(x_train), y_train)/length(y_train)
    # test the model
    testLoss[i] = loss(forward(x_test), y_test) / length(y_test)
end

# plot the loss
plot(1:numIter, trainLoss, label="Train Loss", xlabel="Iterations", ylabel="loss")

# plot the accuracy
plot!(1:numIter, testLoss, label="Test Loss", xlabel="Iterations", ylabel="loss")

y_hat = forward(x_train)

# plot the results
plot(y_train[1, :], label="Ground Truth (train)", ylabel="Current")
plot!(y_hat[1, :], label="Prediction (train)")

# test the final model
y_hat = forward(x_test)
error = sum((y_hat .- y_test) .^ 2) / length(y_test)
println("Test Error: ", error)

# post process the data (make it human readable)
x_test, y_test = dataPostProcess(x_test, y_test)
_, y_hat = dataPostProcess(x_test, y_hat)

# plot the results
plot(y_test[1, :], label="Ground Truth (test)", ylabel="Current")
plot!(y_hat[1, :], label="Prediction (test)")

# error in human readable form
error = y_hat .- y_test

# plot the error
plot!(error[1, :], label="Error", ylabel="Error")

