### A Pluto.jl notebook ###
# v0.19.19

using Markdown
using InteractiveUtils

# ╔═╡ 64d5b078-6eb1-11ec-290d-99aa7b5ace54
begin
	import Pkg; Pkg.activate()
	using CairoMakie, DataFrames, CSV, ColorSchemes, Colors, PlutoUI
end

# ╔═╡ edbcad9f-bbc8-44c9-9165-ce61ee6671c3
md"# getting oriented with Julia

**learning objective:** 
* familiarize with some capabilities of the Julia programming language and Pluto notebooks. 

*disclaimer*: I do not expect you to be a competent Julia programmer after this studio. I'm hoping, by the end of the class, you will have the competency to write simple programs to explore concepts in process dynamics and control. the programming in this studio is as hard as it gets.

how to find out how to do something in Julia?
* see Julia website and docs [here](https://julialang.org/) and [here](https://docs.julialang.org/en/v1/)
* see, for data viz, `Makie` docs [here](https://makie.juliaplots.org/dev/)
* Google \"how do I ... in Julia?\"
"

# ╔═╡ 6cbbbf58-475f-473a-9915-6eb3eb153e3c
set_theme!(theme_dark()); update_theme!(fontsize=20)

# ╔═╡ a9b9a51b-f129-4d45-8b5c-f427296a3660
md"
## Fibonacci sequence

🐸 construct an array of length 12, containing the first 12 numbers of the [Fibonacci sequence](https://en.wikipedia.org/wiki/Fibonacci_number). of course, *write a program* to compute the numbers and fill the array, as opposed to manually constructing an array with 12 entries.

!!! hint
	write a `for` loop.
"

# ╔═╡ 04062259-b30a-47df-b6e7-b39b7ccff01d
begin
	x = zeros(Int, 12)
	x[1] = 0
	x[2] = 1
	for i = 3:12
		x[i] = x[i-1] + x[i-2]
	end
	x
end

# ╔═╡ edcac259-402e-45ae-a0a3-c662f0bb842c
md"
## plotting

🐸 plot (as a curve) the function $y(t)=e^{-t}\sin(10 t)$ over the domain $t\in[0, 6]$. include an x- and y-axis label on your plot. make sure you have enough resolution in your `t` array so that the plot appears smooth.
"

# ╔═╡ 5f04bb82-5d64-435c-8d0d-e6c439639329
ts = range(0.0, 6.0, length=500)

# ╔═╡ 06d87541-09da-420f-9415-c5e4dcc5cf41
function y(t)
	return exp(-t) * sin(10 * t)
end

# ╔═╡ 3082fdb7-a24f-4b0d-8844-b3eff754d262
begin
	fig = Figure()
	ax  = Axis(fig[1, 1], xlabel="t", ylabel="y(t)")
	lines!(ts, y.(ts))
	fig
end

# ╔═╡ d18ec2aa-ca32-49f9-9a5a-470214d995f5
md"## sine function

the sine function is sometimes *defined* in terms of the infinite series:

$\sin(x):=\displaystyle\sum_{n=0}^\infty \frac{(-1)^n}{(2n+1)!} x^{2n+1}$

see [here](https://en.wikipedia.org/wiki/Sine#Series_definition). on the computer, we can compute the truncated sum:

$\sin(x) \approx \displaystyle\sum_{n=0}^{N-1} \frac{(-1)^n}{(2n+1)!} x^{2n+1}$

🐸 write a function `my_sin(x, N)` that uses `N` terms to compute the truncated sum above for $x=$`x`.

!!! hint
	see the [Julia math docs](https://docs.julialang.org/en/v1/base/math/) for how to compute a factorial.
"

# ╔═╡ 00f0b5c6-bd5d-435d-932d-926769f14293
function my_sin(x, N)
	s = 0.0
	for n = 0:(N-1)
		s = s + (-1) ^ n / factorial(2 * n + 1) * x ^ (2 * n + 1)
	end
	return s
end

# ╔═╡ e1e9c3b8-57a9-4b7f-9622-48ab2ba731b5
md"
🐸 compare $\sin(1)$ computed with:
* Julia's implementation of `sin`
* the truncated sum with `N=8` terms, using `my_sin`
they should be close.
"

# ╔═╡ 01d4446c-2cc3-4c5b-ab8e-6e9df25294c7
# my sine function
my_sin(1.0, 8)

# ╔═╡ 4cddd124-0eae-45c7-96f3-23e3e53a0613
# Julia's built-in sine function
sin(1.0)

# ╔═╡ 9852fdaa-7c86-4e88-96af-6ec273222dd4
md"let's make the same comparison, but over many more $x$ values. 

🐸 draw a plot of $\sin(x)$ over the domain $x\in[0, 2\pi]$ using:
* Julia's implementation, `sin`
* your truncated sum implementation, via `my_sin`, with `N=8`

plot each approximation of $\sin(x)$ on the same plot, with two different colors. use a legend to indicate which line corresponds to which implementation. label your x- and y-axes, and put a title on the plot too. 

*ambitious beavers*: draw the $x$ and $y$ axes with `hlines!` and `vlines!`."

# ╔═╡ b89f1624-d2b5-4262-bcd5-514446dd66f6
begin
	θs = range(0.0, 2 * π, length=100)
	
	fig2 = Figure()
	ax2 = Axis(fig2[1, 1], xlabel="θ", ylabel="sin(θ)")
	lines!(θs, sin.(θs), label="Julia")
	lines!(θs, my_sin.(θs, 10), label="Cory", linestyle=:dash)
	axislegend()
	fig2
end

# ╔═╡ Cell order:
# ╟─edbcad9f-bbc8-44c9-9165-ce61ee6671c3
# ╠═64d5b078-6eb1-11ec-290d-99aa7b5ace54
# ╠═6cbbbf58-475f-473a-9915-6eb3eb153e3c
# ╟─a9b9a51b-f129-4d45-8b5c-f427296a3660
# ╠═04062259-b30a-47df-b6e7-b39b7ccff01d
# ╟─edcac259-402e-45ae-a0a3-c662f0bb842c
# ╠═5f04bb82-5d64-435c-8d0d-e6c439639329
# ╠═06d87541-09da-420f-9415-c5e4dcc5cf41
# ╠═3082fdb7-a24f-4b0d-8844-b3eff754d262
# ╟─d18ec2aa-ca32-49f9-9a5a-470214d995f5
# ╠═00f0b5c6-bd5d-435d-932d-926769f14293
# ╟─e1e9c3b8-57a9-4b7f-9622-48ab2ba731b5
# ╠═01d4446c-2cc3-4c5b-ab8e-6e9df25294c7
# ╠═4cddd124-0eae-45c7-96f3-23e3e53a0613
# ╟─9852fdaa-7c86-4e88-96af-6ec273222dd4
# ╠═b89f1624-d2b5-4262-bcd5-514446dd66f6
