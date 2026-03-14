#import "@preview/fontawesome:0.6.0": *
#import "@preview/sicons:16.0.0": *


#let accent-heading(conf, s) = {
  heading(
    text(
      size: conf.text.head-size,
      weight: "bold",
      fill: conf.colors.accent,
      s.slice(0, 3)
    ) +
    text(
      size: conf.text.head-size,
      weight: "bold",
      fill: conf.colors.dark,
      s.slice(3)
    ) + box(width: 1fr, line(length: 100%, stroke: conf.colors.accent))
  )
}

#let light-heading(conf, s) = {
  underline(offset: 0.3em, stroke: conf.colors.accent, heading(
    text(
      weight: "bold",
      font: conf.text.font,
      size: conf.text.head-size,
      fill: conf.colors.accent,
      s
    )
  ))
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
