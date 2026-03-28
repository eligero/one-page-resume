#import "./utils/setters.typ": setters
#import "./utils/helpers.typ": parse-data
#import "./entries/header.typ": header
#import "./entries/_index.typ": contents

#let resume(configuration, data, doc) = context {

  let parsed-conf = parse-data(
    toml("./utils/configuration.toml"), configuration)
  let parsed-data = parse-data(toml("./utils/data.toml"), data)

  show: setters.with(parsed-conf, parsed-data, debug: false)

  let columns-width = (
    header: (
      page.width
      - parsed-conf.header.corner.size.width * page.width
      - parsed-conf.page.margins.left
    ),
    accent-corner:(
      page.width * parsed-conf.header.corner.size.width
      - parsed-conf.page.margins.right
    ),
    accent-column: (
      page.width * parsed-conf.accent-column.width
      - parsed-conf.page.margins.left
    ),
    main-column: (
      page.width
      - page.width * parsed-conf.accent-column.width
      - parsed-conf.page.margins.right
    )
  )

  let header-height = (
    page.height * parsed-conf.header.corner.size.height
    + parsed-conf.header.corner.size.y-offset
    - parsed-conf.page.margins.top
    - parsed-conf.page.margins.bottom
  )

  let check-height(body, width, max-height) = {
    let size = measure(body)
    if size.height > max-height {
      block(
        fill: red.lighten(80%),
        inset: 0pt,
        width: width,
        height: max-height,
        body
    ) 
    } else {
       body
    }
  }

  check-height(
    header(parsed-conf, parsed-data.header, columns-width.header),
    columns-width.header - parsed-conf.page.margins.right,
    header-height
  )

  layout(size => [
    #let (height,) = measure(
      width: size.width,
      header(parsed-conf, parsed-data.header, columns-width.header)
    )

    #v(
      header-height
      - parsed-conf.header.corner.size.y-offset
      + parsed-conf.page.margins.bottom
      + parsed-conf.page.margins.top
      - height
    )
  ])
  
  grid(
    columns: (columns-width.accent-column, columns-width.main-column),
    inset: 0pt,
    column-gutter: 0%,
    grid.cell(
      inset: (right: parsed-conf.page.margins.right),
      breakable: true,
      contents(
        parsed-conf,
        parsed-data.accent-column,
        content: "accent-column"
      )
    ),
    grid.cell(
      inset: (left: parsed-conf.page.margins.left),
      breakable: true,
      contents(parsed-conf, parsed-data.main-column, content: "main-column")
    )
  )

  if parsed-data.extended.len() > 1 {
    pagebreak()
    contents(parsed-conf, parsed-data.extended, content: "main-column")
  }

  doc
}
