### A Pluto.jl notebook ###
# v0.19.19

using Markdown
using InteractiveUtils

# ╔═╡ bb1607e6-789a-11ec-2035-fbd98fd78d98
md"# complex numbers

!!! note
	see Julia docs [here](https://docs.julialang.org/en/v1/manual/complex-and-rational-numbers/#Complex-Numbers).

$z=3+2i$

construct the number $z$.
"

# ╔═╡ a1e23483-7fb5-4a31-9cfb-bd6cdc30f355
z = 3 + 2 * im

# ╔═╡ 2d3c2ecc-ed43-4072-92bb-bd391f2168ec
md"wut's the real part?"

# ╔═╡ 81565d43-a529-4ff1-a31a-f447afc24166
real(z) # Re[z]

# ╔═╡ ded21cd5-d0c9-4130-9782-289eb2edf099
md"wut's the imaginary part?"

# ╔═╡ f4ba028e-0cb4-434b-aeb9-34ca955abf93
imag(z) # Im[z]

# ╔═╡ a5d6837f-f3d3-4528-8a1e-7f61cb039160
md"wut's the angle (referring to polar form)?"

# ╔═╡ 1774fdb6-a681-4ee3-8e7f-75e66cc8a07e
angle(z) # ∠ z

# ╔═╡ 0831ca55-4c38-4aef-919a-ef5e2b403b83
md"wut's the magnitude (referring to polar form)?"

# ╔═╡ 4b466e92-3743-4cd0-b8ba-6304e5f2db5d
abs(z) # | z |

# ╔═╡ 28e4f97e-a619-443e-9dee-b75e89c7cf4b
md"construct a complex number in polar form

$y=3 e^{\pi i / 4}$
"

# ╔═╡ b388bbc3-408f-4cdb-bb53-592b22509f93
y = 3 * exp(im * π / 4)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "da39a3ee5e6b4b0d3255bfef95601890afd80709"

[deps]
"""

# ╔═╡ Cell order:
# ╟─bb1607e6-789a-11ec-2035-fbd98fd78d98
# ╠═a1e23483-7fb5-4a31-9cfb-bd6cdc30f355
# ╟─2d3c2ecc-ed43-4072-92bb-bd391f2168ec
# ╠═81565d43-a529-4ff1-a31a-f447afc24166
# ╟─ded21cd5-d0c9-4130-9782-289eb2edf099
# ╠═f4ba028e-0cb4-434b-aeb9-34ca955abf93
# ╟─a5d6837f-f3d3-4528-8a1e-7f61cb039160
# ╠═1774fdb6-a681-4ee3-8e7f-75e66cc8a07e
# ╟─0831ca55-4c38-4aef-919a-ef5e2b403b83
# ╠═4b466e92-3743-4cd0-b8ba-6304e5f2db5d
# ╟─28e4f97e-a619-443e-9dee-b75e89c7cf4b
# ╠═b388bbc3-408f-4cdb-bb53-592b22509f93
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
