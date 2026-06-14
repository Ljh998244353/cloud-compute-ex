#import "../lib.typ": *

#show: project.with(
  title: "《课程名称》",
  title_2: "课程报告",
  title_3: "报告题目",
  authors: "姓名",
  date: datetime.today(),
  cover_style: "swjtu-course",
  header: "type1",
  footer: "type1",
  show_toc: true,
  show_name: true,
  lang: "zh",
  class: "班级",
  major: "专业",
  mentor: "指导教师",
  department: "学院",
  id: "学号",
  toc_depth: 2,
)

= 示例标题

这里只展示最小用法示例。复制模板后，正文结构可按课程要求自由调整。引用图 @fig-swjtu。

== 二级标题

#figure(
  image("../assets/校徽.jpg", width: 36%),
  caption: [西南交通大学校徽示例],
) <fig-swjtu>

== 表格示例

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    align: (center, center, center),
    table.hline(stroke: 1.5pt),
    table.header[*编号*][*项目*][*说明*],
    table.hline(stroke: 1pt),
    [1], [章节结构], [按实际课程要求自行安排],
    [2], [图片资源], [按需放入 assets 或 figures 目录],
    table.hline(stroke: 1.5pt),
  ),
  caption: [表格示例],
) <tab-example>

== 参考文献示例

// #bibliography("../assets/exbib.bib", style: "gb-7714-2015-numeric", title: "参考文献")
