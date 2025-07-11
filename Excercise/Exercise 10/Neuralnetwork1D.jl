import Pkg                                          # Package manager
Pkg.activate(joinpath(@__DIR__, "NeuronaleNetze"))  # activate package environment
using CSV                               # CSV Parser
using Plots                             # Graph Plotter
using Statistics                        # statisitical functions, like "mean"
using Dates                             # DateTime formatter / converter

# Try with a simple neural network using Flux
using Flux

function dateToFloat(date::Dates.Date)
    year = parse(Float64, Dates.format(date, "yyyy"))
    month = parse(Float64, Dates.format(date, "mm")) - 1.0
    year + month/12.0
end

function floatToDate(val::Float64)
    year = ...
    val = ...
    month = ...
    Dates.Date(year, month, 1)
end

csv = CSV.File(joinpath(@__DIR__, "googleTrends.csv"))      # load and parse csv

x = csv.columns[1].column                      # mask column 1 (Datum)
y = csv.columns[2].column                      # mask column 2 (Suchanfragen)

x_train = x[1:36]                       # take only the first 36 values
y_train = y[1:36]                       # take only the first 36 values

# scatter plot the data
scatter(x_train, y_train, xlabel="Datum", label="Suchinteresse \"Machine Learning\" in Deutschland (Training)", legend=:topleft)

# data pre procseeing (make it machine learning frindly)
function dataPreProcess(x::Array{Date}, y)
    x = dateToFloat.(x)
    x = x .- 2015.0
    x, y
end

# data post procseeing (make it human frindly)
function dataPostProcess(x::Array{Float64}, y)
    x = x .+ 2015.0
    x = floatToDate.(x)
    x, y
end


opt = ADAM(0.01)
# TODO: 
model = Chain(Dense(1, ..., ...), # input layer, example: Dense(1, 8, tanh)
              ...
              Dense(..., 1, identity)) # output layer

# forward propagation, our new forward function
# we don't really need this but keeps it consistent with the linear regression
function forward(X)
    model(x)
end

# loss function for optimization, MSE 
loss(y_hat, y) = ...

# Data 
x_train, y_train = dataPreProcess(x_train, y_train)
x_train = reshape(x_train, 1, :)
y_train = reshape(y_train, 1, :)

# train the model
numIter = 8000
trainLoss = zeros(numIter)
trainAccuracy = zeros(numIter)
opt_state = Flux.setup(opt, model)
for i in 1:numIter
    Flux.train!(model, [(x_train, y_train)], opt_state) do m, x, y
        loss(m(x), y)
    end
    trainLoss[i] = loss(model(x_train), y_train)/length(y_train)
end

plot(1:numIter, trainLoss, label="Train", xlabel="Iterations", ylabel="loss")

# generate plotting data
x_plot = x[1:72]
x_plot, y_plot = dataPreProcess(x_plot, y[1:72])
x_plot = reshape(x_plot, 1, :)
y_plot = forward(x_plot)

x_plot = reshape(x_plot, :)
y_plot = reshape(y_plot, :)

# plotting data post processing
x_plot, y_plot = dataPostProcess(x_plot, y_plot)

# scatter plot the data
scatter(x[1:72], y[1:72], xlabel="Datum", label="Suchinteresse \"Machine Learning\" in Deutschland (Training)", legend=:topleft)
# plot what we just learned
plot!(x_plot, y_plot, label="Gelerntes Suchverhalten (Training)")