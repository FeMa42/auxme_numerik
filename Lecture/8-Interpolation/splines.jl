using Plots
# Implementing the original formulation is a bit cumbersome. Better suited is the following basis:

function hatfun(t, k)
    n = length(t) - 1
    return function (x)
        if (k > 0) && t[k] ≤ x ≤ t[k+1]
            return (x - t[k]) / (t[k+1] - t[k])
        elseif k < n && t[k+1] ≤ x ≤ t[k+2]
            return (t[k+2] - x) / (t[k+2] - t[k+1])
        else
            return 0
        end
    end
end

# The hat functions depend on the vector t, i.e. the nodes t_k. But how do they look like?

# Suppose we have nodes at 0,1,2,3
tnodes = [0.0, 1.0, 2.0, 3.0]

# generate the according hat functions
h0 = hatfun(tnodes, 0)
h1 = hatfun(tnodes, 1)
h2 = hatfun(tnodes, 2)
h3 = hatfun(tnodes, 3)

# and plot them
plt = plot(layout=(4, 1), legend=false, xlabel="t", ylims=[-0.1, 1.1], ytick=[])
plot!(h0, 0, 3, subplot=1)
scatter!(tnodes, h0.(tnodes), m=3, subplot=1)
plot!(h1, 0, 3, subplot=2)
scatter!(tnodes, h1.(tnodes), m=3, subplot=2)
plot!(h2, 0, 3, subplot=3)
scatter!(tnodes, h2.(tnodes), m=3, subplot=3)
plot!(h3, 0, 3, subplot=4)
scatter!(tnodes, h3.(tnodes), m=3, subplot=4)

function plinterp(t, y)
    n = length(t) - 1
    H = [hatfun(t, k) for k in 0:n]
    return x -> sum(y[k+1] * H[k+1](x) for k in 0:n)
end

# Let's have a test:

tnodes = [0.0, 1.0, 2.0, 3.0, 4.0]
y = [2.0, 8.0, 4.0, 14.0, 1.0]

p = plinterp(tnodes, y)

plot(p)