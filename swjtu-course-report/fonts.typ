// typst 读取字体时会按顺序回退。这里优先使用当前机器已存在的字体，
// 避免编译结果依赖系统的隐式 fallback。
#let 字体 = (
  宋体: ("Times New Roman", "Noto Serif CJK SC", "Droid Sans Fallback"),
  黑体: ("Arial", "Noto Sans CJK SC", "Droid Sans Fallback"),
  思源宋体: "Noto Serif CJK SC",
  思源黑体: "Noto Sans CJK SC",
  楷体: ("LXGW WenKai", "Noto Serif CJK SC", "Droid Sans Fallback"),
  ntl: "Arial",
  meslo: "Nimbus Mono PS",
  meslo-mono: "Nimbus Mono PS",
  tnr: "Times New Roman",
);

#let 字号 = (
  初号: 42pt,
  小初: 36pt,
  一号: 26pt,
  小一: 24pt,
  二号: 22pt,
  小二: 18pt,
  三号: 16pt,
  小三: 15pt,
  四号: 14pt,
  小四: 12pt,
  五号: 10.5pt,
  小五: 9pt,
  六号: 7.5pt,
  小六: 6.5pt,
  七号: 5.5pt,
  八号: 5pt
);

// 汉字伪粗体，from https://discord.com/channels/1054443721975922748/1054443722592497796/1175967383630921848
#let skew(angle, vscale: 1, body) = {
  let (a, b, c, d) = (1, vscale * calc.tan(angle), 0, vscale)
  let E = (a + d) / 2
  let F = (a - d) / 2
  let G = (b + c) / 2
  let H = (c - b) / 2
  let Q = calc.sqrt(E * E + H * H)
  let R = calc.sqrt(F * F + G * G)
  let sx = Q + R
  let sy = Q - R
  let a1 = calc.atan2(F, G)
  let a2 = calc.atan2(E, H)
  let theta = (a2 - a1) / 2
  let phi = (a2 + a1) / 2

  set rotate(origin: bottom + center)
  set scale(origin: bottom + center)

  rotate(phi, scale(x: sx * 100%, y: sy * 100%, rotate(theta, body)))
}
#let fake-italic(body) = box(skew(-12deg, body))
