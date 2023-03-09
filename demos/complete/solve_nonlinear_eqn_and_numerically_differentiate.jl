### A Pluto.jl notebook ###
# v0.19.20

using Markdown
using InteractiveUtils

# ╔═╡ 288ed518-bde8-11ed-0204-0b761fe29816
begin
	import Pkg;Pkg.activate()
	using NLsolve
	using Calculus: gradient
	using Symbolics
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
f₁(x₁, x₂) = x₁ - x₂ + 1

# ╔═╡ 1d83da1f-3793-4846-94d2-fccd949d9c94
f₂(x₁, x₂) = x₂ - x₁ ^ 2 - 1

# ╔═╡ f3878c5c-64eb-40e6-8011-24728eea9588
function make_zero!(f, x)
    # x = [x₁, x₂]. unpack the vector to make it clear what the entries represent
    x₁, x₂ = x
    
    # put the two functions you want to be zero as the two entries of f = [f₁, f₂]
    f[1] = f₁(x₁, x₂)
    f[2] = f₂(x₁, x₂)
end

# ╔═╡ 4e123781-c5a3-40fe-95d1-cb3371e4504a
md"🐶 provide guess for the zero, let `NLsolve` find it."

# ╔═╡ 2ad3dc20-60b1-4ac7-91ec-a136b68b7908
x₀_guess = [2.0, 4.0]

# ╔═╡ 27684ddb-05b9-490d-a9a4-512b3ca15d5e
res = nlsolve(make_zero!, x₀_guess)

# ╔═╡ cbb84233-381a-4041-99a4-f0d26b5566ca
x₀ = res.zero

# ╔═╡ ece59041-857b-4af9-94a2-48e49b6b9b74
md"check it's indeed a zero."

# ╔═╡ d79493d8-8844-42fa-9600-a4b308102124
f₁(x₀[1], x₀[2]) # yay!

# ╔═╡ f3e22b86-94cc-4ba5-bdfc-bc210b064abe
f₂(x₀[1], x₀[2]) # yay!

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
function f(x) # x is a vector
    # x = [x₁, x₂]. unpack the vector for clarity
    x₁, x₂ = x
    return x₁ * x₂ + x₂ ^ 2 + 4
end

# ╔═╡ 38c74300-39a7-45f1-8edf-14c7f03b5393
x̄ = [2.0, 4.0] # a vector. so x₁ = 2.0, x₂ = 4.0

# ╔═╡ b945e16d-f3db-4ab3-ad0f-86a0a6962aac
f(x̄)

# ╔═╡ 8a4cfe40-909c-4d19-a120-53671874d8e6
md"🐶 compute the gradient of the function."

# ╔═╡ f517ddbc-8a30-4e78-831d-da969c4f9819
∇f_at_x̄ = gradient(f, x̄) # ∇f = [∂f/∂x₁, ∂f/∂x₂] evaluated at x̄

# ╔═╡ f92847e4-09f3-4e9d-9722-6c245c67cf1f
∂f_∂x₁_at_x̄, ∂f_∂x₂_at_x̄ = ∇f_at_x̄

# ╔═╡ 882f8867-1bdc-407a-b2f9-1337f793b757
md"## solving symbolic equations with `Symbolics.jl`

(to save you some algebra)

!!! example
	in our handout \"intro to second-order systems\", we took the Laplace transform of two coupled, linear ODEs comprising a model for pesticide application to apple trees and its influence on the soil. the equations were:
	
	```math
	\begin{align}
		sA(s) &= - 3 A(s) + G(s) + R(s) \\
		s G(S) &= 2 A(s) - 2 G(s)
	\end{align}
	```
	we wish to solve for $G(s)$ in terms of $R(s)$, eliminating $A(s)$, giving the transfer function for how $R(s)$ affects $G(s)$.

!!! hint
	see [the docs](https://symbolics.juliasymbolics.org/stable/getting_started/) for `Symbolics.jl`.
"

# ╔═╡ efe4024f-4b38-49a2-9c4b-531b536aaeb5
md"define variables."

# ╔═╡ 78b91616-6794-4707-8a89-eeca1b327aba
# define symbols
@variables A, G, R, s # note can't load with Controlz.jl b/c s defined by it.

# ╔═╡ b67604b4-b559-4a46-9f30-02b7561de80d
md"define the two algebraic equations as (...) = 0."

# ╔═╡ 85f93d29-3702-44c2-86d5-a404c9108ade
A_eqn = s * A + 3 * A - G - R

# ╔═╡ 521aa029-e348-4cf5-87c9-f0eb2481094f
G_eqn = s * G - 2 * A + 2 * G

# ╔═╡ 9b267e35-4a14-4048-b0a3-473980edbe9c
md"solve `A_eqn` for `A` in terms of `G` and `R`."

# ╔═╡ 4551f197-2765-4e31-95f8-f64f0aea4c9d
A_of_G_and_R = Symbolics.solve_for(A_eqn, A)

# ╔═╡ d662b59f-b8e1-4ec7-893b-03e08eff1bd2
md"substitute this expression for `A` into `G_eqn`."

# ╔═╡ 3a3416ec-eb6c-4707-8db4-8d7cef4961e1
new_G_eqn = substitute(G_eqn, A => A_of_G_and_R)

# ╔═╡ 0ad4d4cb-9597-45a9-914c-3900a36f02fd
md"solve for `G`."

# ╔═╡ aed884f7-2554-4393-9723-f7c30e361ef8
tf = Symbolics.solve_for(new_G_eqn, G, simplify=true)

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
# ╟─882f8867-1bdc-407a-b2f9-1337f793b757
# ╟─efe4024f-4b38-49a2-9c4b-531b536aaeb5
# ╠═78b91616-6794-4707-8a89-eeca1b327aba
# ╟─b67604b4-b559-4a46-9f30-02b7561de80d
# ╠═85f93d29-3702-44c2-86d5-a404c9108ade
# ╠═521aa029-e348-4cf5-87c9-f0eb2481094f
# ╟─9b267e35-4a14-4048-b0a3-473980edbe9c
# ╠═4551f197-2765-4e31-95f8-f64f0aea4c9d
# ╟─d662b59f-b8e1-4ec7-893b-03e08eff1bd2
# ╠═3a3416ec-eb6c-4707-8db4-8d7cef4961e1
# ╟─0ad4d4cb-9597-45a9-914c-3900a36f02fd
# ╠═aed884f7-2554-4393-9723-f7c30e361ef8
