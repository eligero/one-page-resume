#let simple(conf, data) = {
  set par(
    spacing: 0em,
    leading: 0.5em,
  )

  if data.text.len() == 0 {
    data.text = lorem(20)
  }

  text(
    font: conf.text.font,
    size: conf.text.body-size,
    fill: if data.hide-heading or data.heading.len() == 0 {
        conf.colors.accent
      } else {
        conf.colors.dark
      },
      if data.hide-heading { strong(data.text)} else { data.text}
  )
}