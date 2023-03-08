### A Pluto.jl notebook ###
# v0.19.20

using Markdown
using InteractiveUtils

# ╔═╡ 288ed518-bde8-11ed-0204-0b761fe29816
begin
	import Pkg;Pkg.activate()
	using NLsolve
	using Calculus: gradient
end

# ╔═╡ 3190b2f4-3b1a-4f02-9284-6948f29a7b67
md"## numerically solving a system of nonlinear algebraic equations

!!! note
	often, as chemical engineers, we must solve a system of nonlinear algebraic equations in order to find the steady-state of a process modeled by a set of coupled, first-order differential equations.

!!! example
	solve the following system of two non-linear equations for $x_1$ and $x_2$.

	$$x_1-x_2+1=0$$
	$$x_2-x_1^2-1=0$$


first, let's define two functions $f_1(x_1, x_2)$ and $f_2(x_1, x_2)$ that we want to be zero.

$$f_1(x_1, x_2) :=x_1-x_2+1$$

$$f_2(x_1, x_2) := x_2-x_1^2-1$$

we view this as a function $\mathbf{f}:\mathbb{R}^2 \rightarrow \mathbb{R}^2$.

```math
	\begin{equation}
		\mathbf{f}(\mathbf{x}=\begin{bmatrix}x_1\\x_2\end{bmatrix}) = 
			\begin{bmatrix}
			x_1 - x_2 + 1 \\ 
			x_2-x_1^2-1
			\end{bmatrix}
	\end{equation}
```

then, we wish to find a zero of $\mathbf{f}(\mathbf{x})$. a zero $\mathbf{x}_0$ satisfies $\mathbf{f}(\mathbf{x}_0)=\mathbf{0}$.

!!! hint
	see the `NLsolve.jl` docs [here](https://github.com/JuliaNLSolvers/NLsolve.jl). for a very fast solver, you can provide the Jacobian. here, we will rely on finite difference method to compute the gradient numerically, obviating the need to provide the Jacobian.

🐶 code up this function for `NLsolve`:
"

# ╔═╡ 0930e3e9-dc56-4453-87ba-a6cb460d87b3

# ╔═╡ 1d83da1f-3793-4846-94d2-fccd949d9c94

# ╔═╡ f3878c5c-64eb-40e6-8011-24728eea9588

# ╔═╡ 4e123781-c5a3-40fe-95d1-cb3371e4504a
md"🐶 provide guess for the zero, let `NLsolve` find it."

# ╔═╡ 2ad3dc20-60b1-4ac7-91ec-a136b68b7908

# ╔═╡ 27684ddb-05b9-490d-a9a4-512b3ca15d5e

# ╔═╡ cbb84233-381a-4041-99a4-f0d26b5566ca

# ╔═╡ ece59041-857b-4af9-94a2-48e49b6b9b74
md"check it's indeed a zero."

# ╔═╡ d79493d8-8844-42fa-9600-a4b308102124

# ╔═╡ f3e22b86-94cc-4ba5-bdfc-bc210b064abe

# ╔═╡ 9f636727-7272-43a1-a735-20736780ee70
md"## numerically differentiating a function

!!! note
	in process dynamics, we often wish to linearize a nonlinear ODE model of a process. for this, we must take partial derivatives of the right-hand-side of the ODE and evaluate them at steady-state conditions.

!!! example
	consider
	$f(x_1, x_2)= x_1 x_2 + x_2^2 + 4$.

	we seek the partial derivatives evaluated at certain values of $x_1$ and $x_2$: $x_1=\bar{x_1}=2$ and $x_2=\bar{x_2}=4$.
	
	compute both:
	* $\dfrac{\partial f}{\partial x_1}\bigg|_{x_1=2, x_2=4}$
	* $\dfrac{\partial f}{\partial x_2}\bigg|_{x_1=2, x_2=4}$

!!! hint
	let's use the `Calculus` package to numerically differentiate $f(x_1, x_2)$, using a finite difference approximation, instead of doing the math by hand (though easy in this case). see the [`Calculus.jl` docs](https://github.com/JuliaMath/Calculus.jl#direct-finite-differencing).

🐶 we view this function as $f:\mathbb{R}^2 \rightarrow \mathbb{R}$. code it up.
"

# ╔═╡ 2299403b-881f-4818-a1eb-c7a946dd3e55

# ╔═╡ 38c74300-39a7-45f1-8edf-14c7f03b5393

# ╔═╡ b945e16d-f3db-4ab3-ad0f-86a0a6962aac

# ╔═╡ 8a4cfe40-909c-4d19-a120-53671874d8e6
md"🐶 compute the gradient of the function."

# ╔═╡ f517ddbc-8a30-4e78-831d-da969c4f9819

# ╔═╡ f92847e4-09f3-4e9d-9722-6c245c67cf1f

# ╔═╡ Cell order:
# ╠═288ed518-bde8-11ed-0204-0b761fe29816
# ╟─3190b2f4-3b1a-4f02-9284-6948f29a7b67
# ╠═0930e3e9-dc56-4453-87ba-a6cb460d87b3
# ╠═1d83da1f-3793-4846-94d2-fccd949d9c94
# ╠═f3878c5c-64eb-40e6-8011-24728eea9588
# ╟─4e123781-c5a3-40fe-95d1-cb3371e4504a
# ╠═2ad3dc20-60b1-4ac7-91ec-a136b68b7908
# ╠═27684ddb-05b9-490d-a9a4-512b3ca15d5e
# ╠═cbb84233-381a-4041-99a4-f0d26b5566ca
# ╟─ece59041-857b-4af9-94a2-48e49b6b9b74
# ╠═d79493d8-8844-42fa-9600-a4b308102124
# ╠═f3e22b86-94cc-4ba5-bdfc-bc210b064abe
# ╟─9f636727-7272-43a1-a735-20736780ee70
# ╠═2299403b-881f-4818-a1eb-c7a946dd3e55
# ╠═38c74300-39a7-45f1-8edf-14c7f03b5393
# ╠═b945e16d-f3db-4ab3-ad0f-86a0a6962aac
# ╟─8a4cfe40-909c-4d19-a120-53671874d8e6
# ╠═f517ddbc-8a30-4e78-831d-da969c4f9819
# ╠═f92847e4-09f3-4e9d-9722-6c245c67cf1f
