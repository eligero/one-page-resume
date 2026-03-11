#import "./utils/helpers.typ": icon-parser

#let table_name(conf, data) = {
  set text(
    size: conf.header.name.size,
    font: conf.header.name.font,
    fill: conf.page.colors.dark
  )

  let name_array = data.header.name.split()
  let name = name_array.first() + " "
  let surname = name_array.slice(1).join(" ")
  
  table(
    columns: 1,
    inset: (left: 0pt),
    text(
      weight: "regular",
      name
    ) +
    text(
      weight: "bold",
      surname
    )
  )
}

#let table_role(conf, data) = {
  set text(size: conf.header.role.loc_size, font: conf.header.role.font)

  let size_corrector = 90%
  let table-inset = (top: 0.5em, bottom: 0.75em)
  
  table(
    align: bottom,
    inset: table-inset,
    columns: (auto, 1.5em, auto, auto),
    table.cell(
      inset: (left: 0pt),
      text(
        size: conf.header.role.role_size,
        weight: "bold",
        fill: conf.page.colors.accent, data.header.role
      )
    ),
    table.cell(""),
    table.cell(
      inset: (
        left:0pt,
        right:0pt,
        bottom: table-inset.bottom -12.5% * size_corrector * conf.header.role.loc_size
      ),
      icon-parser(
        "fa-location-dot",
        size: size_corrector * conf.header.role.loc_size,
        color: conf.page.colors.accent
      )
    ),
    table.cell(
      text(
        fill: conf.page.colors.dark,
        weight: "regular",
        data.header.location
      )
    )
  )
}

#let table_line_icons(conf, data, line) = {

  if data.header.at(line).len() == 0 {
    return
  }

  set text(
    size: conf.header.line-icons.size,
    fill: conf.page.colors.dark,
    font: conf.header.line-icons.font
  )
  let columns = data.header.at(line).len()
  let inset-bottom = if (line == "line_1") { 0.33em } else { 0pt }    
  let table-inset = (top: 0pt, bottom: inset-bottom, left: 0.25em, right: 1em)

  table(
    align: horizon,
    columns: columns * 2,
    inset: table-inset,
    ..for i in data.header.at(line) {(
      table.cell(
        inset:(left: 0pt, right: 0pt),
        icon-parser(
          i.icon,
          size: conf.header.line-icons.size,
          color: conf.page.colors.accent
        )
      ),
      table.cell(
        if i.link.len() > 0 {
          link(i.link, i.text)
        } else {
          i.text
        }
      ),      
    )}
  )
}

#let table_summary(inset, summary_size) = [
  #set text(size: summary_size)
  #table(
    inset: inset,
    columns: 100%,
    table.cell(lorem(24))
  )
  #label("table-summary")
]

#let header(conf, data) = {
  let page_width = 100% + conf.page.margins.left + conf.page.margins.right

  show <table-summary>: it => {
    let height_available = (
      page.height * conf.header.corner.size.height
      + conf.header.corner.size.y-offset
      - conf.page.margins.top
      - conf.page.margins.bottom
    )

    layout(size => [
      #let (height,) = measure(width: size.width, it)
      #if height > height_available {
        set text(red)       
        it
      } else {
        it
      }
    ])
  }

  show <header-grid>: it => {
    let height_available = (
      page.height * conf.header.corner.size.height
      - conf.header.corner.size.y-offset
      - conf.page.margins.top
    )

    layout(size => [
      #let (height,) = measure(width: size.width, it)
      #if height > height_available {
        set table(fill: red)       
        it
      } else {
        it
        v(
          height_available
          + conf.header.corner.size.y-offset
          + conf.page.margins.top
          - height
        )
      }
    ])
  }
 
  [
    #grid(
      columns: (
        (
          page_width
          - page_width * conf.header.corner.size.width
          - conf.page.margins.left
        ),
        (
          page_width * conf.header.corner.size.width
          - conf.page.margins.right
        )
      ),
      inset: 0pt,
      column-gutter: 0%,
      grid.cell(
        breakable: false,
        table_name(conf, data) +
        table_role(conf, data) +
        table_line_icons(conf, data, "line_1") +
        table_line_icons(conf, data, "line_2")
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