#import "@preview/shadowed:0.3.0": shadow

#let page-setup(colors, setup, accent-specs, metadata, doc) = {
  set document(
    title: metadata.title,
    author: metadata.author,
    description: metadata.description,
    keywords: metadata.keywords,
    date: datetime.today(),
  )

	set text(lang: setup.language)
  set par(justify: true)

  set page(
    paper: setup.paper,
    margin: setup.margins,
    background: context if counter(page).get().first() == 1 [
      #place(
        bottom + left, 
        rect(
          fill: colors.accent,
					width: accent-specs.column.width,
					height: 100% - accent-specs.corner.height,
					radius: accent-specs.column.radius,
        )
      )
      #place(
        top + right, 
        rect(
          fill: colors.accent,
					width: accent-specs.corner.width,
					height: accent-specs.corner.height + accent-specs.corner.v_offset,
          radius: accent-specs.corner.radius,
        )
      )      
			#if type(accent-specs.image.path) == array {
			  place(
          top + right,
					dx: - accent-specs.corner.width / 4,
					dy: ((accent-specs.corner.height + accent-specs.corner.v_offset) /2) - (page.width * accent-specs.corner.width /4),
          shadow(
						blur: accent-specs.image.blur,
            fill: colors.light,
						radius: accent-specs.image.radius,
			  	)[
            #box(
              clip: true,
							stroke: accent-specs.image.stroke + colors.light,
							radius: accent-specs.image.radius,
              width: accent-specs.corner.width / 2,
              image(
                "../" + accent-specs.image.path.first(),
                width: 100%,
                height: page.width * accent-specs.corner.width / 2,
              )
            )
          ]
        )
			}
   ]
  )

  doc
}
