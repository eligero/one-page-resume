#import "./utils/setters.typ": setters
#import "./utils/helpers.typ": parse-data
#import "./header.typ": header
#import "content.typ": contents

#let resume(configuration, data, doc) = {

  let parsed-conf = parse-data(toml("./utils/configuration.toml"), configuration)
  let parsed-data = parse-data(toml("./utils/data.toml"), data)

  show: setters.with(parsed-conf, parsed-data, debug: false)
  
  let page_width = 100% + parsed-conf.page.margins.left + parsed-conf.page.margins.right
  
  header(parsed-conf, parsed-data)
  
  grid(
    columns: (
      page_width * parsed-conf.accent-column.width - parsed-conf.page.margins.left,
      page_width - (page_width * parsed-conf.accent-column.width) - parsed-conf.page.margins.right,
    ),
    inset: 0pt,
    column-gutter: 0%,
    grid.cell(
      inset: (right: parsed-conf.page.margins.right),
      breakable: true,
      contents(parsed-conf, parsed-data.accent-column, content: "accent-column")
    ),
    grid.cell(
      inset: (left: parsed-conf.page.margins.left),
      breakable: true,
      contents(parsed-conf, parsed-data.main-column, content: "main-column")
    )
  )

  doc
}
