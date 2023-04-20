function pq_V1(p, q)
    s = p^2
    t = s + q
    u = sqrt(t)
    x = -p + u
    return x
end

function pq_V2(p, q)
    s = p^2
    t = s + q
    u = sqrt(t)
    v = p + u
    x = q / v
    return x
end

p = 1000
q = 0.018000000081

pq_V1(p, q)
pq_V2(p, q)

    




