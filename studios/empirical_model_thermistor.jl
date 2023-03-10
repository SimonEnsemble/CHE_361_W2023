### A Pluto.jl notebook ###
# v0.19.20

using Markdown
using InteractiveUtils

# ╔═╡ 4960c702-9ab3-11ec-0c7c-fbbc81f11a19
begin
	import Pkg; Pkg.activate()
	using Controlz, Optim, CairoMakie, CSV, DataFrames, StatsBase
end

# ╔═╡ 29387273-08f3-4cf9-b16b-799cc8932ac2
set_theme!(Controlz.cool_theme)

# ╔═╡ d49596a0-6543-4c9b-90f2-089426adb555
md"
!!! note \"resources\"
	* Cory's `Optim.jl` in-class demo [here](https://simonensemble.github.io/CHE_361_W2023/demos/html/fitting_model_to_data.jl.html)
	* Cory's lecture notes on the dynamics of the heat transfer to/from a thermistor
    * docs for `Optim.jl` [here](https://julianlsolvers.github.io/Optim.jl/stable/)
  
## mathematical model for thermistor heat transfer dynamics

_the input_: $T_e=T_e(t)$ [°C]: temperature of the external medium (air, liquid, or gas) surrounding and in contact with the thermistor, at time $t$ [s]

_the output_: $T=T(t)$ [°C]: temperature of the thermistor
  
_the dynamic model_ in the time domain:
```math
\begin{equation}
	\frac{C}{UA}\frac{dT}{dt} + T = T_e.
\end{equation}
```
with physical parameters:
*  $U$ [J/(s⋅m²⋅°C)]: heat transfer coefficient between air and thermistor
*  $A$ [m²]: surface area of thermistor
*  $C$ [J/°C]: thermal mass of thermistor

_dynamic model_ in the frequency domain:
```math
\begin{equation}
	\frac{\mathcal{T}^*(s)}{\mathcal{T}_e^*(s)}=\frac{1}{\tau s + 1}
\end{equation}
```
with time constant $\tau:=C/(UA)$ [s]. here $\mathcal{T}^*(s) := \mathcal{L}[T^*(t)]$ and $\mathcal{T}_e^*(s) := \mathcal{L}[T_e^*(t)]$.

_objective_: determine the time constant $\tau$ of the thermistor from step response data $\{(t_i, T_i)\}$. 
"

# ╔═╡ 4aadf003-1eb8-40d9-891f-690c7767e493
html"<img src=\"https://www.avx.com/en/wp-content/uploads/product-images/Thermistor-Disc-Leaded.jpg\" width=200>"

# ╔═╡ 1784b834-83bc-4fb2-8756-571e40443393
md"
## experimental setup

Grant, an ex-(CHE361 LA), grabbed and held the thermistor for a long time. the temperature of the thermistor reached thermal equilibrium with Grant's hand. let $T_{Grant}$ [°C] be Grant's body temperature.

then, at $t=0$, Grant let go of the thermistor to expose its outer surface to the air, which is at ambient temperature, $T_{air}$ [°C].

owing to a temperature difference between the (hotter) thermistor and (colder) air, heat was transferred from the thermistor to the air. as a consequence, the temperature of the thermistor dropped and approached the temperature of the ambient air.

🐜 what kind of input is this?
"

# ╔═╡ f693ae0d-cad4-462e-b744-f9d4c4d59524
md"
it's a [... your answer here ...]
"

# ╔═╡ ddee86f0-1b47-4250-9787-1d5f19bd3576
md"
### read, viz the thermistor response data
the time series data characterizing the response $T(t)$ to the input described above is in the comma-separated-value (`.csv`) file `ambient_heat_transfer.csv`. this is *real* data collected from an Arduino!

🐜 use `CSV.jl` to read in the data in the `.csv` into a `DataFrame`. see docs for [`CSV.File`](https://csv.juliadata.org/stable/reading.html#CSV.File).

!!! hint
    make sure you place the `.csv` file in your present working directory `pwd()` so that `CSV.jl` can find it.

	see the bottom of [Cory's demo](https://simonensemble.github.io/CHE_361_W2023/demos/html/intro_to_julia.jl.html) for an example.
"

# ╔═╡ bd844191-c7a0-41a1-bc4b-1b377ff31538

# ╔═╡ 4b41405d-35fb-45a1-98fa-67d32bf8c841

# ╔═╡ 62067269-0594-4e4a-a6ee-5b5c94c130bc
md"🐜 below are measurements of the temperature of (i) Grant's hand and (ii) the indoor air.

!!! note
	I inferred these values by taking a time-average of the thermistor when $t<0$ and $t>40$ s (under the assumption that the thermistor came into thermal equilibrium with Grant's hand/ the air at these times).
"

# ╔═╡ 9e008e05-affb-495c-8e80-3c3e93f443fa
T_Grant = 35.3727 # °C

# ╔═╡ 72350a4c-45ac-4ba2-a78e-aa6df3c6e0bf
T_air = 19.639399 # °C

# ╔═╡ 22848796-4661-49f8-8777-4b23373fc8ca
md"
🐜 visualize the thermistor reponse time series data with a scatter plot. the y-axis should be the thermistor temperature, and the x-axis should be time.
* label your axes and include appropriate units in the axes
* include two horizontal, dashed lines that indicate `T_Grant` and `T_air`. 

!!! hint
	to make the data points easier to see, make the markers hollow via passing `color=(\"white\", 0.0), strokecolor=\"black\", strokewidth=1` to `scatter`.
"

# ╔═╡ d95d456e-de7c-4eb9-bf64-a72a9ce0fe6d

# ╔═╡ 4940f0d4-212b-4f8c-93e1-d6887ee3e837
md"
## fit an empirical model to the data

**the objective** is to determine the time constant $\tau$ using the time series data.

🐜 the input in this experiment is a step. what is the magnitude of this input change? calculate it from `T_air` and `T_Grant` and assign it as a variable `M`. 
"

# ╔═╡ 1d3ce972-b7fe-4926-93cd-1088ad1fdc41

# ╔═╡ 4d9ac879-8708-46cd-b707-da5a0498facb
md"🐜 write a function `T(t, τ)` that returns the predicted temperature at time `t` according to the model for $T(t)$ and a specified time constant $\tau$. 

!!! hint
	you will need an `if` statement for when `t<0` and `t>0`. (see [docs](https://docs.julialang.org/en/v1/manual/control-flow/#man-conditional-evaluation-1))

!!! hint
	see your notes on the first-order step response.
"

# ╔═╡ a2fabd49-5d3a-4566-a08c-ac9276c8cc40

# ╔═╡ 1c9f2656-9a62-47a0-844c-44debcde1fb1
md"🐜 write a function `loss(τ)` that computes the loss (sum of square residuals between the predicted temperature and actual temperature) for a given `τ`. we seek to minimize the loss by adjusting the time constant `τ`. "

# ╔═╡ 9e09fe45-91fd-4bec-953c-3d18b554fc84

# ╔═╡ 7e5e4ed7-e4f0-41d6-bdc1-8b503d3f1b7a
md"🐜 plot the loss function for $\tau \in [0, 50]$ s. does it exhibit a minimum?"

# ╔═╡ d6feb83a-cd63-480b-8be6-0234ed9aa534

# ╔═╡ 8fc98c97-495e-4d9f-b1ae-fc7988b1f935
md"🐜 use the `optimize` function in `Optim.jl` to minimize the loss function by tuning $\tau$. assign the optimum value of $\tau$ as a variable `τ_opt`. what is the optimal value of $\tau$ that best fits the data? what are the units of $\tau$?

!!! hint
	see [Optim.jl docs](https://julianlsolvers.github.io/Optim.jl/stable/#user/minimization/#minimizing-a-univariate-function-on-a-bounded-interval) on minimizing a uni-variate function over a bounded interval.

!!! hint
	you need to pass lower and upper bounds for what you think the optimum is. your plots above should help...
"

# ╔═╡ f693afac-2fa1-42a1-ad61-82daebede5fe

# ╔═╡ 892f7fb3-5a6b-4c9b-b3a2-ecf6108fc569
md"🐜 redraw your viz of the loss function, this time with a vertical dashed line to indicate where $\tau_{opt}$ lies.
"

# ╔═╡ ca7f2001-9acf-495c-bdf0-ffa45234f9ce

# ╔═╡ d8bbd9b0-2c10-4aa9-bbf1-86d492fa5ab5
md"🐜 finally, plot the model fit on top of the time series data using `τ_opt` and your `T(t, τ)` function. does it fit well? (if it doesn't, you did something wrong!)

> quite a remarkable first-order model fit to the data, eh? reminder: this is *real* data collected from a real thermistor hooked up to an Arduino!
"

# ╔═╡ 1c3338e7-90a0-494e-8f82-9b1a1fd3ec7d

# ╔═╡ Cell order:
# ╠═4960c702-9ab3-11ec-0c7c-fbbc81f11a19
# ╠═29387273-08f3-4cf9-b16b-799cc8932ac2
# ╟─d49596a0-6543-4c9b-90f2-089426adb555
# ╟─4aadf003-1eb8-40d9-891f-690c7767e493
# ╟─1784b834-83bc-4fb2-8756-571e40443393
# ╠═f693ae0d-cad4-462e-b744-f9d4c4d59524
# ╟─ddee86f0-1b47-4250-9787-1d5f19bd3576
# ╠═bd844191-c7a0-41a1-bc4b-1b377ff31538
# ╠═4b41405d-35fb-45a1-98fa-67d32bf8c841
# ╟─62067269-0594-4e4a-a6ee-5b5c94c130bc
# ╠═9e008e05-affb-495c-8e80-3c3e93f443fa
# ╠═72350a4c-45ac-4ba2-a78e-aa6df3c6e0bf
# ╟─22848796-4661-49f8-8777-4b23373fc8ca
# ╠═d95d456e-de7c-4eb9-bf64-a72a9ce0fe6d
# ╟─4940f0d4-212b-4f8c-93e1-d6887ee3e837
# ╠═1d3ce972-b7fe-4926-93cd-1088ad1fdc41
# ╟─4d9ac879-8708-46cd-b707-da5a0498facb
# ╠═a2fabd49-5d3a-4566-a08c-ac9276c8cc40
# ╟─1c9f2656-9a62-47a0-844c-44debcde1fb1
# ╠═9e09fe45-91fd-4bec-953c-3d18b554fc84
# ╟─7e5e4ed7-e4f0-41d6-bdc1-8b503d3f1b7a
# ╠═d6feb83a-cd63-480b-8be6-0234ed9aa534
# ╟─8fc98c97-495e-4d9f-b1ae-fc7988b1f935
# ╠═f693afac-2fa1-42a1-ad61-82daebede5fe
# ╟─892f7fb3-5a6b-4c9b-b3a2-ecf6108fc569
# ╠═ca7f2001-9acf-495c-bdf0-ffa45234f9ce
# ╟─d8bbd9b0-2c10-4aa9-bbf1-86d492fa5ab5
# ╠═1c3338e7-90a0-494e-8f82-9b1a1fd3ec7d
