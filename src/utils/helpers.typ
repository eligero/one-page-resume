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
      } else {
        default.at(k) = unit-parser(v, data.at(k))
      }
    }
  }
  default
}

#let icon-parser(icon, size: 1em, color: black) = {
  let prefix = icon.match(regex("^(fa|si|custom)-")).text
  let _icon = icon.replace(regex("^(fa|si|custom)-"), it => "")

  let img = {
    if prefix == "fa-" {
      fa-icon(_icon, size: size, fill: color)
    } else if prefix == "si-" {
      sicon(slug: _icon, size: 87.5%*size, icon-color: color.to-hex())
    }
    else { //custom
      image(
        bytes(
          read("/" + _icon)
          .replace("#000000", color.to-hex())
        ),
        height: 87.5%*size,
      )
    }
  }
    
  if prefix == "fa-" {
    return text(img, bottom-edge: -25%*size)
  } else{
    return text(img)
  }
}

