#let simple(conf, data) = {
  let paragraph = (
      leading: 0.5em,
      spacing: 0.75em,
      justify: true,
      linebreaks: "optimized",
    )

  set par(
    leading: paragraph.leading,
    spacing: paragraph.spacing,
    justify: paragraph.justify,
    linebreaks: paragraph.linebreaks
  )

  show link: it => {
    let _w=conf.text.body-size/3
    let _h=conf.text.body-size/3
    
    it + h(0.1em) + box(
      height: paragraph.leading,
      width: conf.text.body-size/3,
      curve(
        stroke: 0.5pt + conf.colors.accent,
        curve.line((_w/3, 0pt)),
        curve.line((0pt, 0pt)),
        curve.line((0pt, _h)),
        curve.line((_w, _h)),
        curve.line((_w, _h - _h/3)),
        curve.move((_w, 0pt), relative: false),
        curve.line((_w - _w/3, 0pt)),
        curve.line((_w, 0pt)),
        curve.line((_w, _h/3)),
        curve.move((_w/2, _h/2), relative: false),
        curve.line((_w, 0pt)),
      ) 
    )
  }

  if data.text.len() == 0 {
    data.text = lorem(20)
  }

  let _paragraphs = data.text.split("\n")
  
  for i in _paragraphs {
    let _par = eval(i, mode: "markup")
    par(
      text(
        font: conf.text.font,
        size: conf.text.body-size,
        fill: if data.hide-heading or data.heading.len() == 0 {
            conf.colors.accent
          } else {
            conf.colors.dark
          },
          if data.hide-heading { strong(_par)} else { _par}
        )
    )
  }
}
