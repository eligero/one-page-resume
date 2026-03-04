#import "@preview/one-page-resume:0.1.0": resume

#let configuration = toml("./configuration.toml")
#let data = toml("./data.toml")

#show: resume.with(
  configuration,
	data
)
