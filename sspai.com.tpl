?path: /post/[0-9]+
cover: //article/img[has-class("banner")]
title: //article/h1[has-class("title")]
author: //article/div[has-class("meta")]/div[has-class("user-card")]/h4/a
author_url: $$/@href
@remove: //article//div/br/../.
body: //article/div[@id="article-content"]/div[@ref="content"]
