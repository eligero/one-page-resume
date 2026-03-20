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

#let cu-icon(path, size, fill-color) = {
  let file-format = lower(path.split(".").last())

  if file-format == "svg" and fill-color != false {
    let black-regex = regex(
      "fill:\s*(#000000|#000|rgb\(\s*0\s*,\s*0\s*,\s*0\s*\))"
    )
    return image(
      bytes(
        read("/" + path)
        .replace(
          black-regex,
          "fill:" + fill-color.to-hex()
        )
      ),
      width: size,
    )
  } else {
    return box(clip: true, radius: 25%, image("/" + path, width: size))
  }
}

#let icon-parser(icon, size, fill-color: false, inline: true) = {

  let prefix = icon.match(regex("^(fa|si|custom)-")).text
  let _icon = icon.replace(regex("^(fa|si|custom)-"), it => "")

  let sizes = (
    fa: size,
    si: if inline {size * 87.5%} else {size * 125%},
    cu: if inline {size * 87.5%} else {size * 125%},
  )
    
  if prefix == "fa-" {
    return text(
      fa-icon(_icon, size: sizes.fa, fill: fill-color),
      bottom-edge: -25% * size
    )
  } else if prefix == "si-" {
    return sicon(slug: _icon, size: sizes.si, icon-color: fill-color.to-hex())
  }
  else{ // custom
    return cu-icon(_icon, sizes.cu, fill-color)
  }
}

#let type-tag(tag, size, background-color, text-color) = {
  box(
    fill: background-color.transparentize(50%),
    inset: (x: 0.25em, y: 0.05em),
    outset: (y: 0.2em),
    radius: 25%,
    baseline: 25%,
    text(
      weight: "regular",
      size: size,
      fill: text-color,
      raw(tag)
    )
  )
}
