#let parse-length(s) = {
  if s.ends-with("cm") {
    float(s.slice(0, -2)) * 1cm
  } else if s.ends-with("mm") {
    float(s.slice(0, -2)) * 1mm
  } else if s.ends-with("in") {
    float(s.slice(0, -2)) * 1in
  } else if s.ends-with("pt") {
    float(s.slice(0, -2)) * 1pt
  } else if s.ends-with("em") {
    float(s.slice(0, -2)) * 1em
  } else if s.ends-with("%") {
		float(s.slice(0, -1)) * 1%
  } else {
    panic("Unsupported unit in string: " + s)
  }
}

#let get-colors(configuration) = (
  accent: rgb(configuration.colors.at("accent", default: "#0395DE")),
  light: rgb(configuration.colors.at("light", default: "#F2F2F2")),
  dark: rgb(configuration.colors.at("dark", default: "#212529"))
)

#let get-setup(configuration) = (
  language: configuration.setup.at("language", default: "en"),
  paper: configuration.setup.at("paper", default: "a4"),
  margins: (
    left: parse-length(configuration.setup.margins.at("left", default: "1cm")),
    right: parse-length(configuration.setup.margins.at("right", default: "1cm")),
    top: parse-length(configuration.setup.margins.at("top", default: "1cm")),
    bottom: parse-length(configuration.setup.margins.at("bottom", default: "1cm"))
  )
)

#let get-accent-specs(configuration, data) = (
  corner: (
    width: parse-length(configuration.accent_corner.at("width", default: "30%")),
    height: parse-length(configuration.accent_corner.at("height", default: "16%")),
    v_offset: parse-length(configuration.accent_corner.at("v_offset", default: "0.25cm")),
    radius: (
      top-left: parse-length(configuration.accent_corner.radius.at("top-left", default: "0%")),	
      top-right: parse-length(configuration.accent_corner.radius.at("top-right", default: "0%")),	
      bottom-left: parse-length(configuration.accent_corner.radius.at("bottom-left", default: "20%")),	
      bottom-right: parse-length(configuration.accent_corner.radius.at("bottom-right", default: "0%"))	
    )
  ),
  image: (
    path: data.header.at("profile", default:"src/assets/images/profile.jpg"),
    blur: parse-length(configuration.profile_image.at("blur", default: "8pt")),
    stroke: parse-length(configuration.profile_image.at("stroke", default: "3pt")),
    radius: (
      top-left: parse-length(configuration.profile_image.radius.at("top-left", default: "50%")),	
      top-right: parse-length(configuration.profile_image.radius.at("top-right", default: "50%")),	
      bottom-left: parse-length(configuration.profile_image.radius.at("bottom-left", default: "50%")),	
      bottom-right: parse-length(configuration.profile_image.radius.at("bottom-right", default: "50%"))	
    )
  ),
  column: (
    width: parse-length(configuration.accent_column.at("width", default: "35%")),
    gutter: parse-length(configuration.accent_column.at("gutter", default: "7%")),
    radius: (
      bottom-left: parse-length(configuration.accent_column.radius.at("bottom-left", default: "0%")),  
      bottom-right: parse-length(configuration.accent_column.radius.at("bottom-right", default: "0%")),
      top-left: parse-length(configuration.accent_column.radius.at("top-left", default: "0%")),	
      top-right: parse-length(configuration.accent_column.radius.at("top-right", default: "20%")),
    )
  )
)

#let get-metadata(data) = (
  title: data.metadata.at("title", default: ""),
  author: data.metadata.at("author", default: ""),
  description: data.metadata.at("description", default: ""),
  keywords: data.metadata.at("keywords", default: "").split(regex(",\s*")),
)