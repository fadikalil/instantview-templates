?exists: //article
title: //article//h1[has-class("title")]
author: //article//a[has-class("autor")]/span[has-class("name")]
author_url: //article//a[has-class("autor")]/@href
@background_to_image: //article//div[has-class("post-img")]
cover: $@
@remove: //article//p[has-class("post-footer-wx")]
body: //article//div[has-class("post-con")]
