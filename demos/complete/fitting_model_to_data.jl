### A Pluto.jl notebook ###
# v0.19.20

using Markdown
using InteractiveUtils

# ╔═╡ 30d63de6-b19f-11ed-3aaf-e549eed34237
begin
	import Pkg; Pkg.activate()
	using CairoMakie, Optim, DataFrames, Random

	update_theme!(fontsize=24, markersize=16, linewidth=3)
end

# ╔═╡ ac14f14b-1cf0-402c-aa49-f68b10817c8b
md"# fitting models to data"

# ╔═╡ 23fce9e4-eff0-4259-a2a9-0ce8918b36c6
data = begin
	# Cory's complicated code, no need to understand this.
	Random.seed!(97330) # for repeatability
	local _data = DataFrame(
		"t" => range(0.0, 10.0, length=20)
	)
	# 👀 the true values of A and ω! don't peek!
	local A = 1.3
	local ω = 1.4
	_data[:, "y"] = A * sin.(ω .* _data[:, "t"]) .+ 0.3 * randn(20)
	_data
end

# ╔═╡ 442210c0-6928-4b8f-8000-712f97fd4674
md"visualize the data"

# ╔═╡ 419052a8-9ce3-45ec-a7de-59d1c85a497a
begin
	fig = Figure()
	ax = Axis(fig[1, 1], xlabel="t", ylabel="y(t)")
	scatter!(data[:, "t"], data[:, "y"], label="data")
	fig
end

# ╔═╡ cf1b9984-30b0-4a29-ac5f-8b28274e4226
md"propose a model:

```math
\begin{equation}
y(t)=A\sin(\omega t)
\end{equation}
```
here, the parameters $A$ and $\omega$ are unknown, so we fit them to the data.

write a sum of squares loss function---a function of $A$ and $\omega$, that, when minimal, implies the minimizers $\hat{A}$ and $\hat{\omega}$ fit the data best.
```math
\begin{equation}
\ell(\theta:=[A, \omega]):=\sum_i (y_i - A\sin(\omega t_i))^2
\end{equation}
```

here $\theta:=[A, \omega]\in\mathbb{R}^2$ is the parameter vector.
"

# ╔═╡ 8cc3e872-1ac9-409f-b8ed-d39ab0457bb6
function loss(θ) 
	# unpack param vector θ = [A, ω]
	A, ω = θ
	# compute loss
	l = 0.0
	for i = 1:nrow(data)
		# the data point
		tᵢ = data[i, "t"]
		yᵢ = data[i, "y"]
		
		# the model prediction with these params passed to the loss
		ŷᵢ = A * sin(ω * tᵢ)
		
		# add the residual to the loss
		l += (ŷᵢ - yᵢ)^2
	end
	return l
end

# ╔═╡ 59f850be-c78c-4ee5-aba0-531f78a22448
md"minimize the loss with the Nelder-Mead algo. see [Optim.jl docs](https://julianlsolvers.github.io/Optim.jl/stable/#user/minimization/)."

# ╔═╡ e26f3c5a-befb-4034-84c9-d45f2d53760d
res = optimize(loss, [1.0, 1.0])

# ╔═╡ 2b3da484-093e-4da7-8e92-c0599b080bc1
md"get the minimizer, ie. the parameters that give the model that fits the data the best."

# ╔═╡ 3a15c770-1bad-4333-a415-d705b7a10b56
Â, ω̂ = res.minimizer

# ╔═╡ d4ee3314-02eb-400a-b787-df08334697f6
md"plot the fit model along with the data to compare."

# ╔═╡ 071ee0de-e96b-4754-af7c-b74b65b692b9
begin
	ts = range(0.0, 10.0, length=100)
	lines!(ax, ts, Â * sin.(ω̂ * ts), label="model", color=Cycled(3))
	axislegend(position=:cb)
	fig
end

# ╔═╡ Cell order:
# ╠═30d63de6-b19f-11ed-3aaf-e549eed34237
# ╟─ac14f14b-1cf0-402c-aa49-f68b10817c8b
# ╠═23fce9e4-eff0-4259-a2a9-0ce8918b36c6
# ╟─442210c0-6928-4b8f-8000-712f97fd4674
# ╠═419052a8-9ce3-45ec-a7de-59d1c85a497a
# ╟─cf1b9984-30b0-4a29-ac5f-8b28274e4226
# ╠═8cc3e872-1ac9-409f-b8ed-d39ab0457bb6
# ╟─59f850be-c78c-4ee5-aba0-531f78a22448
# ╠═e26f3c5a-befb-4034-84c9-d45f2d53760d
# ╟─2b3da484-093e-4da7-8e92-c0599b080bc1
# ╠═3a15c770-1bad-4333-a415-d705b7a10b56
# ╟─d4ee3314-02eb-400a-b787-df08334697f6
# ╠═071ee0de-e96b-4754-af7c-b74b65b692b9
