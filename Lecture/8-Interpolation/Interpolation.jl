using Plots

# Lagrange intzerpolation polynom
function LagrangeInterp1D(fvals, tnodes, barw, t)
    numt = 0
    denomt = 0

    for j in eachindex(tnodes)
        tdiff = t - tnodes[j]
        numt = numt + barw[j] / tdiff * fvals[j]
        denomt = denomt + barw[j] / tdiff

        if (abs(tdiff) < 1e-15)
            numt = fvals[j]
            denomt = 1.0
            break
        end
    end

    return numt / denomt
end

# Equispaced points
EquispacedNodes(n) = [2 * (j / n - 0.5) for j = 0:n]
EquispacedBarWeights(n) = [(-1)^j * binomial(n, j) for j = 0:n]

# Sampling
n = 50;
tnodes = EquispacedNodes(n);
w = EquispacedBarWeights(n);
sin_sample = sin.(tnodes)

# Interpolation
t = LinRange(-1, 1, 100)
sin_interp = [LagrangeInterp1D(sin_sample, tnodes, w, t[j]) for j in eachindex(t)]

# Plot the interpolated sine
plot(t, sin.(t), label="Exact", marker=3)
plot!(t, sin_interp, label="Interp", marker=3)
# This looks quite nice until here...


using Polynomials
# In Julia you can however just use the fit function of Polynomials.jl
scatter(tnodes,sin_sample,label="data",leg=:top)
tnodes = range(-1,1,length=n+1)
p = Polynomials.fit(tnodes,sin_sample,15)
plot!(p,-1,1,label="interpolant")

# This looks quite nice, but let's have a look at a more challenging function
# Runge's function
f(x) = 1 / (1 + 16 * x^2)
f_sample = f.(tnodes);
f_interp = [LagrangeInterp1D(f_sample, tnodes, w, t[j]) for j in eachindex(t)]


# Let's have alook at the result again
scatter(tnodes, f_sample, label="data", leg=:top)
p = Polynomials.fit(tnodes, f_sample, 50)
plot!(p, -1, 1, label="interpolant")