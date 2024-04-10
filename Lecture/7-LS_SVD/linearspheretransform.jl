using GLMakie
using ForwardDiff
using LinearAlgebra
using FileIO

function transform_visualization(maxradius=2.0)
    GLMakie.activate!(; framerate=60, focus_on_show=true)

    icomesh = load(joinpath(@__DIR__, "icosphere.obj"))

    T = Observable(Float32[
        1 0 0 0
        0 1 0 0
        0 0 1 0
        0 0 0 1
    ])

    fig = Figure(resolution=(1920, 1000))

    # 3d scene
    ax = fig[1,1] = Axis3(
        fig,
        perspectiveness=1.0,
        aspect=(1.0, 1.0, 1.0),
        limits=(-maxradius, maxradius, -maxradius, maxradius, -maxradius, maxradius)
    )
    
    wireframe!(
        ax,
        icomesh;
        model=lift(T) do val
            GLMakie.Mat4f(val)
        end,
        transparency = false
    )

    # sliders
    slidergl = GridLayout()

    kwargs = (
        Pair(:range, -maxradius:0.05:maxradius),
        Pair(:format, "{:.2f}")
    )

    slidercolumns = map(1:3) do i
        slidergl[1, i] = sg = SliderGrid(
            fig,
            (startvalue=if 1==i 1 else 0 end, kwargs...),
            (startvalue=if 2==i 1 else 0 end, kwargs...),
            (startvalue=if 3==i 1 else 0 end, kwargs...),
            width = 250,
            tellheight = false
        )

        sg
    end


    for (colid, sc) in enumerate(slidercolumns)
        for (rowid, slider) in enumerate(sc.sliders)
            on(slider.value) do val
                T.val[rowid, colid]=val
                notify(T)
            end
        end
    end

    slidergl[2,2] = identButton = Button(fig, label="reset matrix")

    on(identButton.clicks) do val
        for (colid, sc) in enumerate(slidercolumns)
            for (rowid, slider) in enumerate(sc.sliders)
                set_close_to!(slider, rowid==colid ? 1.0 : 0.0)
            end
        end
    end

    fig[1, 2] = slidergl

    Label(fig[0, 1], L"|\mathbf{T^{-1}} \mathbf{x}| - 1 = 0 \text{ \textbf{approximated} as a wireframe icosphere}", fontsize = 20)
    Label(fig[0, 2], L"\mathbf{T}:\text{ 3x3 transform matrix}", fontsize = 20)

    colsize!(fig.layout, 1, Relative(0.4))
    colsize!(fig.layout, 2, Relative(0.6))

    display(fig)
end

transform_visualization()


##