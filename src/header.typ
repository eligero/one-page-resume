#import "./utils/helpers.typ": fa-icon-box


#let table_name(conf) = {
  set text(size: conf.header.name.size, font: conf.header.name.font)
  table(
    stroke: 1pt,
    columns: 1,
    [Name Middle Last]
  )
}

#let table_role(role_size, loc_size) = {
  set text(size: role_size)
  table(
    align: horizon,
    stroke: 1pt,
    inset: (top: 0.5em, bottom: 0.5em),
    columns: (1fr, auto, 1fr),
    table.cell([Role]),
    table.cell(align:bottom, text(size: loc_size, fa-icon-box("location-dot", alignment:"bottom"))),
    table.cell(align: bottom, text(size: loc_size, "Location")),
  )
}

#let table_line_icons(columns, icon, description, icon_size) = {
  set text(size: icon_size)
  table(
    stroke: 1pt,
    columns: columns * 2,
    inset: (y: 0.5em),
    ..for i in range(columns) {
      (
        table.cell(fa-icon-box(icon)),
        table.cell(inset: (right: 1em), [#description]),
      )
    }
  )
}

#let table_summary(inset, summary_size) = [
  #set text(size: summary_size)
  #table(
    inset: inset,
    stroke: 1pt,
    columns: 100%,
    table.cell(lorem(24))
  )
  #label("table-summary")
]

#let header(conf, data) = {
  let page_width = 100% + conf.page.margins.left + conf.page.margins.right

  show <table-summary>: it => {
    let height_available = page.height * conf.header.corner.size.height + conf.header.corner.size.y-offset - conf.page.margins.top - conf.page.margins.bottom

    layout(size => [
      #let (height,) = measure(
        width: size.width,
        it,
      )
      #if height > height_available {
        set text(red)       
        it
      } else {
        it
      }
    ])
  }

  show <header-grid>: it => {
    let height_available = page.height * conf.header.corner.size.height - conf.header.corner.size.y-offset - conf.page.margins.top

    layout(size => [
      #let (height,) = measure(
        width: size.width,
        it,
      )
      #if height > height_available {
        set table(fill: red)       
        it
      } else {
        it
        v(height_available + conf.header.corner.size.y-offset + conf.page.margins.top - height)
      }
    ])
  }
 
  [
  #grid(
    columns: (
      page_width - page_width * conf.header.corner.size.width - conf.page.margins.left,
      page_width * conf.header.corner.size.width - conf.page.margins.right,
    ),
    inset: 0pt,
    stroke: 2pt + red,
    column-gutter: 0%,
    grid.cell(
      breakable: false,
      table_name(conf) +
      table_role(conf.header.role.role_size, conf.header.role.loc_size) +
      table_line_icons(5, "linkedin", "nickname", conf.header.line-icons.size) +
      table_line_icons(3, "square-github", "Long description test", conf.header.line-icons.size)
    ),
    grid.cell(
      breakable: false,
      if data.header.profile-img.len() == 0 {
        table_summary(
          (left: conf.page.margins.left, right: 0pt),
          conf.header.profile-text.size
        )
      }
	  )
  )
  #label("header-grid")
  ]
}