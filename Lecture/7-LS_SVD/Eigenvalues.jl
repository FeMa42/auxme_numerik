# What would be the easiest approach one could think of. I guess that would be a fixed-point iteration. Let's have
# a try:

A = [1.0 3.0 5.0;5.0 24.0 8.0;2.0 9.0 11.0]

rank(A)
eigvals(A)
eigvecs(A)

v = [1.0,1.0,1.0]

for i=1:100
    v = A*v
end

# this seems to diverge
v

# Try normalization

v = [1.0,1.0,1.0]

for i=1:1000
    v = A*v/norm(v,2)
end

#this seems to converge...but what is the limit? --> Explain Everything

#--> Back from Explain Everything: let's do a quick check
v
lambda = norm(A*v,2)/norm(v,2)

#Ok...so it converges to an eigenvector. Let's try to get more eigenvectors

u = [5.0,1.0,3.0]
v = [1.0,-1.0,1.0]

for i=1:1000
    # Power iteration
    u = A*u/norm(A*u,2)
    v = A*v/norm(A*v,2)
    
    #orthogonalization
    u_hat = u/norm(u,2)
    u = dot(v,u_hat)*u_hat
    v = v-u
end
v/norm(v,2)
u/norm(u,2)

eigvecs(A)

# This does not seem to work. Different start values bunch up in the same eigenvector. How could we solve that?
# One idea would be to orthogonalize the vectors after every iteration --> Explain everything