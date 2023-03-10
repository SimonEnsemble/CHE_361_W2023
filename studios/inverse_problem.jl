### A Pluto.jl notebook ###
# v0.19.20

using Markdown
using InteractiveUtils

# ╔═╡ 97f46230-b195-11ed-335c-ad4bde5ce34b
begin
	import Pkg; Pkg.activate()
	using CairoMakie, Optim, DataFrames

	update_theme!(fontsize=24, linewidth=3, markersize=15)
end

# ╔═╡ 52e661b6-df07-42c1-a73b-cb2797efd564
md"

## estimate the rate at which a factory is releasing pollution into a lake
a pristine lake, of constant volume $V=1200$ [L], was initially free of pollution. 
then, at time $t=0$ [day], a factory begin operating and introducing pollutant into the lake at a constant but unknown rate $p$ [g/day]. a model for the concentration of pollutant in the lake $c(t)$ [g/L] is:
```math
\begin{equation}
    V\frac{dc}{dt} = p - (q_1+q_2) c(t) - kVc(t).
\end{equation} 
```
the flow rates of the incoming rivers $q_1$ and $q_2$ [L/day] and the pollutant decay rate constant $k$ [day$^{-1}$] are unknown.

!!! hint
	see Cory's solution to quiz 4 for the transfer function.
"

# ╔═╡ ceb23268-9d0d-46d0-ba0f-ca9a49cdd75a
html"<img src=\"https://raw.githubusercontent.com/SimonEnsemble/CHE_361_W2023/main/images/pollution_lake.png\" width=500>"

# ╔═╡ f9441b94-600c-451e-aad6-ff96d942b9f3
md"we took measurements of the concentration of pollutant in the lake over a time span of 6 days. the data are below.

| time, $t$ [days]      | concentration of pollutant in lake, $c(t)$ [g/L] |
| ----------- | ----------- |
| 0      | 0.0       |
| 1   |    0.058     |
| 3   |   0.134      |
| 4  |   0.162      |
| 6  |   0.198      |

use this data, the mathematical model for $c(t)$, and a least-squares fitting routine to estimate the rate at which the factory was polluting the lake, $p$.

!!! hint
	there are _two_ unknowns here, which we need to fit to this data. one unknown is an input parameter. the other unknown is lumped parameter in the model. don't forget to use the volume of the lake."

# ╔═╡ cde00d41-28cb-4931-8a11-22100e3e2fd8
data = DataFrame(
	"time [day]"=>[0.0, 1.0, 3.0, 4.0, 6.0],
	"concentration [g/L]"=>[0.0, 0.058, 0.134, 0.162,  0.198]
)

# ╔═╡ 5a4e1105-280d-4b3d-b428-cd4270d13b37
V = 1200 # L

# ╔═╡ d04bd8c4-789a-4f9f-b5c0-f076ee7b84ca
md"🦆 plot the data $\{(t_i, c_i)\}$ as points. include an x- and y-axis label on your plot that indicates units."

# ╔═╡ 058aecc1-e98b-4bde-8a5a-3b02382b0bdc


# ╔═╡ fcce1257-ddf3-40e1-a4c2-d95b3a72c20e
md"🦆 devise an order-of-magnitude guess for $p$ [g/L], based on the measurment of the concentration of pollutant in the pond after one day.

!!! hint
	assume $q_1=q_2=k=0$ to get an order of magnitude guess.

!!! note 
	this guess will be important for the Nelder-Mead algorithm to find the minimum of your loss function.
"

# ╔═╡ fe0c50e8-0d3c-4ff3-892b-0210c2dab9f6


# ╔═╡ 4de832ac-4ebe-43f6-ae1d-a0337b18c4c4
md"🦆 what are the two parameters you wish to identify from the data?
one should be $p$, the rate of pollution by the factory. the other should be a lumped model parameter.
"

# ╔═╡ 7f11f090-7ca4-471b-8630-e5809ccf2ca9
md"

"

# ╔═╡ d267a2e4-dd7f-44be-ba52-f7ed7657093c
md"🦆 write a loss `function` that computes the sum of square errors between (i) your model with a given set of parameters and (ii) the data points."

# ╔═╡ f778ba76-5c0c-4fed-9244-d55c7e6e4e1e


# ╔═╡ 931ee6d7-2635-452c-8467-4cc627903521
md"🦆 minimize the loss function to find your prediction for $p$ and the lumped model parameter."

# ╔═╡ 3ac76a88-afd7-46e0-ac6c-547bdbf92e27


# ╔═╡ ecc67214-bc40-495f-a3ab-8b14cb3dd6db


# ╔═╡ 25410917-0cf4-457a-91be-4cb19474aac9
md"
!!! note
	cool, right? so from this data, you can estimate the rate at which the factory was polluting the pond. even though you didn't measure it _directly_. you just solved what is known as an _inverse problem_. 

🦆 suppose you are hired as a consultant in court for this case. it is illegal to dump more than 20 g/min into the lake. the company denies it was polluting the pond above this rate. would you testify that the company exceeded this limit or not? how would you explain to the court what _you_ think the verdict should be?
"

# ╔═╡ 6ebcfde8-226c-46ee-aee5-71f5a65b97bc
md"

"

# ╔═╡ a122b679-2cf8-4211-ab65-3994c8f18d6a
md"
🦆 to make sure the parameters you obtained from the optimization routine indeed match the data well, plot the data along with your model prediction, given (i) your estimate of $p$ and (ii) your estimate of the lumped model parameter. plot the model prediction as a curve. include a legend to delineate between the model and the data. of course, x- and y-axes labels are required.
"

# ╔═╡ 6390aab4-cc92-482c-b2cb-55a8d2c15184


# ╔═╡ Cell order:
# ╠═97f46230-b195-11ed-335c-ad4bde5ce34b
# ╟─52e661b6-df07-42c1-a73b-cb2797efd564
# ╟─ceb23268-9d0d-46d0-ba0f-ca9a49cdd75a
# ╟─f9441b94-600c-451e-aad6-ff96d942b9f3
# ╠═cde00d41-28cb-4931-8a11-22100e3e2fd8
# ╠═5a4e1105-280d-4b3d-b428-cd4270d13b37
# ╟─d04bd8c4-789a-4f9f-b5c0-f076ee7b84ca
# ╠═058aecc1-e98b-4bde-8a5a-3b02382b0bdc
# ╟─fcce1257-ddf3-40e1-a4c2-d95b3a72c20e
# ╠═fe0c50e8-0d3c-4ff3-892b-0210c2dab9f6
# ╟─4de832ac-4ebe-43f6-ae1d-a0337b18c4c4
# ╠═7f11f090-7ca4-471b-8630-e5809ccf2ca9
# ╟─d267a2e4-dd7f-44be-ba52-f7ed7657093c
# ╠═f778ba76-5c0c-4fed-9244-d55c7e6e4e1e
# ╟─931ee6d7-2635-452c-8467-4cc627903521
# ╠═3ac76a88-afd7-46e0-ac6c-547bdbf92e27
# ╠═ecc67214-bc40-495f-a3ab-8b14cb3dd6db
# ╟─25410917-0cf4-457a-91be-4cb19474aac9
# ╠═6ebcfde8-226c-46ee-aee5-71f5a65b97bc
# ╟─a122b679-2cf8-4211-ab65-3994c8f18d6a
# ╠═6390aab4-cc92-482c-b2cb-55a8d2c15184
