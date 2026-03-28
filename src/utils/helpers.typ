#import "@preview/fontawesome:0.6.0": *
#import "@preview/sicons:16.0.0": *

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
  let color-pattern = regex(
    "^#([a-fA-F0-9]{3}|[a-fA-F0-9]{4}|[a-fA-F0-9]{6}|[a-fA-F0-9]{8})$"
  )
  
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
  let _entries = toml("./entries.toml")

  for (k,v) in default {
    if data.keys().contains(k) {
      if type(v) == dictionary {
        default.at(k) = parse-data(default.at(k), data.at(k))
      } else if type(v) == array and str(k).match(regex("line_[12]")) != none {
        if data.at(k) == () {
          default.at(k) = ()
        } else if default.at(k).len() > data.at(k).len() {
          continue
        } else {
          for i in range(data.at(k).len()){
            if data.at(k).at(i).keys() != ("icon", "text", "link"){
              continue
            }
            if data.at(k).at(i).values().all(item => {type(item) == str}) == false {
              continue
            }

            if data.at(k).at(i).at("icon").match(regex("^(fa|si|custom)-")) == none {
              data.at(k).at(i).at("icon") = "fa-xmark"
            }

            if i > default.at(k).len() - 1 {
              default.at(k).push(data.at(k).at(i))
            } else {
              default.at(k).at(i) = data.at(k).at(i)
            }            
          }
        }
      } else if type(v) == array and str(k) in ("accent-column", "main-column", "extended") {
        for i in range(data.at(k).len()){
          if data.at(k).at(i).keys().contains("entry") == false or data.at(k).at(i).entry not in _entries.entries.keys() {
            continue
          }

          if data.at(k).at(i).keys() != _entries.entries.at(data.at(k).at(i).entry).keys() {
            continue
          }

          if default.at(k).at(0) == (:) {
            default.at(k).at(0) = data.at(k).at(i)
          } else {
            default.at(k).push(data.at(k).at(i))
          }

        }
      } else {
        default.at(k) = unit-parser(v, data.at(k))
      }
    }
  }
  default
}
