import Pkg 
Pkg.activate("test_fd")
using FiniteDifferences
using Printf

# defining a function and its derivative
function f(x)
    x^2+sin(x)
end

function df(x)
    2*x+cos(x)
end

# Point where we want to approximate the derivative
x = 2.

# testing the finite difference methods for the function f(x) = x^2+sin(x)
central_fdm(2, 1)(f, x) # 2 is the number of points and 1 is the order of the derivative
forward_fdm(2, 1)(f, x)
df(2)
error_cforward= abs(forward_fdm(2, 1)(f, 2) - df(2))
error_central = abs(central_fdm(2, 1)(f, 2) - df(2))

# Lets implement our own finite difference method where we can choose the step size eps
function FiniteDifferenceMethod(x::AbstractVector{<:Real}, eps::Real)
    function approx(f, i)
        forward = (f(x[i]+eps) - f(x[i])) / eps
        backward = (f(x[i]) - f(x[i]-eps)) / eps
        central = (f(x[i]+eps) - f(x[i]-eps)) / (2*eps)
        forward, backward, central
    end
    approx
end

# let's test our implementation for different eps
eps1 = 1e-2
eps2 = 1e-10
forward1, backward1, central1 = FiniteDifferenceMethod([x], eps1)(f, 1)
forward2, backward2, central2 = FiniteDifferenceMethod([x], eps2)(f, 1)

@printf("With eps = %.2e:\n", eps1)
@printf("Forward difference approximation: %.6f\n", forward1)
@printf("Central difference approximation: %.6f\n", central1)
@printf("Error forward difference approximation: %.10f\n", abs(forward1 - df(2)))
@printf("Error central difference approximation: %.10f\n", abs(central1 - df(2)))
@printf("\nWith eps = %.2e:\n", eps2)
@printf("Forward difference approximation: %.6f\n", forward2)
@printf("Central difference approximation: %.6f\n", central2)
@printf("Error forward difference approximation: %.10f\n", abs(forward2 - df(2)))
@printf("Error central difference approximation: %.10f\n", abs(central2 - df(2)))


# plotting the error of the forward and central difference approximation for x from 0 to 10
using Plots
x = range(0, stop=10., length=1000)
df_fd = []
df_cd = []
for x_tmp in x
    df_tmp = FiniteDifferenceMethod([x_tmp], eps1)(f, 1)
    push!(df_fd, df_tmp[1]-df(x_tmp))
    push!(df_cd, df_tmp[3]-df(x_tmp))
end
p1 = plot(x, df_fd, label="err(x)" , title="forward eps = $(eps1)", xlabel="x", ylabel="error")
p2 = plot(x, df_cd, label="err(x)" , title="central eps = $(eps1)", xlabel="x", ylabel="error")
plot(p1, p2)

# plotting the error for different eps of the forward and central difference approximation
eps = range(1e-10, stop=1e-1, length=1000)
df_fd_eps_err = []
df_cd_eps_err = []
for eps_tmp in eps
    df_tmp = FiniteDifferenceMethod([2.], eps_tmp)(f, 1)
    push!(df_fd_eps_err, df_tmp[1]-df(2.))
    push!(df_cd_eps_err, df_tmp[3]-df(2.))
end
p3 = plot(eps, df_fd_eps_err, label="err(eps)" , title="forward", xlabel="eps", ylabel="error")
p4 = plot(eps, df_cd_eps_err, label="err(eps)" , title="central", xlabel="eps", ylabel="error")
plot(p3, p4)

# We can see that the central difference approximation is of order O(eps^2) 
# It increases quadratically with eps and is smaller than the forward difference approximation
