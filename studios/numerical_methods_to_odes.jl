### A Pluto.jl notebook ###
# v0.19.19

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ c110b070-742d-11ec-20d4-d3aa4debfe54
begin
	import Pkg; Pkg.activate()
	using CairoMakie, PlutoUI, Printf
end

# ╔═╡ f0c4e102-16b3-476d-a398-70df362aaf0f
set_theme!(theme_light()); update_theme!(fontsize=20, linewidth=3)

# ╔═╡ 9e45aabc-adfa-440e-82f7-437677a2c36b
TableOfContents()

# ╔═╡ 6b27e69f-5394-4e8b-bbd9-ec1ea169900b
md"
## a conical tank emptying of liquid

🐸 derive (on pencil and paper) a dynamic model of the liquid level, $h=h(t)$ [m], in a conical tank as liquid autonomously flows out of it, through a pipe at the bottom with a small valve providing a narrow constriction for the outflow.

![](https://raw.githubusercontent.com/SimonEnsemble/CHE_361_W2022/main/studios/conical_tank.png#raw)

🚰 **tank geometry** is an inverted, right circular cone (see [here](https://en.wikipedia.org/wiki/Cone)).
* right cone $\implies$ axis passes through the center of the base and is orthogonal to the base
* circular cone $\implies$ base is a circle
* inverted cone $\implies$ base is on the top
* height of the cone is $H$ [m]
* the radius of the circle forming the base is $R$ [m]

🚰 **initial condition**:
* the tank is initially full to the very brim

🚰 **other assumptions**:
* the density of the liquid $\rho$ [kg/m$^3$] is constant 
* flow out of the tank is driven by hydrostatic pressure. the flow rate of liquid out of the tank is related to the liquid level as $c\sqrt{h}$ [m$^3$/s]

your dynamic model should be an ODE in $h=h(t)$ and involve *only* the variables $H$, $R$, $c$, and $h$.

!!! hint
	write a mass balance in differential form. look for two similar triangles.

🚰 my model:
```math
\begin{equation}
\frac{dh}{dt}=f(h)
\end{equation}
```
where
```math
\begin{equation}
f(h):= \text{FILL IN}
\end{equation}
```
"

# ╔═╡ 87faaf32-c035-4578-9474-400f37943bb1
md"
## finite difference methods

**goal**: write code to find the numerical solution to your dynamic model, via a Forward Euler finite difference method, using the parameter settings below.
"

# ╔═╡ d7bc2e84-2c23-4497-995f-39ebde143803
begin
	H = 2.0     # m
	R = 0.4     # m
	c = 0.00175 # m ^ (5/2) / s. 
end

# ╔═╡ a5b69862-2448-4225-bf4e-55e4756de6a9
md"
🐸 declare the initial liquid level as a variable `h₀`. (the tank is initially completely full of liquid.)
"

# ╔═╡ f3c9aa61-fd22-482b-9808-5f423f23dbc9

# ╔═╡ 626e5ea3-ff66-4455-bc05-aafa1725ba74
md"🐸 code up the function `f(h)` above that characterizes the dynamics of $h(t)$ through your differential equation model $\frac{dh}{dt} = f(h)$.
"

# ╔═╡ b7599381-2f2c-4cdf-898b-214a91436597

# ╔═╡ 9760b691-be94-4d8c-a5d0-56568b9810bd
md"
🐸  to set up our finite difference approximation, define the variable representing the time step, `Δt`, as 0.05 s.
"

# ╔═╡ 43e1b7c5-b71c-45c9-85c0-80eb3b9b837a

# ╔═╡ ed761a64-1708-4b85-8cc6-cf83d51342dc
md"🐸 we wish to simulate the model in the time interval $t \in [0, 3]$ min. define the variable `tₙ` as the final time **in seconds**, after we take the `n` time steps to arrive at it."

# ╔═╡ 7993b7e5-3e02-4863-a610-3471008afcb8

# ╔═╡ 3295e2fe-baea-4766-9210-f21f1ec435c1
md"🐸 compute and define `n`, the number of time steps we wish to take, as a variable. assign its value in terms of `Δt` and `tₙ` so that we can change the time step later and have `n` automatically update. 

!!! note
	it's important to make `n` an integer by casting it as an `Int` so we can later write a `for` loop like `for i = 1:n`. you can achieve this by rounding `n` that you computed to the nearest integer. e.g., see what `round(Int, 4.01)` does.
"

# ╔═╡ f27010b6-6f09-4217-9df9-3feb462cb488

# ╔═╡ ee8abcf8-0565-48ff-8d86-9666961907ac
md"🐸 discretize time by constructing an array `t` with the time points $t_i$. ie. element $i$ of the array `t` should be equal to $t_i= \Delta t (i-1)$ for $i \in \{1, 2, ..., n+1\}$. 


!!! note
	the size of the array `t` is `n+1`. we go up to $n+1$ because the first element of `t` should be zero. the last entry of the `t` array should be `tₙ`.

!!! hint
	preallocate an array of zeros. loop through each entry. inside the loop, overwrite the entries with the appropriate value.
"

# ╔═╡ bfdc82ed-b34d-412e-afe7-3529aaeaecd7

# ╔═╡ 84960114-4700-483b-82e1-92711acf8e74
md"
🐸 we will store the approximations to the solution, $h_i \approx h(t_i)$'s, in an array `h`. 

1. pre-allocate the array `h` as an array of zeros, of the appropriate size to correspond to `t`. we'll overwrite these zeros later. ie. entry $i$ of the array `h` will hold our approximation to $h(t_{i-1})$ for $i \in \{1, 2, ..., n+1\}$.
2. assign the first element of `h` to be the initial condition, `h₀`.
"

# ╔═╡ e57b612d-605d-4cbd-bcf8-e1a89ec9259a

# ╔═╡ d284fba1-56f7-42ec-a615-48ddeb4ff903
md"
🐸 implement the forward Euler method to approximate the solution to this ODE and fill in the remaining entries of `h`. march ahead in time for `n` steps, via a `for` loop. 


!!! warning
	use all of the following that you defined earlier:
	* the `h` array
	* the `t` array
	* `Δt`
	* `f(h)`

!!! note
	you should see a `DomainError`. the domain error comes from passing a negative value of $h$ into a square root function contained in $f(h)$. 

	this happens at the time point when the tank is fully emptied and the dynamics are \"over\", but there is a little bit of error originating from the finite difference approximation. to avoid this error, *when the tank finally becomes empty* inside the for loop, stop the time stepping since we know $h(t)=0$ for this time point and beyond.
"

# ╔═╡ b98527cd-2424-417a-9751-cedfafb0fc14

# ╔═╡ fe939caa-a5fa-41c6-9a27-3dd0c82825cb
md"
🐸 plot your numerical solution $h(t)$, via plotting `h` vs `t`.

include an `xlabel` and `ylabel`. be sure to indicate the units. this is proper data visualization practice.

!!! hint
	if you see a little blip in your plot at the point where the tank empties of liquid, you need to assign `h[i]` at that time point to be zero inside your forward Euler routine.
"

# ╔═╡ 59e9b8ca-a72a-4929-8d5f-1402eff23140

# ╔═╡ 10e851c4-0d3c-472f-a585-4be551d2871c
md"
🐸 _observe_: does the liquid level drop faster early in the emptying process or later?

[... your answer here ...]

🐸 _think_: based on the _tank geometry_, do you think the liquid level should drop faster early in the emptying process or later?

[... your answer here ...]

🐸 _think_: based on the liquid level, do you think the liquid level should drop faster early in the emptying process or later?

[... your answer here ...]

🐸 the tank-geometry and hydrostatic pressure are competing effects, then. which dominates?

[... your answer here ...]
"

# ╔═╡ 78298965-50da-4ecd-8648-a118c0da809f
md"## comparing the numerical and analytical solution"

# ╔═╡ bb4755b6-a642-4db1-aa52-798bbeeeea3d
md"🐸 derive an analytical solution to the differential equation for $h(t)$ by separating variables and integrating. 

```math
\begin{equation}
h(t) = ???
\end{equation}
```
"

# ╔═╡ 7e05bec1-3c0b-4d51-81cc-f1b64f50b525
md"🐸 use the analytical solution to determine the time $t_e$ at which the tank empties, ie. the time that the liquid level first reaches zero:
```math
\begin{equation}
	t_e= \arg\min_{t : \hspace{0.4em} h(t)=0} h(t)
\end{equation}
```

compute $t_e$ and assign it as a variable `tₑ` below. is it consistent with your plot above (it should be!)?
"

# ╔═╡ 0d5304e7-74b4-4ff8-82d7-8d6f67419ecf

# ╔═╡ 4b02b8d8-84cb-464c-8619-48409f90047e
md"🐸 plot the analytical solution on top of the numerical solution to ensure they match (they should). since two curves are on the same plot panel, (i) include a legend and (ii) make one of the curves dashed.

!!! note
	the analytical solution has a $\sqrt(\cdot)$ function in it and is valid only for $t<t_e$. for $t>t_e$, $h(t)=0$. thus, when you write a function `h_true(t)` to plot the analytical solution, you must write an `if` statement to check if the `t` is less than or equal to the time at which the tank empties.

!!! hint
	see `axislegend` and `linestyle` in the `CairoMakie.jl` docs [here](https://docs.makie.org/v0.19/examples/blocks/legend/index.html#legend_inside_an_axis) and [here](https://docs.makie.org/v0.19/examples/plotting_functions/lines/index.html#lines).
"

# ╔═╡ 7286859c-6805-421c-ab4e-941d8a314192

# ╔═╡ d6d7af91-31ef-4e57-91bb-042617c40fb0

# ╔═╡ 014466b0-e417-4682-9fd1-f06f5ec16018
md"## interactive viz"

# ╔═╡ 24ad220d-2bd7-412c-9402-0ff44ebdb08e
@bind id_time Clock(0.05, true)

# ╔═╡ fa9e2d30-92ac-4bd9-b823-3f34160c2b67
jump_time = 10;

# ╔═╡ f0e9334c-3fed-43f8-9756-c6c31efa4c1b
function viz_tank(h::Float64, t::Float64, H::Float64, R::Float64)
	fig = Figure()
	ax = Axis(fig[1, 1], title="conical tank", aspect=DataAspect())
	hidedecorations!(ax)
	# liquid
	poly!(Point2f[(0, 0), (R*h/H, h), (-R*h/H, h)], color="lightblue")
	# tank
	lines!([0, R], [0, H], color="black", linewidth=3)
	lines!([0, -R], [0, H], color="black", linewidth=3)
	lines!([-R, R], [H, H], color="black", linewidth=3)
	# stream out
	thickness = sqrt(h / H) / 10
	L = H / 10
	poly!(Point2f[(0.0, 0.0), (-thickness/2, -L), (thickness/2, -L)],
		color="lightblue")

	Label(fig[1, 1], @sprintf("t=%.2f s", t),
		tellwidth=false, tellheight=false, 
		halign=0.9, valign=0.9)
	ylims!(-L, nothing)
	fig
end

# ╔═╡ 90184ca8-3218-4dc4-ad15-a35142d3afa6
viz_tank(id_time * jump_time <= length(h) ? h[id_time * jump_time] : 0.0, id_time * jump_time * Δt, H, R)

# ╔═╡ Cell order:
# ╠═c110b070-742d-11ec-20d4-d3aa4debfe54
# ╠═f0c4e102-16b3-476d-a398-70df362aaf0f
# ╠═9e45aabc-adfa-440e-82f7-437677a2c36b
# ╟─6b27e69f-5394-4e8b-bbd9-ec1ea169900b
# ╟─87faaf32-c035-4578-9474-400f37943bb1
# ╠═d7bc2e84-2c23-4497-995f-39ebde143803
# ╟─a5b69862-2448-4225-bf4e-55e4756de6a9
# ╠═f3c9aa61-fd22-482b-9808-5f423f23dbc9
# ╟─626e5ea3-ff66-4455-bc05-aafa1725ba74
# ╠═b7599381-2f2c-4cdf-898b-214a91436597
# ╟─9760b691-be94-4d8c-a5d0-56568b9810bd
# ╠═43e1b7c5-b71c-45c9-85c0-80eb3b9b837a
# ╟─ed761a64-1708-4b85-8cc6-cf83d51342dc
# ╠═7993b7e5-3e02-4863-a610-3471008afcb8
# ╟─3295e2fe-baea-4766-9210-f21f1ec435c1
# ╠═f27010b6-6f09-4217-9df9-3feb462cb488
# ╟─ee8abcf8-0565-48ff-8d86-9666961907ac
# ╠═bfdc82ed-b34d-412e-afe7-3529aaeaecd7
# ╟─84960114-4700-483b-82e1-92711acf8e74
# ╠═e57b612d-605d-4cbd-bcf8-e1a89ec9259a
# ╟─d284fba1-56f7-42ec-a615-48ddeb4ff903
# ╠═b98527cd-2424-417a-9751-cedfafb0fc14
# ╟─fe939caa-a5fa-41c6-9a27-3dd0c82825cb
# ╠═59e9b8ca-a72a-4929-8d5f-1402eff23140
# ╟─10e851c4-0d3c-472f-a585-4be551d2871c
# ╟─78298965-50da-4ecd-8648-a118c0da809f
# ╟─bb4755b6-a642-4db1-aa52-798bbeeeea3d
# ╟─7e05bec1-3c0b-4d51-81cc-f1b64f50b525
# ╠═0d5304e7-74b4-4ff8-82d7-8d6f67419ecf
# ╟─4b02b8d8-84cb-464c-8619-48409f90047e
# ╠═7286859c-6805-421c-ab4e-941d8a314192
# ╠═d6d7af91-31ef-4e57-91bb-042617c40fb0
# ╟─014466b0-e417-4682-9fd1-f06f5ec16018
# ╠═24ad220d-2bd7-412c-9402-0ff44ebdb08e
# ╟─fa9e2d30-92ac-4bd9-b823-3f34160c2b67
# ╟─f0e9334c-3fed-43f8-9756-c6c31efa4c1b
# ╠═90184ca8-3218-4dc4-ad15-a35142d3afa6
