### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ 75eebb20-bdef-11ed-1d40-1f6907086c82
begin
	import Pkg; Pkg.activate()
	using NLsolve
	using Calculus: gradient
	using Symbolics
	using Controlz
	using PlutoUI

	Controlz.update_theme!(Controlz.cool_theme)
	TableOfContents()
end

# ╔═╡ 6364b356-47e5-4f54-97c9-36989bf3bbd1
md"# a continuous bioreactor

consider our continuous flow bioreactor from lecture. suppose the incoming feed is sterile ($b_f=0$). 
"

# ╔═╡ b3cd963b-48bc-4e2a-a369-0032dc6e769a
html"<img src=\"https://raw.githubusercontent.com/SimonEnsemble/CHE_361_W2023/main/images/bioreactor.png\" width=300>"

# ╔═╡ 7e2cc484-a298-4cd3-b5b5-447bab09cab6
md"
the dynamic model for the bioreactor is (see lecture notes):

```math
\begin{align}
    \frac{db}{dt} &= - \frac{F}{V} b + \mu_{\text{max}}\frac{s}{K_S+s}b \\
    \frac{ds}{dt} &= \frac{F}{V}(s_f-s) - \left( Mb+\mu_{\text{max}}\frac{s}{K_S+s}b\frac{1}{Y} \right)
\end{align}   
```

since the two inputs $b_f=0$ and $s_f=\bar{s_f}$ are constant, we mathematically view the bioreactor as having a single input $F=F(t)$ and two outputs, $b=b(t)$ and $s=s(t)$.

the parameters for the model of the bioreactor are defined below.
"

# ╔═╡ e8474cd3-9a50-42f6-b4b6-f963e05dd053
begin
	### substrate consumtpion
	# for maintenance
	M = 0.05    # g substrate to keep micro-organisms alive / [g micro-organisms - hr]

	# for growth
	Y = 0.2     # g micro-organisms / g substrate to produce micro-organisms

	### yeast growth model
	# Monod params
	μₘₐₓ = 2.88 # 1 / hr
	Kₛ = 4.0    # g substrate / L

	### volume of bioreactor
	V = 1.45     # L

	### concentration of substrate in the feed (fixed)
	s̄_f = 7      # g substrate / L
end

# ╔═╡ f415b087-0094-48e8-b1b3-3ec4204e30bc
md"
### the steady-state conditions
abstract the model as
```math
\begin{align}
\frac{db}{dt} &= f_b(\mathbf{x}) \\
\frac{ds}{dt} &= f_s(\mathbf{x})
\end{align}
```
with
```math
\mathbf{x}=\begin{bmatrix} b \\ s \\ F \end{bmatrix}.
```
so the functions $f_b:\mathbb{R}^3\rightarrow \mathbb{R}$ and $f_s:\mathbb{R}^3\rightarrow \mathbb{R}$ constitute the right-hand-side of the ODEs governing $b(t)$ and $s(t)$, respectively, and characterize their dynamics.

🐛  define the two corresponding functions as `f_b(x)` and `f_s(x)` in Julia.

!!! note
	we are doing this to set up for the next steps, of (i) finding $\bar{s}$ and $\bar{b}$ and (ii) linearizing the model. so, later on, be sure to use these functions `f_b` and `f_s` you code up here.
"

# ╔═╡ 03c96301-1cb6-4249-b97f-e3128f146717

# ╔═╡ 2f743862-4608-48ed-a813-74aa4e2bad02

# ╔═╡ 26e69a12-b56b-4ccb-b437-997b895dca71
md"🐛 the steady-state value of the incoming flow rate of broth $\bar{F}$ is defined below. 
determine the corresponding steady state values of (1) the micro-organism concentration $\bar{b}$ and (2) the substrate concentration $\bar{s}$ in the reactor.

!!! hint
	use `nlsolve` from `NLsolve.jl`. see my tutorial [here](https://simonensemble.github.io/CHE_361_W2023/demos/html/solve_nonlinear_eqn_and_numerically_differentiate.jl.html).
"

# ╔═╡ 3c7e4f27-d097-4f77-b7e2-a2f0a4fffdb6
F̄ = 0.96 # L / hr

# ╔═╡ 9f6caabc-7fdc-4e8f-8503-bdbf12cbd86c

# ╔═╡ e0afc562-cf12-4836-b9c8-41ca8fb689ba

# ╔═╡ 1a9056fa-a0e2-49f0-ac1b-c3887dbb45fc

# ╔═╡ 24b9bc20-1738-46ae-ac41-a9000db19c94
md"
### linearization of the model

🐛 now that we know $\bar{b}$, $\bar{s}$, and $\bar{F}$, we proceed to linearize the model.

numerically compute the _six_ partial derivatives (think what derivatives you need) needed to linearize this model.

!!! hint
	use `gradient` from `Calculus.jl`. see my tutorial [here](https://simonensemble.github.io/CHE_361_W2023/demos/html/solve_nonlinear_eqn_and_numerically_differentiate.jl.html). 
"

# ╔═╡ 99826be8-2b8c-4623-8c9b-ed2c78014bd1

# ╔═╡ 43701048-bb09-4673-b401-e4b79d9ba9b9

# ╔═╡ 48660e87-975b-4e1a-9281-79bd7e36c113
md"
### derivation of the transfer function $B^*(s)/\mathcal{F}^*(s)$

🐛 derive the linearized transfer function model that determines the dynamics of how $\mathcal{F}(\hat{s}):=\mathcal{L}[F^*(t)]$ affects $B(\hat{s}):=\mathcal{L}[b^*(t)]$. substitute the numerical values you obtained from above. note, I am using $\hat{s}$ as the frequency variable because $s$ is taken by the variable we use to represent the concentration of substrate.

!!! hint
	this is quite a bit of algebra. I recommend using `Symbolics.jl`. see my tutorial [here](https://simonensemble.github.io/CHE_361_W2023/demos/html/solve_nonlinear_eqn_and_numerically_differentiate.jl.html).
" 

# ╔═╡ 961d8784-d732-4b4a-90e9-d710e049e4d0

# ╔═╡ 1d5de22c-c47d-48f8-8b0b-bb9b98e8b7fa

# ╔═╡ a761f0a4-1979-4bbc-acdf-82ccc50b6b83

# ╔═╡ c0b950d6-5bb0-4800-a050-ba10f80a0582

# ╔═╡ f19fe0f3-a59e-4f9a-94f9-16493370af72

# ╔═╡ d2a38ea7-b915-4048-a720-3f292c9fe37d

# ╔═╡ 1a455e37-9381-4395-a640-b0bbfdd79066
md"🐛 assign to a variable `G` your transfer function $B^*(s)/\mathcal{F}^*(s)$. we will use it next to run a simulation in `Controlz.jl`.

!!! note
	feel free to round the numbers to the nearest decimal.
"

# ╔═╡ 24769cd9-f570-4a8e-a865-37645242186c
G = 

# ╔═╡ 4cacd435-def7-441e-834c-ef8c51895a3f
md"🐛 visualize the poles and zeros of your transfer function with `viz_poles_and_zeros`."

# ╔═╡ dd3fbf9b-0f74-4dd8-97fd-925fc977d6f4

# ╔═╡ 0fd6b0e6-b985-4fb3-bce7-cb7f68710bd1
md"
### employing the transfer function to simulate the response of $B^*(\hat{s})$ to a step in $\mathcal{F}^*(\hat{s})$

let's put the transfer function to use!

🐛 suppose we have a unit step in the feed rate of substrate solution, $F(t)$. amend the code below to simulate and visualize the step response of $B^*(\hat{s})$. explain if the shape of the response makes sense to you.

!!! hint
	do you see overshoot?! I did. see if you can explain the overshoot from a physical standpoint. _think_: a higher flow rate of broth will flush out the micro-organisms, _but_ it also replenishes the substrate... 🤯
"

# ╔═╡ 43012b0e-dad4-48b4-aa85-a30ef6c27c8e
F★ = 1 / s # unit step in F

# ╔═╡ dc1aa58d-0d0d-4488-92ad-514e7c704d47
begin
	B★ = # the step response. for you to fill in.
	data = simulate(B★, 10.0) # simulate for 10 hrs
	viz_response(data, xlabel="time [hr]", ylabel="bugs [g/L]")
end

# ╔═╡ 7e57c45d-6a14-4c6a-b439-20cfde95b087
md"
the response makes sense to me because: [...]
"

# ╔═╡ Cell order:
# ╠═75eebb20-bdef-11ed-1d40-1f6907086c82
# ╟─6364b356-47e5-4f54-97c9-36989bf3bbd1
# ╟─b3cd963b-48bc-4e2a-a369-0032dc6e769a
# ╟─7e2cc484-a298-4cd3-b5b5-447bab09cab6
# ╠═e8474cd3-9a50-42f6-b4b6-f963e05dd053
# ╟─f415b087-0094-48e8-b1b3-3ec4204e30bc
# ╠═03c96301-1cb6-4249-b97f-e3128f146717
# ╠═2f743862-4608-48ed-a813-74aa4e2bad02
# ╟─26e69a12-b56b-4ccb-b437-997b895dca71
# ╠═3c7e4f27-d097-4f77-b7e2-a2f0a4fffdb6
# ╠═9f6caabc-7fdc-4e8f-8503-bdbf12cbd86c
# ╠═e0afc562-cf12-4836-b9c8-41ca8fb689ba
# ╠═1a9056fa-a0e2-49f0-ac1b-c3887dbb45fc
# ╟─24b9bc20-1738-46ae-ac41-a9000db19c94
# ╠═99826be8-2b8c-4623-8c9b-ed2c78014bd1
# ╠═43701048-bb09-4673-b401-e4b79d9ba9b9
# ╟─48660e87-975b-4e1a-9281-79bd7e36c113
# ╠═961d8784-d732-4b4a-90e9-d710e049e4d0
# ╠═1d5de22c-c47d-48f8-8b0b-bb9b98e8b7fa
# ╠═a761f0a4-1979-4bbc-acdf-82ccc50b6b83
# ╠═c0b950d6-5bb0-4800-a050-ba10f80a0582
# ╠═f19fe0f3-a59e-4f9a-94f9-16493370af72
# ╠═d2a38ea7-b915-4048-a720-3f292c9fe37d
# ╟─1a455e37-9381-4395-a640-b0bbfdd79066
# ╠═24769cd9-f570-4a8e-a865-37645242186c
# ╟─4cacd435-def7-441e-834c-ef8c51895a3f
# ╠═dd3fbf9b-0f74-4dd8-97fd-925fc977d6f4
# ╟─0fd6b0e6-b985-4fb3-bce7-cb7f68710bd1
# ╠═43012b0e-dad4-48b4-aa85-a30ef6c27c8e
# ╠═dc1aa58d-0d0d-4488-92ad-514e7c704d47
# ╠═7e57c45d-6a14-4c6a-b439-20cfde95b087
