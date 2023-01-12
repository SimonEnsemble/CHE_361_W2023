### A Pluto.jl notebook ###
# v0.19.19

using Markdown
using InteractiveUtils

# ╔═╡ a855718e-9078-11ed-2fd1-73a706483e34
begin
	import Pkg; Pkg.activate()
	using DifferentialEquations, CairoMakie, DataFrames
end

# ╔═╡ 0dcc0877-1bfb-4c54-a587-eb1576c15519
set_theme!(theme_ggplot2()); update_theme!(fontsize=18, resolution=(600, 500), linewidth=4)

# ╔═╡ a30a8abb-a625-4453-bf9e-71e3e041ba37
md"## the saline solution production facility

pure water and salt granules are continuously fed into a well-mixed tank at a rate $q(t)$ [L/s] and $w(t)$ [g/s], respectively, to produce saline solution. 

let $c(t)$ [g/L] be the concentration of salt in the solution exiting the tank.
"

# ╔═╡ 72235733-f784-4d4e-8cdc-9392f9739cae
html"<img src=\"https://raw.githubusercontent.com/SimonEnsemble/CHE_361_W2023/main/images/salt_mixer.png\" width=400>"

# ╔═╡ 9f0e6912-5d79-45e5-81d0-f12a4a855fcd
md"in lecture, we derived the following dynamic model for $c(t)$:
```math
\begin{equation}
	V\frac{dc}{dt} = w - qc.
\end{equation}
```
"

# ╔═╡ c9e62bfc-738d-470c-8094-c66e180283df
md"## simulation

suppose:
* the tank has volume $V=10$ L.
* the tank is initially full of pure water, so $c(t=0)=0$.
* the conveyor belt is turned on at $t=0$, giving a constant incoming mass flow rate of salt $w=100$ g/min.
* the incoming flow rate of water is set and maintained at $q=10$ L/min for $t\in[0,8]$ min, but thereafer decreases due to a gradual loss of pressure upstream, at a rate of 0.1 L/min².

simulate $c(t)$ for $t\in[0, 20]$ min."

# ╔═╡ 27efd7e0-24a9-4c14-b515-42c9cd7f521d
md"🦫 define parameters and inputs."

# ╔═╡ 42b4f36a-d164-411b-867d-849bf0b8da26
V = 10.0 # L

# ╔═╡ 4eedb217-f978-40a4-ba86-42355cf51195
c₀ = 0.0 # g / L

# ╔═╡ 3c07c206-3b3e-46c0-90f5-3b542d5e02cb
w = 100 # g / min

# ╔═╡ d98438e4-a27e-482f-9e64-ac7920974dcb
function q(t) # L / min
	if t < 8.0
		return 10.0
	else
		return 10.0 - 0.1 * t
	end
end

# ╔═╡ 6106fccc-fb7c-46f0-9e96-b6d42ac0d98a
q(9.0)

# ╔═╡ bcba0331-ae6b-493b-8a9c-763eb4b07426
md"🦫 we write the model differently for numerical solving it:

```math
\begin{equation}
\frac{dc}{dt}=f(c, \mathbf{p}, t) = \frac{w-c q(t)}{V}
\end{equation}
```
where $\mathbf{p}$ is an optional vector of parameters we do not use here.


!!! note
	we use `DifferentialEquations.jl` (documentation [here](https://docs.juliadiffeq.org/stable/index.html)) to numerically solve (well, approximate the solution to) nonlinear differential equations.
"

# ╔═╡ a1bd034e-b160-4687-8bea-fe7bf8b44c12
f(c, p, t) = (w - c * q(t)) / V

# ╔═╡ 6a10633d-0164-4a6c-a9da-0f7af1f57247
f(c₀, nothing, 0.0) # initial rate of change

# ╔═╡ 2ba54ac2-6b75-4e59-9ad5-5997d1b7555c
time_span = (0.0, 20.0) # min

# ╔═╡ bc95d069-698e-4587-a03e-04c5ea27a9d7
# DifferentialEquations.jl syntax
prob = ODEProblem(f, c₀, time_span, saveat=0.1, d_discontinuities=[8.0])

# ╔═╡ c5d7269b-ba22-4596-a0e6-e2266ad2ccc3
# solve ODE, return data frame
data = DataFrame(solve(prob))

# ╔═╡ 43389dd2-9237-4812-bfe5-a6570f552073
md"🦫 viz the solution.

!!! note
	we use `CairoMakie.jl` to draw data visualizations in this, whose documentation is [here](https://docs.makie.org/stable/).
"

# ╔═╡ 5c1d708e-1442-4a53-941c-5b2013dc34c7
begin
	fig = Figure()
	ax  = Axis(fig[1, 1], xlabel="time, t [min]", ylabel="concentration, c(t) [g/L]")
	lines!(data[:, "timestamp"], data[:, "value"])
	fig
end

# ╔═╡ Cell order:
# ╠═a855718e-9078-11ed-2fd1-73a706483e34
# ╠═0dcc0877-1bfb-4c54-a587-eb1576c15519
# ╟─a30a8abb-a625-4453-bf9e-71e3e041ba37
# ╟─72235733-f784-4d4e-8cdc-9392f9739cae
# ╟─9f0e6912-5d79-45e5-81d0-f12a4a855fcd
# ╟─c9e62bfc-738d-470c-8094-c66e180283df
# ╟─27efd7e0-24a9-4c14-b515-42c9cd7f521d
# ╠═42b4f36a-d164-411b-867d-849bf0b8da26
# ╠═4eedb217-f978-40a4-ba86-42355cf51195
# ╠═3c07c206-3b3e-46c0-90f5-3b542d5e02cb
# ╠═d98438e4-a27e-482f-9e64-ac7920974dcb
# ╠═6106fccc-fb7c-46f0-9e96-b6d42ac0d98a
# ╟─bcba0331-ae6b-493b-8a9c-763eb4b07426
# ╠═a1bd034e-b160-4687-8bea-fe7bf8b44c12
# ╠═6a10633d-0164-4a6c-a9da-0f7af1f57247
# ╠═2ba54ac2-6b75-4e59-9ad5-5997d1b7555c
# ╠═bc95d069-698e-4587-a03e-04c5ea27a9d7
# ╠═c5d7269b-ba22-4596-a0e6-e2266ad2ccc3
# ╟─43389dd2-9237-4812-bfe5-a6570f552073
# ╠═5c1d708e-1442-4a53-941c-5b2013dc34c7
