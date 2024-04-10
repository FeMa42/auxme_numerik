using GLMakie
using ForwardDiff
using LinearAlgebra
using Printf


function calc_limits(A, xopt, b, relmargin=0.5)
    ropt = A*xopt + b

    mins = zeros(size(b, 1))
    maxs = similar(mins)
    widths = similar(mins)

    for i in eachindex(mins)
        mins[i] = min(ropt[i], b[i], 0)
        maxs[i] = max(ropt[i], b[i], 0)
        widths[i] = maxs[i] - mins[i]
    end

    maxwidth = maximum(widths)*(1+relmargin)

    for i in eachindex(mins)
        mins[i] -= maxwidth/2 - widths[i]/2
        maxs[i] += maxwidth/2 - widths[i]/2
    end

    return (mins[1], maxs[1], mins[2], maxs[2], mins[3], maxs[3])
end


function prepareRange(idealValue, factor=1.5, tess=2^7, insert=true)
    start = - factor*abs(idealValue)
    stop = + factor*abs(idealValue)
    range = collect(LinRange(start, stop, tess))

    supremumId = findfirst(range) do el
        el > idealValue
    end

    insert && insert!(range, supremumId, idealValue)
    return range
end


function residual_visualization(A, b, fontsize=20, labelsize=40)
    @assert size(A, 1) == size(b, 1) == 3 "The first dimensions of both A and b have to be 3 for this visualization."
    @assert size(A, 2) == 2 "Dimension 2 of A has to be 2 for this visualization."
    @assert size(b, 2) == 1 "Dimension 2 of b has to be 1."

    # one option to calculate the optimal parameter vector
    xopt = -inv(A'*A)*A' * b

    GLMakie.activate!(; framerate=60, focus_on_show=true)

    fig = Figure(resolution=(1920, 1000))

    Label(fig.layout[0, :], L"\mathbf{r} = \mathbf{A}\mathbf{x} + \mathbf{b}", fontsize=labelsize)

    # layout
    llayout = GridLayout()
    rlayout = GridLayout()

    fig[1, 1] = llayout
    fig[1, 2] = rlayout

    # basis vectors
    basis = [@view(A[:, 1]), @view(A[:, 2])]

    # sliders
    range1 = prepareRange(xopt[1])
    range2 = prepareRange(xopt[2])
    rlayout[2, 1] = sg = SliderGrid(
        fig,
        (range=range1, startvalue=xopt[1]/2, label=L"x_1"),
        (range=range2, startvalue=xopt[2]/2, label=L"x_2"),
        width = 500,
        tellheight = false
    )

    foreach(sg.labels) do label
        label.fontsize[] = labelsize
    end

    foreach(sg.valuelabels) do label
        label.fontsize[] = fontsize
    end

    # optimum button
    rlayout[3, 1] = optbutton = Button(fig, label="move near optimum")

    on(optbutton.clicks) do val
        set_close_to!(sg.sliders[1], xopt[1])
        set_close_to!(sg.sliders[2], xopt[2])
    end

    # 3d plot
    llayout[1, 1] = ax = Axis3(
        fig,
        perspectiveness=1.0,
        aspect=(1.0, 1.0, 1.0),
        limits=calc_limits(A, xopt, b),
        xlabel=L"r_1",
        ylabel=L"r_2",
        zlabel=L"r_3",
        xlabelsize=labelsize,
        ylabelsize=labelsize,
        zlabelsize=labelsize
    )
    
    orig = Point3f(zeros(3))

    p1 = Point3f(b[:])
    
    p2 = lift(sg.sliders[1].value) do val
        Point3f(p1 + val .* basis[1])
    end
    
    p3 = lift(p2, sg.sliders[2].value) do p2, val
        Point3f(p2 + val .* basis[2])
    end

    kwargs = (
        Pair(:linewidth, 4),
        Pair(:markersize, [0, 20])
    )

    scatter!(ax, [orig,], marker=:x, markersize=30)
    lines!(
        ax,
        lift(p3) do p3
            [p3, orig]
        end,
        linewidth=2,
        linestyle=:dash
    )

    # first segment: b to end of 1st basis vector
    scatterlines!(
        ax,
        lift(p2) do p2
            [p1, p2]
        end;
        color=:red,
        kwargs...
    )

    # second segment: end of 1st basis vector to end of 2nd basis vector
    scatterlines!(
        ax,
        lift(p2, p3) do p2, p3
            [p2, p3]
        end;
        color=:green,
        kwargs...
    )

    ## triangle
    normal = cross(basis[1], basis[2])
    offset = (- normal' * reshape([p1[1], p1[2], p1[3]], (:, 1)))[1]

    # calculate z-coordinatnes in the plane spanned by the basis 
    function calc_z(x, y)
        return (-normal[1]*x -normal[2]*y - offset)/normal[end]
    end


    function pointsToCoords(points)
        x = zeros(Float32, 3)
        y = similar(x)
        z = similar(x)

        for (i, p) in enumerate(points)
            x[i] = p[1]
            y[i] = p[2]
            z[i] = p[3]
        end

        return x, y, z
    end
    

    # visualize subset in which p3 can be moved
    function draw_plane(margin=0.1)
        ox = Observable(Float32[0, 0, 0, 0])
        oy = Observable(Float32[0, 0, 0, 0])
        oz = Observable(Float32[0, 0, 0, 0])
        
        color = fill(:lightgray, length(ox[]))
        # indices interpreted as triangles (every 3 sequential indices)
        indices = [1, 2, 3,    1, 3, 4]
        mesh!(ax, ox, oy, oz, indices, color = color, depth_shift=1f-2)

        on(p3) do val
            x, y, z = pointsToCoords((p1, p2[], p3[]))

            # find x/y bounds
            xmin, xmax = extrema(x)
            ymin, ymax = extrema(y)
            
            # apply margin
            xmin, xmax = xmin - margin, xmax + margin
            ymin, ymax = ymin - margin, ymax + margin

            ox.val .= (xmin, xmin, xmax, xmax)
            oy.val .= (ymax, ymin, ymin, ymax)

            oz.val .= map(eachindex(ox[])) do i
                calc_z(ox.val[i], oy.val[i])
            end

            notify(ox)
        end
    end


    draw_plane()

    rlayout[1, 1] = r2layout = GridLayout()

    r2Text = Observable("")
    gradientText = Observable("")
    gradientMagnitudeText = Observable("")

    # r^2 monitor
    Label(
        r2layout[1, 1],
        L"\mathbf{r}^T \mathbf{r}=",
        fontsize=fontsize,
        halign=:right
    )

    Label(
        r2layout[1, 2],
        r2Text,
        fontsize=fontsize
    )

    # gradient monitor
    Label(
        r2layout[2, 1],
        L"\frac{\partial}{\partial \mathbf{x}} \mathbf{r}^T \mathbf{r} = 2\mathbf{A}^T (\mathbf{b} + \mathbf{A} \mathbf{x}) =",
        fontsize=fontsize,
        halign=:right
    )

    Label(
        r2layout[2, 2],
        gradientText,
        fontsize=fontsize
    )

    # gradient magnitude monitor
    Label(
        r2layout[3, 1],
        L"|\frac{\partial}{\partial \mathbf{x}} \mathbf{r}^T \mathbf{r}| =",
        fontsize=fontsize,
        halign=:right
    )

    Label(
        r2layout[3, 2],
        gradientMagnitudeText,
        fontsize=fontsize
    )

    on(p3) do val
        x = [sg.sliders[1].value[], sg.sliders[2].value[]]

        r2 = norm(p3[])^2
        grad = 2*A'*(b + A*x)
        gradmag = norm(grad)

        r2Text[] = @sprintf "%.3e" r2
        gradientText[] = @sprintf "[%.3e, %.3e]" grad[1] grad[2]
        gradientMagnitudeText[] = @sprintf "%.3e" gradmag
    end

    notify(p3)

    colsize!(fig.layout, 1, Relative(0.7))
    colsize!(fig.layout, 2, Relative(0.3))

    display(fig)
end


# m: number of observations     (must be 3 for this visualization)
# n: number of features         (must be 1)
# r: residual vector            [m * 1]
# A: matrix of features         [m * n+1]
# x: model coefficient vector   [n+1 * 1]
# b: vector of targets          [m * 1]

# goal: minimize the magnitude of r = Ax + b

# 1st col: only ones to allow for a constant (w.r.t. the features) offset
# 2nd col: observations made
A = [
    1 -5.0
    1 5.3
    1 10.0
]

# targets / desired model outputs for the observed inputs
b = [
    0.0
    2.0
    1.5
]

residual_visualization(A, b)

