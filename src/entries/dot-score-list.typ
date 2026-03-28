#import "./helpers.typ": ats-gaps, ats-text

#let dot-rating(rating, colors, max-rating: 5) = {
  let active-color = colors.accent
  let inactive-color = colors.light.darken(20%)
	
  let _dot = stack(
		dir: ltr,
    spacing: 0.25em,
    ..range(max-rating).map(i => {
      circle(
        radius: 0.25em,
        fill: if i < rating { active-color } else { inactive-color }
      )
    })
  )

  _dot
}

#let dot-score-list(conf, data) = {
  let paragraph = (
    leading: 0.5em,
    spacing: 0.6em,
    justify: true,
    linebreaks: "optimized",
  )

  set par(
    leading: paragraph.leading,
    spacing: paragraph.spacing,
    justify: paragraph.justify,
    linebreaks: paragraph.linebreaks
  )

  let _data = (
    head-width: (),
    alt-width: (),
    data: ()
  )


  for i in data.list {
    let _head = text(
        weight: "bold",
        size: conf.text.body-size,
        font: conf.text.font,
        fill: conf.colors.accent,
        i.text
    )

    let _alt = text(
      weight: "regular",
      size: conf.text.body-size,
      font: conf.text.font,
      fill: conf.colors.dark,
      i.alt
    )

    _data.head-width.push(
      measure(_head).width
    )

    _data.alt-width.push(
      if not data.hide-alt { measure(_alt).width } else { 0pt }
    )

    _data.data.push((
      head: _head + box(
        width: 0pt,
        ats-text(":", conf.text.body-size, conf.text.font, false)
      ),
      alt: if not data.hide-alt { _alt } else {
        box(
          width: 0pt,
          ats-text(i.alt, conf.text.body-size, conf.text.font, false)
        )
      },
      rating: i.rating
    ))
  }

  let head-width = calc.max(.._data.head-width)
  let alt-width = calc.max(.._data.alt-width)

  for i in _data.data {
    par(
      ats-gaps(
        head-width - measure(i.head).width,
        conf.text.body-size,
        conf.text.font
      )
      + i.head
      + h(0.75em)
      + i.alt
      + if not data.hide-alt {
        ats-gaps(
          0.75em + alt-width - measure(i.alt).width,
          conf.text.body-size,
          conf.text.font
        )
      }
      + box(dot-rating(i.rating, conf.colors))
    )
  }
}
