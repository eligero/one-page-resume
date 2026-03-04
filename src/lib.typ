#import "./utils/setters.typ": setters
#import "./utils/helpers.typ": parse-data

#let resume(configuration, data, doc) = {

  let parsed-conf = parse-data(toml("./utils/configuration.toml"), configuration)
  let parsed-data = parse-data(toml("./utils/data.toml"), data)

  show: setters.with(parsed-conf, parsed-data)
  
  doc
}
