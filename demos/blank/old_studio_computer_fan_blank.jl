### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ fdb809e2-8529-11ec-2cce-db853e9d397a
begin
    import Pkg; Pkg.activate();
    using Controlz, CairoMakie
end

# ╔═╡ 22cdde6c-9880-4eae-a5dd-35435ea539b5
set_theme!(Controlz.cool_theme)

# ╔═╡ df9ee53f-a59a-4496-9fe2-89f688bd13b7
md"## simulating GPU cooling via a fan

![](https://raw.githubusercontent.com/SimonEnsemble/CHE_361_W2023/main/images/GPU_cooling_fan.png)

## dynamic model
variables:
*  $\theta_a(t)$: air temperature [input]
*  $q(t)$: heat generated by GPU during its computation [input]
*  $\theta(t)$: temperature of the GPU [output]

let $\bar{\theta_a}$, $\bar{q}$, and $\bar{\theta}$ be the steady-state value values of the variables

the dynamic model is
```math
	C\frac{d\theta}{dt} = q + UA[\theta_a-\theta]
```
with parameters:
*  $C$: thermal mass of GPU
*  $U$: heat transfer coefficient
*  $A$: area for GPU-air heat transfer
"

# ╔═╡ e6319424-717d-4a6e-9c89-191f9cf5f755
md"### goal

the goal is to simulate the response of the output $\theta(t)$ to an input change in $\theta_a(t)$ using `Controlz.jl`.


!!! note \"Controlz.jl\"
	see [here](https://simonensemble.github.io/Controlz.jl/dev/) for the `Controlz` docs. 
	* a high-level overview of how to simulate the response of an LTI system [here](https://simonensemble.github.io/Controlz.jl/dev/).
	* construct transfer functions [here](https://simonensemble.github.io/Controlz.jl/dev/tfs/)
	* run a simulation and access the output data [here](https://simonensemble.github.io/Controlz.jl/dev/sim/)
	* draw visualizations (see `viz_response`)---or just draw your own plot via `CairoMakie`. [here](https://simonensemble.github.io/Controlz.jl/dev/viz/)

the parameters of the system are given below.
"

# ╔═╡ cce81538-089d-4bc4-a01b-6da32f8da3b6
begin
	# thermal mass of GPU
	C  = 0.7 * 100 # J / °C
	# heat transfer coefficient
	U  = 300.0     # J / (m²-s-°C)
	# area across which heat transfer occurs
	A  = 0.01      # m²
end

# ╔═╡ 98590246-3f96-4429-9d87-11d9ad328a41
τ = C / (U * A) # s

# ╔═╡ d45e1573-acfb-40ca-bd38-2f2029ca718d
K = 1 # °C / °C

# ╔═╡ 9756f9b0-5362-45c9-8d60-9f5a24303eef
md"👽 suppose the steady-state heat generation $\bar{q}=100$ J/s and steady-state air temperature $\bar{\theta_a}=25$ °C. calcluate the steady-state value of the GPU temperature, $\bar{\theta}$ °C.
"

# ╔═╡ 3dd2ac71-7ff8-4e14-94d0-4a2ddd6ae665
begin
	θ̄ₐ = 25.0 # °C
	q̄ = 100.0 # J/s
	θ̄ = θ̄ₐ + q̄ / (U * A) # °C
end

# ╔═╡ 8e4a0330-5692-42a2-a87f-c1eaeb05504f
md"
## the input we consider

suppose:
* the heat generation is fixed at its steady state value, so $q(t)=\bar{q} \; \forall t$.
* the air temperature is and has been at its steady state value (indoor air temperature $\bar{\theta_a}$) until $t=0$, when the computer is suddenly taken outdoors and kept there. as a result, the air temperature suddenly increases by $\Delta \theta_a$ from moving the computer from indoors to outdoors. this is a step input:
```math
\begin{equation}
	\theta_a(t) = \begin{cases} 
\bar{\theta_a} & t\leq 0\\
\bar{\theta_a} +\Delta \theta_a & t>0
\end{cases}
\end{equation}
```

👽 given the value of $\Delta \theta_a$ defined below, define the input $\Theta_a^*(s):=\mathcal{L}[\theta_a^*(t)]$ below.
"

# ╔═╡ 858312af-b838-4207-a5da-fd63cdf85c88
Δθₐ = 10.0 # °C

# ╔═╡ 7f58cf2e-b758-470c-a013-4b29ea6e4557
Θₐ★ = Δθₐ / s

# ╔═╡ c3fab225-dff5-42b6-b81c-1116e00d65f1
md"👽construct the transfer function $G(s)$."

# ╔═╡ e353b680-99a2-482f-9c4a-6b03cd351c3d
G = K / (τ * s + 1)

# ╔═╡ c12bc46b-5ae6-42dc-8fac-d8bf4346b393
md"👽 through transfer function multiplication, construct the output $\Theta^*(s):=\mathcal{L}[\theta(s)]$."

# ╔═╡ 0bc3f13f-5700-47dd-9497-f7ee19051710
Θ★ = G * Θₐ★

# ╔═╡ 16a727f0-fc30-4f3d-a768-d23d8863eae9
md"👽 simulate the output $\theta^*(t)$ from $t\in[0,180]$ s using `simulate` in `Controlz`."

# ╔═╡ f5b1d37f-323a-4e72-b18e-70a26356970b
data = simulate(Θ★, 180.0)

# ╔═╡ 6390d313-8b8e-4a4b-8e86-5d822b319629
data[:, "t"]

# ╔═╡ ea4b77db-d727-4df9-bea6-e5e4c8fe6874
data[:, "output"]

# ╔═╡ 9af3682e-d0c7-4f90-ae0e-dc0310ff5ed9
md"👽visualize the response $\theta(t)$ (note: not in deviation form). label your axes and include units."

# ╔═╡ e54122be-cfc4-4e2a-aa55-8e093202e9a5
begin
	fig = Figure()
	ax  = Axis(fig[1, 1], xlabel="time, t [s]", ylabel="GPU temp. θ [°C]")
	lines!(data[:, "t"], θ̄ .+ data[:, "output"], color="green")
	fig
end

# ╔═╡ 17f856a4-d969-46a0-8c64-2c2a410633e0
md"👽what is the GPU temperature at the end of the simulation?"

# ╔═╡ fb505633-ac01-4864-85ce-b0ea9b19271f
θ̄_new = θ̄ + data[end, "output"]

# ╔═╡ c29a0c44-60b2-4530-b0fa-3158d35768d1
md"👽 at what time does the GPU first reach 66 °C?

!!! hint
	one way is to use `findfirst`.
"

# ╔═╡ ace290ca-ca01-4148-bd34-ac2310ff328c
t_special = data[findfirst(data[:, "output"] .+ θ̄ .> 66.0), "t"]

# ╔═╡ f646f433-c040-4950-9fbb-b28389781fa2
for i = 1:100
	if data[i, "output"] + θ̄ > 66.0
		println("t = ", data[i, "t"], " s")
		break
	end
end

# ╔═╡ f724dfc7-f179-4a58-aeeb-e74ee6c6a289
begin
	hlines!(ax, θ̄_new, color="orange", linestyle="--", linewidth=1)
	vlines!(ax, t_special, color="orange", linestyle="--", linewidth=1)
	fig
end

# ╔═╡ Cell order:
# ╠═fdb809e2-8529-11ec-2cce-db853e9d397a
# ╠═22cdde6c-9880-4eae-a5dd-35435ea539b5
# ╟─df9ee53f-a59a-4496-9fe2-89f688bd13b7
# ╟─e6319424-717d-4a6e-9c89-191f9cf5f755
# ╠═cce81538-089d-4bc4-a01b-6da32f8da3b6
# ╠═98590246-3f96-4429-9d87-11d9ad328a41
# ╠═d45e1573-acfb-40ca-bd38-2f2029ca718d
# ╟─9756f9b0-5362-45c9-8d60-9f5a24303eef
# ╠═3dd2ac71-7ff8-4e14-94d0-4a2ddd6ae665
# ╟─8e4a0330-5692-42a2-a87f-c1eaeb05504f
# ╠═858312af-b838-4207-a5da-fd63cdf85c88
# ╠═7f58cf2e-b758-470c-a013-4b29ea6e4557
# ╟─c3fab225-dff5-42b6-b81c-1116e00d65f1
# ╠═e353b680-99a2-482f-9c4a-6b03cd351c3d
# ╟─c12bc46b-5ae6-42dc-8fac-d8bf4346b393
# ╠═0bc3f13f-5700-47dd-9497-f7ee19051710
# ╟─16a727f0-fc30-4f3d-a768-d23d8863eae9
# ╠═f5b1d37f-323a-4e72-b18e-70a26356970b
# ╠═6390d313-8b8e-4a4b-8e86-5d822b319629
# ╠═ea4b77db-d727-4df9-bea6-e5e4c8fe6874
# ╟─9af3682e-d0c7-4f90-ae0e-dc0310ff5ed9
# ╠═e54122be-cfc4-4e2a-aa55-8e093202e9a5
# ╟─17f856a4-d969-46a0-8c64-2c2a410633e0
# ╠═fb505633-ac01-4864-85ce-b0ea9b19271f
# ╟─c29a0c44-60b2-4530-b0fa-3158d35768d1
# ╠═ace290ca-ca01-4148-bd34-ac2310ff328c
# ╠═f646f433-c040-4950-9fbb-b28389781fa2
# ╠═f724dfc7-f179-4a58-aeeb-e74ee6c6a289