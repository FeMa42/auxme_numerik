using CSV                               # CSV Parser
using Plots                             # Graph Plotter
using Statistics                        # statisitical functions, like "mean"
using Dates                             # DateTime formatter / converter

function dateToFloat(date::Dates.Date)
    year = parse(Float64, Dates.format(date, "yyyy"))
    month = parse(Float64, Dates.format(date, "mm")) - 1.0
    year + month/12.0
end

function floatToDate(val::Float64)
    year = floor(val)
    val = (val-year)*12.0
    month = round(val) + 1.0
    Dates.Date(year,month,1)
end

csv = CSV.File(joinpath(@__DIR__, "googleTrends.csv"))      # load and parse csv

x = csv.columns[1].column                      # mask column 1 (Datum)
y = csv.columns[2].column                      # mask column 2 (Suchanfragen)

x_train = x[1:72]                       # take only the first 36 values
y_train = y[1:72]                       # take only the first 36 values

# scatter plot the data
scatter(x_train, y_train, xlabel="Datum", label="Suchinteresse \"Machine Learning\" in Deutschland (Training)", legend=:topleft)

# forward propagation
function forward(x, w, b)
    x * w .+ b
end

# loss function for optimization
function loss(x, y, w, b)
    error = forward(x, w, b)-y
    sqError = error.^2
    mean(sqError)
end


function optimize_grad(x, y, w, b, step)
    n = size(x, 1)
    nx = hcat(ones(n), x)
    nw = vcat([b], w)
    grad = 2.0 / n * nx' * (nx * nw - y)

    currentLoss = loss(x, y, w, b)

    b, w = [b, w] - grad * step

    currentLoss, w, b
end

function train_grad(x, y, numIter, step; print=true)
    w = 0.0
    b = 0.0
    for i in 1:numIter
        currentLoss, w, b = optimize_grad(x, y, w, b, step)
        if print
            println("Iteration: $i   Loss: $currentLoss")
        end
    end
    w, b
end

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

# data pre processing
x_train, y_train = dataPreProcess(x_train, y_train)

# actual training 4000 iterations with stepsize 0.01
# w, b = train(x_train, y_train, 4000, 0.01)
w, b = train_grad(x_train, y_train, 4000, 0.01)

# generate plotting data
x_plot = x_train
y_plot = forward(x_plot, w, b)

# plotting data post processing
x_plot, y_plot = dataPostProcess(x_plot, y_plot)

# plot what we just learned
plot!(x_plot, y_plot, label="Gelerntes Suchverhalten (Training)")

############################################################################################################
# Try with a simple neural network using Flux
using Flux

# forward propagation, our new forward function
function forward(X)
    model(X)
end

# loss function for optimization
loss(y_hat, y) = sum((y_hat .- y) .^ 2)


opt = ADAM()
model = Chain(Dense(1, 16, relu), # input layer
              Dense(16, 8, relu), # one hidden layer
              # Dense(128, 16, relu), # one hidden layer
              Dense(8, 1, identity)) # output layer

# Data 
x_train = x[1:36]                       # take only the first 36 values
y_train = y[1:36]                       # take only the first 36 values
x_train, y_train = dataPreProcess(x_train, y_train)
x_train = reshape(x_train, 1, :)
y_train = reshape(y_train, 1, :)

# train the model
numIter = 10000
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


