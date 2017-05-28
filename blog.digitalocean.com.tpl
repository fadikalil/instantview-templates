?exists: //article
!exists: //body[has-class("post-template")]

title: //article/h1
cover: //article/img[has-class("Article-hero")]
author: //article/div[has-class("Article-meta")]/figure/figcaption/a
author_url: $$/@href
author: //article/div[has-class("Article-meta")]/a
author_url: $$/@href
published_date: //article/div[has-class("Article-meta")]/time/@datetime
@remove: //article//div[has-class("Article-meta")]
@remove: //article//div[has-class("Article-comments")]
@remove: //article//ul[has-class("Share-list")]
@remove: //article/p[1]
@remove: //article/footer
description: //article/p[1]
body: //article
