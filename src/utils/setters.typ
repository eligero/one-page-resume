#import "./helpers.typ": parse-length
#import "@preview/shadowed:0.3.0": shadow


#let page-background-top-corner(conf) = {
  place(
    top + right, 
    rect(
      fill: conf.page.colors.accent,
			width: conf.header.corner.size.width,
			height: conf.header.corner.size.height + conf.header.corner.size.y-offset,
      radius: conf.header.corner.radius,
    )
  )
}

#let page-background-accent-image(conf, data) = {
  if data.header.profile-img.len() > 0 {
		place(
      top + right,
			dx: - conf.header.corner.size.width / 4,
			dy: (
        (conf.header.corner.size.height + conf.header.corner.size.y-offset) / 2
        - (page.width * conf.header.corner.size.width / 4)
      ),
      shadow(
				blur: conf.header.image.blur, 
        fill: conf.page.colors.light,
				radius: conf.header.image.radius,
			)[
        #box(
          clip: true,
					stroke: conf.header.image.stroke + conf.page.colors.light, 
					radius: conf.header.image.radius,
          width: conf.header.corner.size.width / 2,
          image(
            "/" + data.header.profile-img,
            width: 100%,
            height: page.width * conf.header.corner.size.width / 2,
          )
        )
      ]
    )
  }
}

#let page-background-accent-column(conf) = {
  place(
    bottom + left, 
    rect(
      fill: conf.page.colors.accent,
			width: conf.accent-column.width,
			height: 100% - conf.header.corner.size.height,
			radius: conf.accent-column.radius,
    )
  )
}

#let page-background(conf, data) = context if counter(page).get().first() == 1 [
  #page-background-top-corner(conf)
  #page-background-accent-image(conf, data)
  #page-background-accent-column(conf)
]

#let get-page-conf(conf, data) = (
  paper: conf.page.paper,
  margin: conf.page.margins,
  background: page-background(conf, data)
)

#let get-document-conf(data) = (
  title: data.metadata.title,
  author: data.metadata.author,
  description: data.metadata.description,
  keywords: data.metadata.keywords.split(regex(",\s*")),
  date: datetime.today(),
)

#let setters(configuration, data, doc) = {
	set document(..(get-document-conf(data)))
  set page(..(get-page-conf(configuration, data)))
  set par(spacing: 0pt, justify: true)
  set text(lang: configuration.page.language, hyphenate: false)

	doc
}