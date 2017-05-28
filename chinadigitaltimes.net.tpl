?exists: //body[has-class("single-post")]

$post: //div[has-class("post")]
title: $post/h1

@remove: //*[@id="syndication_permalink"]

#@replace("文 ", ""): //*[@id="content"]/div/div[2]/p[1]/text()
#@replace("| (.+)", "$1"): $$
#author: //*[@id="content"]/div/div[2]/p[1]
#@remove: $$

#@wrap(<center>): //em
@combine(<br>, <br>): //blockquote/p/following-sibling::*[1]/self::p
@remove: //div[has-class("sharedaddy")]

#@replace_tag(<a>): //iframe
#@set_attr(href, @src): $@
@unsupported: //iframe

body: $post//div[has-class("entry")]
