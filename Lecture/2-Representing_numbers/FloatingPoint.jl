using Plots

# Let's have a look at some arbitrary number
bitstring(13.5)

# Get sign, exponent and mantissa...
sign(13.5)
significand(13.5)
exponent(13.5)

# Quick check
significand(13.5) * 2^exponent(13.5)

# ...and compare with the according bitsring-sections (not relying on Black-Box Julia Functions)
MyBitstring = bitstring(13.5)
length(MyBitstring)
MySign = MyBitstring[1]
#negative sign is shown by 1, positive sign by 0

MyExponent = MyBitstring[2:12]
#Most significant in front
2^10 + 2^1
# To avoid arithmetic with sign for exponent computations the exponent is shifted to only positive values, i.e. + 1023
2^10 + 2^1 - 1023

MyMantissa = MyBitstring[13:64]
2^(-1) + 2^(-3) + 2^(-4)
parse(Int, MyMantissa, base=2)/2^52
# Using Parse() we need to shift because computation is 2^string[1]+2^string[2]....
# Appearantly, the same as above. BUT: 2^0 ist not save explicitly. Thus, one digit is saved, thus higher accuracy equivalent to mantissa with one more digit

# Clearly, we could do the same with other data types, e.g. floats
typeof(-3.17f0)
bitstring(-3.17f0)
length(bitstring(-3.17f0))

x = Float16(1.0)
bitstring(x)
length(bitstring(x))

y = nextfloat(x)

xs = [x]

typeof(xs)

xs

push!(xs, 37)

xs

function all_floats(n)

    x = Float16(1.0)   # local variable
    data = [x]   # 1D array -- vector

    for i in 1:n
        x = nextfloat(x)

        push!(data, x)   # extend the vector xs with the current value of x
    end

    return data

end

data = all_floats(100)
scatter(data, legend=false)   # no x coordinates -- uses 1, 2, 3, 4
# Up to now, the distance between the Float16s seems constant
# Let's have a deeper look

diff(data)   # differences between consecutive data
# The values are constant, BUT: Why isn't it 0.001? Obviously there is a loss of accuracy in the computation. We will come back to that!
# But for now, let's have a llok at more numbers. As long as the exponent is constant the distance stays the same...this equivalent to counting

data = all_floats(1000)
scatter(data, legend=false)   # no x coordinates -- uses 1, 2, 3, 4
#Same

data = all_floats(3000)
scatter(data, legend=false)   # no x coordinates -- uses 1, 2, 3, 4

# Now we see that the distcance between Float16s increases with higher numbers.
# That happens for all floats and is also quite obvious since the exponent is multiplied with the mantissa.

# Next question: What is the smallest number greater than 1?
nextfloat(1.0) - 1.0
# According to above, we can just count forward and get for the difference an increase in the last digit of the mantissa and thus
2.0^(-52)


# This number ist called machine epsilon or "Maschinenkonstante"
eps(1.0)
eps(2.0)

# What happens to numbers that can not be represented?
# We need rounding!
Float32(pi)

# Return to calculations for the relative rounding error and arithmetic



# Come back for some interesting effects
0.1+0.1+0.1 == 0.3

0.1 == 1//10

# Why is that? 
significand(0.1)
# 0.6 can not be represented as a finite binary (the leading 1 is implicitly stored)

MyBitstring = bitstring(0.1)
length(MyBitstring)
MyMantissa = MyBitstring[13:64]

f = parse(Int, MyMantissa, base=2)/2^52


# Overflow, underflow and special values
x = factorial(20)

x*21
#This is abviously wrong. Note that x is an Integer. For integers there are no warnings

# For floats an overflow results in Inf
x = 1.5^2000
bitstring(x)

#NaN is for non defined operations
y = 0.0/0.0
bitstring(y)


#Underflow gives zero
1e-400