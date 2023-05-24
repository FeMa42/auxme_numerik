#We want to extend standard operators like +, thus we need to import (not use) Base
import Base: +, *

#First we define our Dual numbers as strcuts with two members. The value and the derivative. 
# Duals are btw defined for arbitrary data types. For some clearly it doesn't make sense though.
struct Dual{T}
    val::T   # value
    der::T  # derivative
end

# Next we extend the standard operator + for Duals according to our calculations.
+(f::Dual, g::Dual) = Dual(f.val + g.val, f.der + g.der)
# The same for *
*(f::Dual, g::Dual) = Dual(f.val * g.val, f.der * g.val + f.val * g.der)

# We will need these later. However, no-brainers.
+(f::Dual, α::Number) = Dual(f.val + α, f.der)
+(α::Number, f::Dual) = f + α

*(α::Number, f::Dual) = Dual(f.val * α, f.der * α)
*(f::Dual, α::Number) = α * f



# Lets have a test. We implement the function from the example:
function myf(x)
    x * x + x + x
end

#We evaluate f at a=3 and want to know the derivative 
# Dual(3,1) correspponds to 3+1*epsilon. --> 3^2+2*3=15, 2*3+2=8
a = Dual(3, 1)
myf(a)

#Clearly a good AD package needs also basic functions like exp()
import Base: exp

# Then we need to extend the basic function. What is the derivative we need to implement here? Remember this needs to be the derivative exp(f(a))! 
# Reason: Input is a dual that is the result a previous function evaluation (maybe only identity).
# So what is the dervative of exp(f(a)) (chainrule)?  
# The implemented basic functions are called primitives
exp(f::Dual) = Dual(exp(f.val), exp(f.val) * f.der)
exp(a)


# Still one problem is left! So far we can only autodiff functions with one argument, i.e. functions mapping to the real numbers
# So what about functions like f(x,y). Let's have a look at an example
function myf2(x, y)
    x*x + x*y
end


# Let's investigate the function and it's derivatives at (x,y)=(2,3)
a, b = 2, 3
# What do we expect to get or at least would like to get? The gradient! How was it calculated? It contains the partial derivatives of f wrt its arguments.
# Luckily, the partial derivative is calculated by varying one component and fixing the others! 
# This is a perfect match since we can only differentiate scalar functions
# So let's generate scalar functions, by fixing all components but one:
f_1(x) = myf2(x, b)
f_2(x) = myf2(a, x)
# For these functions we can compute the dervative, i.e. the partial derivative of f. All we need to do is feed them with Duals!
aDual = Dual(2, 1)
bDual = Dual(3, 1)
f_1(aDual)
f_2(bDual)
# Thus we can compute the gradient. Only thing: We need two function evaluations! In general n...
#But this can be done in a more effcient way

using StaticArrays
struct MultiDual{N,T}
    val::T
    derivs::SVector{N,T}
end

import Base: +, *

function +(f::MultiDual{N,T}, g::MultiDual{N,T}) where {N,T}
    return MultiDual{N,T}(f.val + g.val, f.derivs + g.derivs)
end

function *(f::MultiDual{N,T}, g::MultiDual{N,T}) where {N,T}
    return MultiDual{N,T}(f.val * g.val, f.val .* g.derivs + g.val .* f.derivs)
end


gcubic(x, y) = x*x*y + x + y

(a, b) = (1.0, 2.0)

xx = MultiDual(a, SVector(1.0, 0.0))
yy = MultiDual(b, SVector(0.0, 1.0))

gcubic(xx, yy)





# We omit the implementation for abritrary dimensions. If you are interested, take a look at the SciML Book
# https://book.sciml.ai/notes/08

