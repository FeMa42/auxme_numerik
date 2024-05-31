# loosely based on https://beautiful.makie.org/dev/examples/generated/2d/lines3d/wireframe_torus/
module PartialDerivativesPlot
using GLMakie
using ForwardDiff
using LinearAlgebra

export directionalbox!

"""
    directionalbox!(ax, f, tangentPoint, direction, kwargs...)

Draw an illustration of a directional derivative into `ax`. `f` is a function of two variables that defines a surface.

`tangentPoint` (2-element vector) specifies where the linear approximation shall tangent the surface of `f`.

`direction` specifies the direction of interest. Can be an (unnormalized) 2-element vector, `:x` or `:y`.

The keyword arguments should have self-explanatory names.

For best effect, create a surface plot of `f` as well.

"""
function directionalbox!(ax, f, tangentPoint::AbstractVector{<:Real}, direction::AbstractVector{<:Real};
        boxLimits=(-0.5, 0.5),
        drawBox=true,
        zBoxMargin=0.1,
        surfaceLineColor=GLMakie.Colors.HSL(0, 0, 0.0),
        tangentColor=GLMakie.Colors.HSL(0, 0, 0.0),
        boxColor=GLMakie.Colors.HSL(0, 0, 0.0),
        surfaceLineWidth=3,
        tangentLineWidth=5,
        boxLineWidth=2,
        surfaceLineTess=32
    )

    dir = normalize(direction)

    backPoint = @. tangentPoint + boxLimits[1] * dir
    frontPoint = @. tangentPoint + boxLimits[2] * dir

    #surfaceline verts
    xs = LinRange(backPoint[1], frontPoint[1], surfaceLineTess)
    ys = LinRange(backPoint[2], frontPoint[2], surfaceLineTess)
    zs = f(xs, ys)

    # draw surfaceline
    lines!(ax, xs, ys, zs,
        overdraw=true,
        linewidth=surfaceLineWidth,
        color=surfaceLineColor
    )

    # obtain gradient of f at the tangent center point
    g = ForwardDiff.gradient(x->f(x[1], x[2]), tangentPoint)

    zbp = f(tangentPoint...) + g'*(backPoint .- tangentPoint)
    zfp = f(tangentPoint...) + g'*(frontPoint .- tangentPoint)

    # draw tangent line
    lines!(ax,
        [backPoint[1], frontPoint[1]],
        [backPoint[2], frontPoint[2]],
        [zbp, zfp],
        overdraw=true,
        linewidth=tangentLineWidth,
        color=tangentColor
    )

    if drawBox
        zLimits = (
            min(zbp, zfp, minimum(zs)),
            max(zbp, zfp, maximum(zs))
            )
        
        # make sure the box contains the surfaceline and keeps the zBoxMargin in z direction
        zb = Float64[0, 0, 1, 1, 0].*(zLimits[2] - zLimits[1]) .+ zLimits[1] .+ [-1, -1, 1, 1, -1] * zBoxMargin

        boxPoints = (backPoint, frontPoint, frontPoint, backPoint, backPoint)

        xb = [p[1] for p in boxPoints]
        yb = [p[2] for p in boxPoints]

        # draw box
        lines!(ax, xb, yb, zb,
            overdraw=true,
            linewidth=boxLineWidth,
            color=boxColor
        )
    end
end


function directionalbox!(ax, f, tangentPoint, direction::Symbol; kwargs...)

    @assert direction in (:x, :y) "argument `direction` can be a 2-element-vector, `:x` or `:y`, but not $direction"

    if direction == :x
        dir = [1., 0.]
    else
        dir = [0., 1.]
    end

    directionalbox!(ax, f, tangentPoint, dir; kwargs...)
end

end