#import "@preview/fontawesome:0.6.0": *

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

#let unit-parser(default, data) = {
  let length-pattern = regex("^-?\d+(\.\d+)?(pt|mm|cm|in|em|%)$")
  let color-pattern = regex("^#([a-fA-F0-9]{3}|[a-fA-F0-9]{4}|[a-fA-F0-9]{6}|[a-fA-F0-9]{8})$")
  
  if default.match(length-pattern) != none {
    if data.match(length-pattern) != none{
      parse-length(data)
    } else {
      parse-length(default)
    }
  } else if default.match(color-pattern) != none {
    if data.match(length-pattern) != none{
      rgb(data)
    } else {
      rgb(default)
    }
  } else {
    data
  }
}

#let parse-data(default, data) = {  
  for (k,v) in default {
    if data.keys().contains(k) {
      if type(v) == dictionary {
        default.at(k) = parse-data(default.at(k), data.at(k))
      } else if type(v) == array {
        // TODO
      } else {
        default.at(k) = unit-parser(v, data.at(k))
      }
    }
  }
  default
}

#let fa-icon-box(source, size-to: "q", alignment: "horizon") = context {
    let text-bounds = measure(text(top-edge: "cap-height", size-to)).height
    let bottom-shift = measure(text(bottom-edge: "descender", size-to)).height -  measure(text(bottom-edge: "baseline", size-to)).height
    let img = fa-icon(source, size: text-bounds)
    let shift = if alignment == "horizon" {
      bottom-shift
    } else {// "bottom"
      bottom-shift/2
    }
    return box(img, inset: (top: 0pt, bottom: shift))
    }
}

