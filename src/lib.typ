#import "./helpers.typ": get-colors, get-setup, get-accent-specs, get-metadata
#import "./document-setup.typ": page-setup

#let resume(configuration, data, doc) = {
  let colors = get-colors(configuration)
  let setup = get-setup(configuration)
  let accent-specs = get-accent-specs(configuration, data)
  let metadata = get-metadata(data)

  page-setup(colors, setup, accent-specs, metadata, doc)
  
  doc
}
