#import "@preview/fontawesome:0.6.0": *
#import "@preview/sicons:16.0.0": *


#let accent-heading(conf, s) = {
  heading(
    text(
      font: conf.text.font,
      size: conf.text.head-size,
      weight: "bold",
      fill: conf.colors.accent,
      s.slice(0, 3)
    ) +
    text(
      font: conf.text.font,
      size: conf.text.head-size,
      weight: "bold",
      fill: conf.colors.dark,
      s.slice(3)
    ) + box(width: 1fr, line(length: 100%, stroke: conf.colors.accent))
  )
}

#let light-heading(conf, s) = {
  heading(
    text(
      font: conf.text.font,
      size: conf.text.head-size,
      weight: "bold",
      fill: conf.colors.accent,
      smallcaps(s)
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
    if inline {
      return fa-icon(_icon, size: sizes.fa, fill: fill-color)
    } else {
      return text(
        fa-icon(_icon, size: sizes.fa, fill: fill-color),
        bottom-edge: -25% * size
      )
    }
  } else if prefix == "si-" {
    return sicon(slug: _icon, size: sizes.si, icon-color: fill-color.to-hex())
  }
  else{ // custom
    return cu-icon(_icon, sizes.cu, fill-color)
  }
}

#let type-tag(tag, size) = {

  let _measure(body) = {
    let size = measure(body)
    (width: size.width , height: size.height)
  }
  
  let _h = (
    _measure(text(bottom-edge: "bounds",size: size, raw("q"))).height
    - _measure(text(bottom-edge: "baseline", raw("q"))).height
  )

  box(
    fill: luma(230).transparentize(50%),
    inset: 0pt,
    outset: (y: _h, x: _h),
    radius: 30%,
    text(
      weight: "regular",
      size: size - _h,
      fill: luma(100),
      raw(block: false, tag)
    )
  )
}
