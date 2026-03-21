#import "./helpers.typ": icon-parser, type-tag

#let display-dates(date-start, date-end, format) = {
  let _format = {
    if format == "FULL"{
      "[year]-[month repr:numerical]-[day]"
    } else if format == "YM" {
      "[month repr:numerical]/[year]"
    } else { //"Y"
      "[year]"
    }
  }

  if date-start != false and date-end != false {
    if type(date-end) == str{
      date-start.display(_format) + " - " + date-end
    }else{
      date-start.display(_format) + " - " + date-end.display(_format)
    }
  } else if date-start != false {
    date-start.display(_format)
  } else {
    date-end.display(_format)
  }
}

#let columns-width(data) = {
  let columns = (lwing: false, main: 100%, rwing: false)
  let widths = (
    lwing: 1.875em, // icon
    main: 0pt, // dynamic
    rwing: (title: 0pt, dates: 0pt, error: 0.25em)
  )
  let is_icon = data.list.all(it => it.icon.len() > 0)
  let is_date = (
    format: not data.date-format == false,
    start: data.list.all(
      it => it.keys().contains("date-start") and it.date-start != false
    ),
    end: data.list.all(
      it => it.keys().contains("date-end") and it.date-end != false
    ),
    end-str-any: data.list.any(
      it => it.keys().contains("date-end") and type(it.date-end) == str
    ),
    end-str-all: data.list.all(
      it => it.keys().contains("date-end") and type(it.date-end) == str
    )
  )
  let is_title-right = data.list.all(
    it => it.keys().contains("title-right") and it.title-right.len() > 0
  )
  

  if is_icon {
    columns.lwing = widths.lwing
    columns.main -= widths.lwing
  }

  if is_title-right {
    widths.rwing.title = calc.max(..(
      data.list.map(d => measure(eval(d.title-right, mode: "markup")).width)
    ))
  }

  if is_date.format {
    let _date-text = ""
    if is_date.start and is_date.end {
      if is_date.end-str-any {
        _date-text = data.list.map(
          d => if type(d.date-end) == str {d.date-end} else {""}
        ).sorted(key: s => s.len()).last()
      }
      if is_date.end-str-all {
        widths.rwing.dates = measure(display-dates(
          datetime(day: 1, month: 3, year: 2026),
          _date-text,
          data.date-format
        )).width
      } else {
        widths.rwing.dates = calc.max(
          measure(display-dates(
            datetime(day: 1, month: 3, year: 2026),
            datetime(day: 1, month: 3, year: 2026),
            data.date-format
          )).width,
          measure(display-dates(
            datetime(day: 1, month: 3, year: 2026),
            _date-text,
            data.date-format
          )).width
        )
      }
    } else {
      widths.rwing.dates = measure(display-dates(
        false,
        datetime(day: 1, month: 3, year: 2026),
        data.date-format
      )).width
    }
  }

  if is_title-right or is_date.format {
    columns.rwing = calc.max(
      widths.rwing.title, widths.rwing.dates
    ) + widths.rwing.error
    columns.main -= columns.rwing
  }
  
  return columns.values().filter(v => v != false)
}

#let make-content(conf, data, columns, date-format, extension: false, more: false) = {
  let ncols = columns.len()
  let content = ()
  let parameters = (
    icon: (
      width: 1.875em,
      inset: 0pt,
      size: 150% * conf.text.body-size,
      background-color: none,
      inline: false
    ),
    title: (top: 0.25em, bottom: 0.25em, left: 0.5em, right: 0pt),
    subtitle: (top: 0.25em, bottom: 0.25em, left: 0.5em, right: 0pt),
    description: (
      left: (icon: 0.25em, default: 1em),
      top: 0.4em,
      bottom: (default: 0pt, more: 0.6em)
    ),
    tags: (
      left: (icon: 0.25em, default: 1em),
      top: 0.4em + 0.2em,
      bottom: (default: 0.2em, more: 0.6em + 0.2em)
    ),    
  )
  
  /* *** LOGIC *** */
  let is_icon = not extension and data.keys().contains("icon") and ((type(data.icon) == str and data.icon.len() > 0) or (type(data.icon) == dictionary and data.icon.icon.len() > 0))
  let is_title-right = data.keys().contains("title-right") and data.title-right.len() > 0
  let is_dates = data.date-start != false or data.date-end != false
  let is_description = data.keys().contains("description") and data.description.len() > 0
  let is_tags = data.keys().contains("tags") and data.tags.len() > 0

  /* *** ICON *** */
  if is_icon {
    content.push(table.cell(
        icon-parser(
          data.icon.icon,
          parameters.icon.size,
          fill-color: if data.icon.color != false {rgb(data.icon.color)} else {false},//parameters.icon.color,
          inline: parameters.icon.inline
      ),
      x: 0,
      rowspan: 2,
      inset: parameters.icon.inset,
      align: horizon + center,
    ))
  }

  /* *** TITLE *** */
  if not extension {
    content.push(table.cell(
      text(
        font: conf.text.font,
        size: conf.text.body-size,
        weight: "bold",
        fill: conf.colors.accent,
        eval(data.title, mode: "markup")
      ),
      x: if data.icon.len() > 0 { 1 } else { 0 },
      inset: (
        top: parameters.title.top,
        bottom: parameters.title.bottom, 
        left: if is_icon { parameters.title.left } else { 0pt },
        right: parameters.title.right
      )
    ))
  }

  /* *** SUB-TITLE *** */
  content.push(table.cell(
    text(
      font: conf.text.font,
      size: conf.text.body-size,
      weight: if extension {"bold"} else {"regular"},
      fill: if extension {conf.colors.accent} else {conf.colors.dark},
      data.subtitle
    ),
    x: if is_icon { 1 } else { 0 },
    colspan: if extension and ncols == 3 { 2 } else { 1 },
    inset: (
      top: parameters.subtitle.top,
      bottom: parameters.subtitle.bottom,
      left: if extension and ncols == 3 {
        parameters.subtitle.left + parameters.icon.width
        } else if is_icon {
          parameters.subtitle.left
        } else {0pt},
      right: parameters.subtitle.right
    )
  ))

  /* *** TITLE RIGHT *** */
  if is_title-right {
    content.push(table.cell(
      text(
        font: conf.text.font,
        size: conf.text.body-size,
        weight: "regular",
        fill: conf.colors.accent,
        eval(data.title-right, mode: "markup")
      ),
      x: if is_icon { 2 } else { 1 },
      rowspan: if is_dates { 1 } else { 2 },
      align: right + horizon
    ))
  }

  /* *** DATES *** */
  if is_dates{
    content.push(table.cell(
      text(
        font: conf.text.font,
        size: conf.text.body-size,
        weight: "regular",
        fill: conf.colors.dark,
        display-dates(data.date-start, data.date-end, date-format)
      ),
      x: 1 + int((not extension and is_icon) or (extension and ncols == 3)),
      rowspan: 1 + int(not((not extension and is_title-right) or extension)),
      align: right + horizon
    ))
  }
  
  /* *** DESCRIPTION *** */
  if is_description {
    content.push(table.cell(
      text(
        font: conf.text.font,
        size: conf.text.body-size,
        fill: conf.colors.dark,
        eval(data.description, mode: "markup")
      ),
      colspan: ncols,
      inset: (
        top: parameters.description.top,
        bottom: if more and not is_tags {parameters.description.bottom.more} else {parameters.description.bottom.default},
        left: if extension and ncols == 3 or is_icon{
          parameters.description.left.icon + parameters.icon.width
        } else {parameters.description.left.default},
        right: if is_title-right or is_dates{
          if columns.last().abs < 40pt { columns.last()} else {columns.last()/2}
        } else {0pt},
      )
    ))
  }
  
  /* *** TAGS *** */
  if is_tags {
    content.push(table.cell(
      align: left,
      colspan: ncols,
      inset: (
        top: parameters.tags.top,
        bottom: if more {parameters.tags.bottom.more} else {parameters.tags.bottom.default},
        left: if extension and ncols == 3 or is_icon{
          parameters.tags.left.icon + parameters.icon.width
        } else {parameters.tags.left.default},
        right: if is_title-right or is_dates{columns.last()/2} else {0pt},
      ),
      par(leading: 0.5em, spacing: 0em,
        for i in data.tags.split(",") {
          type-tag(
            i.trim(),
            conf.text.body-size,
          ) + h(0.33em)
        }
      )
    ))
  }

  content
}

#let dynamic-columns(conf, data) = context {
  show link: set text(fill: conf.colors.accent)
  set par(leading: 0.33em)
  
  let columns = columns-width(data)
  
  for i in data.list {
    table(
      inset: 0pt,
      columns: columns,
      ..{
        let more = i.keys().contains("extension") and i.extension.len() > 0
        let main = make-content(
          conf, i, columns, data.date-format,
          extension: false,
          more: more
        )

        let extension = ()
        if more {
          for j in i.extension {
            extension.push(make-content(
              conf, j, columns, data.date-format,
              extension: true,
              more: if j == i.extension.last() {false} else {true}
            ))
          }
        }

        main + extension.flatten()
      }        
    )
    if i != data.list.last() { v(0.6em) }
/*
    let thing(body) = context {
      let size = measure(body)
      [Width = #size.width \ Height = #size.height]
    }
    "sicon = " + thing(icon-parser(
      "si-laragon",
      size: 150% * conf.text.body-size,
      color: conf.colors.dark,
      inline: false
    )) 
    [\ ]
    "fa-aws = " + thing(box(inset: 0pt, icon-parser(
      "fa-aws",
      size: 150% * conf.text.body-size,
      color: conf.colors.dark
    ))) 

    [\ ]
    [#context [#(2em).to-absolute()]]
*/

  }
}
