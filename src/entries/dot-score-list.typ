#let dot-rating(rating, colors, max-rating: 5) = {
  let active-color = colors.accent
  let inactive-color = colors.dark.darken(20%)
    box(
			stack(
				dir: ltr, spacing: 0.25em,
      ..range(max-rating).map(i => {
        circle(
          radius: 0.25em,
          fill: if i < rating { active-color } else { inactive-color }
        )
      })
    )) + linebreak()
}

#let dot-score-list(conf, data) = {

  let columns = if data.hide-alt {2} else {3}

  table(
    columns: columns,
    column-gutter: 0.75em,
    row-gutter: 0.75em,
    inset: 0pt,
    ..for i in data.list {
    let _head = table.cell(
      text(
        weight: "bold",
        size: conf.text.body-size,
        font: conf.text.font,
        fill: conf.colors.accent,
        i.text
      )
    )
    
    let _alt = table.cell(
      text(
        weight: "regular",
        size: conf.text.body-size,
        font: conf.text.font,
        fill: conf.colors.dark, 
        i.alt
      )
    )
    
    
    let _score = table.cell(
      if data.hide-alt {box(width: 0pt, text(i.alt, fill: white.transparentize(100%)))} + dot-rating(i.rating, conf.colors)
    )

    let _full = (_head, _score)
    if data.hide-alt == false {_full.insert(2, _alt)}

    _full
    }

  )
}

