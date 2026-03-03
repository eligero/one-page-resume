#import "src/lib.typ": resume

#let configuration = toml("./configuration.toml")
#let data = toml("./data.toml")

#show: resume.with(
  configuration,
	data
)
