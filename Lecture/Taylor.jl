using Plots

# Define f
function f(x)
    -0.1 * x^4 - 0.15 * x^3 - 0.5 * x^2 - 0.25 * x + 1.2
end


# True value of f at 1
f(1)

# Take alook at the plot
fig = plot()
plot!(fig, f, [0:0.01:1.5], label="f")

# Define the Taylor series'

# First Derivative of f
function d_f(x)
    -0.4 * x^3 - 0.45 * x^2 - x - 0.25
end

# Second derivative of f
function d_d_f(x)
    -1.2 * x^2 - 0.9x - 1
end

# Taylor series with only the constant part
function f_0(h)
    f(0)
end

error = f(1) - f_0(1)

# Plot it
plot!(fig, f_0, [0:0.01:1.5], label=f_0)

# Taylor series with constant and linear part --> Linearization of f_0
function f_1(h)
    f(0) + d_f(0) * h
end

error = f(1) - f_1(1)

# Plot it
plot!(fig, f_1, [0:0.01:1.5], label=f_1)

# Taylor series with constant, linear part and quadratic part
function f_2(h)
    f(0) + d_f(0) * h + 1 / 2 * d_d_f(0) * h^2
end

error = f(1) - f_2(1)

# Plot it
plot!(fig, f_2, [0:0.01:1.5], label=f_2)


# Outlook...for those who are interested. A taylot model is a taylor polynomial together with an interval bounding the remainder
using TaylorSeries, TaylorModels

# Define TS as a TaylorSeries
TS = Taylor1(Float64, 10)

# This gives the TaylorSeries of exp(x) around 0 on the interval [-1,1] with 6 summands
texp = exp(TS)

tsin = sin(TS)
#Let's have a look
fig = plot()
x = range(-5, 5, length=100)
yexp = tsin.(x)
ysin = sin.(x)

plot!(fig,x,ysin)
plot!(fig,x, yexp)

# Check a more challenging function

function myFunc(x)
return 1/(1-x)
end

TS = Taylor1(Float64, 1000)
tmyFunc = myFunc(TS)


fig = plot()
x = range(-0.5, 0.5, length=100)
y = myFunc.(x)
yt = tmyFunc.(x)

plot!(fig,x,y)
plot!(fig,x, yt)



# Define Tm as a TaylorModel, i.e. a Taylor Series with 6 summands around 0 on the interval [-1,1]
TM = TaylorModel1(5, interval(0), -1 .. 1)

# This gives the TaylorModel of exp(x) around 0 on the interval [-1,1] with 6 summands
texp = exp(TM)

# This gives the TaylorModel of sin(x) around 0 on the interval [-1,1] with 6 summands
tsin = sin(TM)

# TaylorModels can be multiplied etc.
s = texp + tsin
p = texp * tsin

# The guranteed function range can be determined...
@show TaylorModels.bound_taylor1(TM)
@show TaylorModels.bound_taylor1(p)
@show TaylorModels.bound_taylor1(s)

@show TaylorModels.bound_taylor1(texp)