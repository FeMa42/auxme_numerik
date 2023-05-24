# We need some Plotting package. Makie generates beautiful plots and
# is quite comfortable.
# A lot of  nice exmples can be found on https://beautiful.makie.org
using GLMakie

# So let's define our first multivariate function. What function shall we start
# with? First of all we will use a 2D Function since a 2D function can visualized
# in 3D. The inputs x and y define the point in the x-y plane and the function
# value defines the height of the function at this point. 
# Let's see this in action: A plane is the easiest 2D Function...
function myPlane(x, y)
    return y
end

# We have the function...let's plot it. Well first we need the according data
# structures. x & y is easy, let's say we want to plot from -1 to 1 on both axes:
x = LinRange(-1, 1, 100)
y = LinRange(-1, 1, 100)

# In order to use GLMakie we need z in an array of size 100x100, where
# z[i,j]=myPlane(x[i],y[j]). This array can e.g. be constructed using a loop 
z = Array{Float64}(undef, 100, 100)

for i in eachindex(x)
    for j in eachindex(y)
        z[i, j] = myPlane(x[i], y[j])
    end
end

# Note that a list comprehension is more elegant
z = [myPlane(x[i], y[j]) for i in eachindex(x), j in eachindex(y)]
# We could improve even further using Julia's broadcasting mechanism. Since this
# improves efficiency, but not readibility this is out of scope of this lecture.
# Basically, broadcasting allows evaluation of functions for several values at
# once. For syntax etc. just Google...

# We have everything in place...so let's do the plotzmin, zmax = minimum(z), maximum(z)

# First open a figure
fig = Figure(resolution=(1000, 950), fontsize=22)

# Define some options for the scene
ax = Axis3(
    fig[1, 1],
    perspectiveness=0.5,
    elevation=π / 8,
    azimuth=π / 4,
    zgridcolor=:grey, ygridcolor=:grey, xgridcolor=:grey,
    xlabel="x",
    ylabel="y",
    zlabel="z"
)

#Plot it
sm = surface!(ax, x, y, z; colormap=:viridis, colorrange=(minimum(z), maximum(z)),
    transparency=false)

# We see that visualizing 2D functions is quite straight forward...however at the
# same time visualizing higher dimensions hardly makes any sense. Thus for
# visualization purposes and imaginations of higher dimensional functions
# we will stick to 2D functions. 

# Let's have a look at a further more interesting function:
function myFunc(x, y)
    return (-x * exp(-x ^ 2 - (y)^ 2)) * 4
end

# This time we plot from -2 to 2 in both dimensions
x = LinRange(-2, 2, 1000)
y = LinRange(-2, 2, 1000)

z = [myFunc(x[i], y[j]) for i in eachindex(x), j in eachindex(y)]

zmin, zmax = minimum(z), maximum(z)

fig = Figure(resolution=(1000, 950), fontsize=22)

ax = Axis3(
    fig[1, 1],
    perspectiveness=0.5,
    elevation=π / 8,
    azimuth=π / 4,
    zgridcolor=:grey, ygridcolor=:grey, xgridcolor=:grey,
    xlabel="x",
    ylabel="y",
    zlabel="z"
)

sm = surface!(ax, x, y, z; colormap=:viridis, colorrange=(minimum(z), maximum(z)),
    transparency=false)

# Note that navigating in 3D Plots is cumbersome often times. That's why in many
# cases contour lines are used instead of a full 3D Plot. This is especially true
# in optimization. You have seen contour lines before, 
# e.g. in Google Maps (Gelände View). Basically contour lines just connect points
# that have the same height. With GLMakie we can simply add them:

contour!(ax, x, y, z; levels=20, colormap=:viridis, linewidth=2,
    colorrange=(zmin, zmax), transformation=(:xy, minimum(z)),
    transparency=true)

# Now we have a first understanding of higher dimensional functions, especially
# for 2D functions. That clearly also should help think of 
# "higher than 2 dimensional" functions, even if we can not visualize them 
# properly anymore.

# Next step is adjusting/extending the toolset we have for 1D functions to N-D
# functions. The most important concept for functions is the derivative.
# What was that again?

# --> ExplainEverything (Difference Quotient and Plot with tangent) 
# In 1D: The derivative is the rate of change of f when the input changes. 
# How can that concept be extended to our 2D case (and ND accordingly)?
# Now the input is a vector, i.e. it has several dimensions. So in which
# direction shall the input change. Well, we could fix y and just move in 
# x-direction for example. Alternatively, we could fix x and change y.
# This is the concept of partial derivatives. We consider the change
# of f in each direction separately, i.e. we consider f as a 1D function
# by fixing all arguments but one. This is noted by
# ∂f/∂x, where the ∂ is a special symbol for the partial derivative. It shall
# tell us: This is not the complete derivative, but just the change in one
# direction! How is the partial derivative mathematically defined? Since we 
# consider 1D derivatives, just as we know using the difference quotient. 

# Let's see this in action:
# Partial derivatives.jl




