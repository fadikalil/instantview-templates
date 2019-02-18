~version: "2.0"

site_name: "ACI Digital"

?exists: //head/meta[@property="og:type"]/@content[.="article"]

@debug: "Is Article"

$container: /html/body/div[has-class("container")]

title: $container//h1

<figure>: $container//div[@id="main_image_container"]
<figcaption>: $$/div[has-class("main_caption")]
cover: $container//figure[@id="main_image_container"]

body: $container//div[@id="content"]/div[@data-io-article-url]/div[has-class("noticia-contenido")]

@if (//div[@id="main"]/div[has-class("videowrapper")]) {
  @prepend_to($body): $@
}

$meta: /html/head/script[contains(text(), "_io_config")]

@clone: $meta
@match("article_publication_date: \"([^\"]+)\"", 1): $@
@datetime: $@
published_date: $@

@clone: $meta
@match("article_authors: \\[\"([^\"]+)\"", 1): $@
@html_to_dom: $@
author: $@

@before_el(./..): //p/iframe

@set_attr(class, null): $body//blockquote[has-class("twitter-tweet") and not(*)]

#$tweet: //p/strong[text()="Confira também:"]/parent::p
#$tweet+: $$/next-sibling::blockquote
#@remove: $tweet
