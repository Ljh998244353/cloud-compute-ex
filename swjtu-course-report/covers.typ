#import "fonts.typ": 字体, 字号
#import "utils.typ": date_format

#let school-name = [西南交通大学课程报告]
#let school-wordmark() = {
  align(center)[
    #text(font: 字体.黑体, size: 22pt, fill: black, weight: "bold")[#school-name]
  ]
}

#let _info_key(body) = {
  rect(width: 100%, inset: 2pt, stroke: none, text(
    font: 字体.宋体,
    size: 字号.三号,
    body,
  ))
}

#let _info_value(body) = {
  rect(
    width: 125%,
    inset: 3pt,
    stroke: (
      bottom: 1pt + black,
    ),
    text(
      font: 字体.宋体,
      size: 字号.三号,
      bottom-edge: "descender",
    )[#body],
  )
}

#let _work_table() = {
  table(
    columns: (52pt, 96pt, 110pt, 150pt),
    inset: 6pt,
    align: (center, center, center, left),
    stroke: 0.8pt + black,
    [*序号*], [*项目*], [*内容*], [*说明*],
    [1], [课程名称], [待填写], [课程报告],
    [2], [完成方式], [待填写], [个人或小组],
    [3], [任务主题], [待填写], [按课程要求填写],
    [4], [备注说明], [待填写], [可按需删除],
  )
}

#let _course_field(label, value, width: 305pt) = {
  grid(
    columns: (86pt, width),
    column-gutter: 9pt,
    align: (right, center),
    [#text(font: 字体.黑体, size: 字号.三号, weight: "bold")[#label：]],
    [
      #box(
        width: width,
        inset: (bottom: 2pt),
        stroke: (bottom: 0.8pt + black),
      )[
        #align(center)[
          #text(font: 字体.宋体, size: 字号.三号, weight: "bold")[#value]
        ]
      ]
    ],
  )
}

#let cover_swjtu_course(
  title: "",
  title_2: "",
  title_3: "",
  authors: "",
  class: "",
  department: "",
  id: "",
  mentor: "",
  ..args,
) = {
  let course_title = if title != "" { title } else { "《课程名称》" }
  let report_topic = if title_3 != "" { title_3 } else { title_2 }
  let class_text = if class != "" { class } else { "未填写" }
  let department_text = if department != "" { department } else { "未填写" }
  let mentor_text = if mentor != "" { mentor } else { "未填写" }

  align(center)[
    #text(font: 字体.宋体, size: 字号.小五, fill: luma(35%))[
      #course_title 课程报告
    ]
    #v(1.35em)
    #image("assets/swjtu-wordmark.png", width: 55%)
    #v(2.35em)
    #image("assets/swjtu-seal-black.png", width: 35%)
    #v(2.6em)
    #text(font: 字体.黑体, size: 字号.小一, weight: "bold")[#course_title]
    #v(0.55em)
    #text(font: 字体.黑体, size: 字号.小一, weight: "bold")[课程报告]
    #v(4.2em)
    #_course_field("报告题目", report_topic)
    #v(0.95em)
    #_course_field("学　　号", id)
    #v(0.95em)
    #_course_field("姓　　名", authors)
    #v(0.95em)
    #_course_field("班　　级", class_text)
    #v(0.95em)
    #_course_field("学院名称", department_text)
    #v(0.95em)
    #_course_field("授课教师", mentor_text)
  ]
  pagebreak()
}

#let cover_normal(
  title: "Title",
  title_2: "",
  authors: "author",
  date: (2023, 5, 14),
  lang: "en",
  show_name: true,
  ..args,
) = {
  let authors = if show_name { authors } else { none }
  align(center)[
    #school-wordmark()
    #v(4em)
    #image("assets/校徽.jpg", width: 40%)
    #set par(leading: 1.5em)
    #text(title, font: 字体.宋体, size: 字号.一号, weight: "bold")
    #v(4em)
    #if title_2 != "" {
      text(title_2, font: 字体.宋体, size: 字号.小一, weight: "bold")
      v(4em)
    }
    #v(4em)
    #text(authors, font: 字体.宋体, size: 字号.三号)
    #v(1em)
    #date_format(date: date, lang: lang)
  ]
  pagebreak()
}

#let cover_report(
  title: "",
  title_2: "",
  authors: "",
  class: "",
  grade: "",
  department: "",
  date: (2023, 04, 17),
  id: "",
  lang: "en",
  mailbox: "",
  major: "",
  mentor: "",
  type: 1,
  ..args,
) = {
  date = date_format(date: date, lang: lang, size: 字号.三号)
  align(center + horizon)[
    #school-wordmark()
    #v(1.2em)
    #text(title, font: 字体.宋体, size: 字号.小一, weight: "bold")
    #v(0.5em)
    #if (type == "4" or type == "5") {
      text(title_2, font: 字体.宋体, size: 字号.二号, weight: "bold")
    }
    #if (lang == "en") {
      let title = (_info_key("Project Name"), _info_value(title_2))
      let authors = (_info_key("Student Name"), _info_value(authors))
      let id = (_info_key("Student ID"), _info_value(id))
      let class = (_info_key("Class"), _info_value(class))
      let major = (_info_key("Major"), _info_value(major))
      let department = (_info_key("Department"), _info_value(department))
      let date = (_info_key("Date"), _info_value(date))
      let mailbox = (_info_key("Mailbox"), _info_value(mailbox))
      let mentor = (_info_key("Mentor"), _info_value(mentor))
      // self define your style here
      let info_show = if type == "1" {
        (title + authors + id + class + department + date)
      } else if type == "2" {
        (title + authors + department + major + mailbox + date)
      } else if type == "3" {
        (title + authors + id + mailbox + mentor + date)
      } else if type == "4" {
        (authors + id + class + department + date)
      } else if type == "5" {
        (authors + department + major + mailbox + date)
      }
      grid(
        columns: (160pt, 180pt),
        rows: (40pt, 40pt),
        gutter: 3pt,
        ..info_show
      )
    } else {
      let authors = (_info_key("姓　　名"), _info_value(authors))
      let department = (_info_key("学　　院"), _info_value(department))
      let major = (_info_key("专　　业"), _info_value(major))
      let date = (_info_key("时　　间"), _info_value(date))
      let info_show = (authors + department + major + date)
      v(1.4em)
      grid(
        columns: (120pt, 220pt),
        rows: (34pt, 34pt),
        gutter: 3pt,
        ..info_show
      )
      v(1.6em)
      align(center)[
        #text(font: 字体.黑体, size: 字号.三号, weight: "bold")[成员分工]
      ]
      v(0.5em)
      _work_table()
    }
  ]
  pagebreak()
}

#let cover_anonymous_report(
  title: "",
  title_2: "",
  title_3: "",
  date: (2023, 5, 14),
  lang: "en",
  ..args,
) = {
  align(center + horizon)[
    #school-wordmark()
    #v(5em)
    #image("assets/校徽.jpg", width: 70%)
    #v(3em)
    #text(title, font: 字体.宋体, size: 字号.小一, weight: "bold")
    #v(1em)
    #text(title_2, font: 字体.宋体, size: 字号.小二 + 2pt)
    #v(0.5em)
    #text(title_3, font: 字体.宋体, size: 字号.小二)
    #v(0.1em)
    #date_format(date: date, lang: lang)
  ]
  pagebreak()
}

#let show_cover(infos: (:)) = {
  // 如果 report_type 中含有数字，则提取并细化设置 report 类型，默认为 1
  if (infos.cover_style == false or infos.cover_style == "" or infos.cover_style == none) { return } // no cover
  if (infos.cover_style == "swjtu-course" or infos.cover_style == "swjtu-course-report") {
    cover_swjtu_course(..infos)
    return
  }
  let report_type = if infos.cover_style.match(regex("\d+")) != none {
    infos.cover_style.match(regex("\d+")).text
  } else { "1" }
  let cover_style = infos.cover_style.trim(report_type)
  if cover_style == "report" and infos.show_name { cover_report(type: report_type, ..infos) } // 实验报告
  else if cover_style == "report" { cover_anonymous_report(..infos) } // 匿名实验报告
  else { cover_normal(..infos) }
}
