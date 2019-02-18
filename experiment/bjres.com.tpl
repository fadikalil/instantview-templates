title: //article//header//h1

published_date: //time[has-class("entry-date")]/@datetime

@remove: //header

#@match("点击查看微信稿件原文"): //article//a
@remove: $@

@remove: //article//br

@remove: //article/div[has-class("entry-content")]//section[has-class("article135")]/section[@data-id="87"]
@remove: //article/div[has-class("entry-content")]//section[has-class("article135")]/section[@data-id="88005"]
@remove: //article/div[has-class("entry-content")]//section[has-class("article135")]/section[last()]

<blockquote>: //article/div[has-class("entry-content")]//section[has-class("article135")]/section[@data-id="85410"]
@combine(<br>): $@//p/following-sibling::*[1]/self::p

<figure>: //article/div[has-class("entry-content")]//section[has-class("article135")]/p/script
@replace("showImg..", ""): $@
@replace("'.+", ""): $@
@after(<img>, "src", $@/text()): $@
@remove: //article/div[has-class("entry-content")]//section[has-class("article135")]/p/figure

body: //article/div[has-class("entry-content")]//section[has-class("article135")]
