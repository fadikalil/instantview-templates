?path: /story\?sid=[0-9]+
title: //div[has-class("bg_htit")]/h2
body: //div[has-class("p_mainnew")]
author: //div[has-class("talk_time")]/a[1]
author_url: $$/@href
image_url: //div[has-class("talk_time")]/div[has-class("icon-float")]/a/img/@src

?path: /news/view\?id=[0-9]+
title: //div[has-class("bg_htit")]/h2
body: //div[has-class("p_content")]
#match("来源于:(.+)", 1): //div[has-class("talk_time")]/b
#author: $@
author: //div[has-class("talk_time")]/b
