?exists: //div[has-class("post")]
!path_not: /about/
!path_not: /links/
title: //h1[has-class("post-title")]
body: //div[has-class("post-content")]
author: "Phoenix Nemo"
author_url: "https://t.me/phoenixlzx"
datetime(8): //div[has-class("post-info")]
published_date: $@
@remove: //td[has-class("gutter")]
<div>: //table
<div>: //tbody
<div>: //td
<div>: //tr
