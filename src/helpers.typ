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

#let parse-check(data, value) = {
  if data.keys().contains(value) and data.at(value).len() > 0 {
    true
  } else {
    false
  }
}

#let get-colors(configuration) = {
  let accent = rgb(
    if parse-check(configuration, "colors") and parse-check(configuration.colors, "accent"){
      configuration.colors.accent
      } else {
        "#0395DE"
      }
    )

  let light = rgb(
    if parse-check(configuration, "colors") and parse-check(configuration.colors, "light"){
      configuration.colors.light
      } else {
        "#F2F2F2"
      }
    )

  let dark = rgb(
    if parse-check(configuration, "colors") and parse-check(configuration.colors, "dark"){
      configuration.colors.dark
      } else {
        "#212529"
      }
    )

  (accent: accent, light: light, dark: dark)
}

#let get-setup(configuration) = {
  let language = {
    if parse-check(configuration, "setup") and parse-check(configuration.setup, "language") {
      configuration.setup.language
    } else{
      "en"
    }
  }
  let paper = {
    if parse-check(configuration, "setup") and parse-check(configuration.setup, "paper") {
      configuration.setup.paper
    } else {
      "a4"
    }
  }
  let margins = {
    if parse-check(configuration, "setup") and parse-check(configuration.setup, "margins") {
      (
        left: parse-length(if parse-check(configuration.setup.margins, "left") { configuration.setup.margins.left} else {"1cm"}),
        right: parse-length(if parse-check(configuration.setup.margins, "right") { configuration.setup.margins.right} else {"1cm"}),
        top: parse-length(if parse-check(configuration.setup.margins, "top") { configuration.setup.margins.top} else {"1cm"}),
        bottom: parse-length(if parse-check(configuration.setup.margins, "bottom") { configuration.setup.margins.bottom} else {"1cm"}),
      )
    } else {
      (left: 1cm, right: 1cm, top: 1cm, bottom: 1cm)
    }
  }

  (language: language, paper: paper, margins: margins)
}

#let get-accent-specs(configuration, data) = {
  let corner = {
    if parse-check(configuration, "accent_corner") {
      (
        width: parse-length(if parse-check(configuration.accent_corner,"width") {configuration.accent_corner.width} else {"30%"}),
        height: parse-length(if parse-check(configuration.accent_corner,"height") {configuration.accent_corner.height} else {"16%"}),
        v_offset: parse-length(if parse-check(configuration.accent_corner,"v_offset") {configuration.accent_corner.v_offset} else {"0.25cm"}),
        radius: if parse-check(configuration.accent_corner, "radius") {
          (
            top-left: parse-length(if parse-check(configuration.accent_corner.radius, "top-left") {configuration.accent_corner.radius.top-left} else {"0%"}),	
            top-right: parse-length(if parse-check(configuration.accent_corner.radius, "top-right") {configuration.accent_corner.radius.top-right} else {"0%"}),	
            bottom-left: parse-length(if parse-check(configuration.accent_corner.radius, "bottom-left") {configuration.accent_corner.radius.bottom-left} else {"20%"}),	
            bottom-right: parse-length(if parse-check(configuration.accent_corner.radius, "bottom-right") {configuration.accent_corner.radius.bottom-right} else {"0%"})	
          )
        } else {
          (top-left: 0%, top-right: 0%, bottom-left: 20%, bottom-right: 0%)
        }
      )
    } else {
      (
        width: 30%,
        height: 16%,
        v_offset: 0.25cm,
        radius: (top-left: 0%, top-right: 0%, bottom-left: 20%, bottom-right: 0%)
      )
    }
  }
  let image = {
    let imgconf = {
      if parse-check(configuration, "profile_image") {
        (
          blur: parse-length(if parse-check(configuration.profile_image, "blur") {configuration.profile_image.blur} else {"8pt"}),
          stroke: parse-length(if parse-check(configuration.profile_image, "stroke") {configuration.profile_image.stroke} else {"3pt"}),
          radius: if parse-check(configuration.profile_image, "radius") {
            (
              top-left: parse-length(if parse-check(configuration.profile_image.radius, "top-left") {configuration.profile_image.radius.top-left} else {"50%"}),	
              top-right: parse-length(if parse-check(configuration.profile_image.radius, "top-right") {configuration.profile_image.radius.top-right} else {"50%"}),	
              bottom-left: parse-length(if parse-check(configuration.profile_image.radius, "bottom-left") {configuration.profile_image.radius.bottom-left} else {"50%"}),	
              bottom-right: parse-length(if parse-check(configuration.profile_image.radius, "bottom-right") {configuration.profile_image.radius.bottom-right} else {"50%"})	
            )
          } else {
            (top-left: 50%, top-right: 50%, bottom-left: 50%, bottom-right: 50%)
          }
        )
      } else{
        (
          blur: 8pt,
          stroke: 3pt,
          radius: (top-left: 50%, top-right: 50%, bottom-left: 50%, bottom-right: 50%)
        )
      }  
    }
    let imgdata = {
      if parse-check(data, "header"){
        if parse-check(data.header, "profile") {data.header.profile} else {"src/assets/images/profile.jpg"}
      } else{
       "src/assets/images/profile.jpg"
      }
    }
    (imgconf + (path: imgdata))
  }
  let column = {
    if parse-check(configuration, "accent_column") {
      (
        width: parse-length(if parse-check(configuration.accent_column, "width") { configuration.accent_column.width} else {"30%"}), 
        radius: if parse-check(configuration.accent_column, "radius") {
          (
            top-left: parse-length(if parse-check(configuration.accent_column.radius, "top-left") {configuration.accent_column.radius.top-left} else {"0%"}),	
            top-right: parse-length(if parse-check(configuration.accent_column.radius, "top-right") {configuration.accent_column.radius.top-right} else {"20%"}),	
            bottom-left: parse-length(if parse-check(configuration.accent_column.radius, "bottom-left") {configuration.accent_column.radius.bottom-left} else {"0%"}),	
            bottom-right: parse-length(if parse-check(configuration.accent_column.radius, "bottom-right") {configuration.accent_column.radius.bottom-right} else {"0%"})	
          )
        } else {
          (top-left: 0%, top-right: 20%, bottom-left: 0%, bottom-right: 0%)
        }
      )
    } else {
      (
        width: 30%,
        radius: (top-left: 0%, top-right: 20%, bottom-left: 0%, bottom-right: 0%),
      )
    }
  }

  (corner: corner, image: image, column: column)
}

#let get-metadata(data) = {
  let metadata = {
    if parse-check(data, "metadata") {
    (
      title: if parse-check(data.metadata, "title") {data.metadata.title} else {""},
      author: if parse-check(data.metadata, "author") {data.metadata.author} else {""},
      description: if parse-check(data.metadata, "description") {data.metadata.description} else {""},
      keywords: if parse-check(data.metadata, "keywords") {data.metadata.keywords.split(regex(",\s*"))} else {""},
    )
    } else {
      ( title: "", author: "", description: "", keywords: "")
    }
  }

  (metadata)
}

#let get-header-data(data) = {
  let header-main = {
    if parse-check(data, "header") and parse-check(data.header, "main") {
      (
        name: if parse-check(data.header.main, "name") {data.header.main.name} else {"Name Middle Last"},
        role: if parse-check(data.header.main, "role") {data.header.main.role} else {"Role"},
        location: if parse-check(data.header.main, "location") {data.header.main.location} else {"Earth, Solar System"},
      )
    } else{
      (
        name: "Name Middle Last",
        role: "Role",
        location: "Earth, Solar System"
      )
    }
  }
  
  (header-main)
}

#let get-header-conf(data) = {
  let main = {
    if parse-check(data, "header") and parse-check(data.header, "main") {
      (
        font: if parse-check(data.header.main, "font") {data.header.main.font} else {"Arial"},
        text-size: parse-length(if parse-check(data.header.main, "text_size"){ data.header.main.text_size} else {"32pt"})
      )
    } else {
      (
        font: "Arial",
        text-size: 32pt
      )
    }
  }

  (main: main)
}
