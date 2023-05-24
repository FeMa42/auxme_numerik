# (x+ϵ)−x is ϵ in the real world. Let's have a look what the computer does:
ϵ = 1e-10rand()
(1+ϵ)
ϵ2 = (1+ϵ) - 1
(ϵ - ϵ2)

# Why is that?
# We have learned that with 64Bits you have ~16 digits of accuracy.
# We know that e.g. because of 1+ϵ = 1 and ϵ ≈ 1e-16
# But floating point accuracy is relative:

eps(0.1)
eps(0.01)

# Thus not every operation has that accuracy!
# If we have numbers from different scales trouble might happen.
# This means: if we compute 1 + ϵ with ϵ≈1e-10, 
# then the results is correct for the digits that can be represented, 
# 10 digits are lost due to the round-off error
# If we substract 1 again we won't get them back!
# What does that mean for finite differencing?