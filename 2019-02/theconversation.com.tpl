~version: "2.0"

?exists: //article[@id="article"]

$article: //article[@id="article"]

title: $article//h1[has-class("entry-title")]
published_date: $article//time[@itemprop="datePublished"]/@datetime

@set_attr(src, @data-src): $article//img[has-class("lazyload")]
@background_to_image: $article//figure[has-class("magazine")]/div[has-class("image")]

@set_attr(srcset, ""): $article//img
@replace("q=[0-9]+", "q=95"): $article//img/@src
@replace("\\?.*", "?ixlib=rb-1.1.0&q=95&auto=format&w=2560"): $article//img[not(contains(@src, "rect="))]/@src

cover: $article//figure[has-class("magazine")]
cover: $article//figure[has-class("content-lead-image")]
@remove: $$/div[has-class("magazine-title")]
<cite>: $article//span[has-class("attribution")]
#@wrap(<cite>): $article//a[has-class("source")]

@unsupported: $article//iframe[has-class("tc-infographic")]
@unsupported: $article//iframe[has-class("tc-infographic-datawrapper")]
@unsupported: $article//iframe[contains(@id, "infographie")]
@unsupported: $article//iframe[contains(@src, "e.infogram.com")]
@unsupported: $article//iframe[contains(@src, "piktochart.com")]
@unsupported: $article//iframe[contains(@src, "dwcdn.net")]
@unsupported: $article//iframe[contains(@src, "ourworldindata.org")]


body: $article//div[@itemprop="articleBody"]

$readmore: $body//*[contains(text(), "Read more:")]
#$readmore: $body//p/em/strong[./a[contains(@href, "theconversation.com/")]]
@map($readmore) {
  <related>: $@
  $rl: $@
  #$cap: $@/text()[normalize-space()]
  #@replace(":", ""): $cap
  #@debug: $cap
  @prepend(<h3>): $rl
  @append("Read more"): $@
  #@append_to($@): $cap
}

@after_el(./../..): $body/p/em/strong[contains(text(), "See also:")]
$seealso: $body/*[contains(text(), "See also:")]
#$readmore: $body//p/em/strong[./a[contains(@href, "theconversation.com/")]]
@map($seealso) {
  <related>: $@
  $rl: $@
  @prepend(<h3>): $rl
  @append("See also"): $@
  $linkblock: $rl/next-sibling::p
  @append_to($rl): $linkblock
  @remove: $rl/prev-sibling::p
}

<related>: $article//div[has-class("content-related-container")]
$related: $@
@map($related/div[has-class("content-related-articles")]/div[has-class("related-article")]) {
  <a>: $@
  $at: $@
  $link: $at//a[has-class("article-link")]/@href
  @set_attr(href, $link): $at
}
@append_to($body): $related

@remove: $body//section[has-class("inline-content")]

@before_el(./../..): $body/p/em/related
@remove: $body/related/next-sibling::p
@remove: $body/related/prev-sibling::hr
@remove: $body/related/next-sibling::hr

@if ($article//div[has-class("lead-audio")]) {
  <figure>: $@
  $fig: $@
  <figcaption>: $fig/div[has-class("audio-player-caption")]
  @prepend_to($body): $fig
  @remove: $fig//span[has-class("download")]
}

# @map($body//p/audio) {
#   $au: $@
#   <figure>: $au/parent::p
#   $fig: $@
#   @append(<figcaption>): $@
#   $cap: $@
#   @html_to_dom: $au/@data-title
#   @append_to($cap): $@
#   @append(<cite>): $@
#   $source: $@
#   @html_to_dom: $au/@data-source
#   @append_to($source): $@
#   @html_to_dom: $au/@data-license
#   @append_to($source): $@
#   @debug: $fig
# }

@map($body//p/audio) {
  $au: $@
  <figure>: $au/parent::p
  $fig: $@
  <figcaption>: $fig/next-sibling::div[has-class("audio-player-caption")]
  $cap: $@
  @append_to($fig): $cap
  @remove: $cap//span[has-class("download")]
}

@map($body//div[@data-react-class="Tweet"]) {
  $twwidget: $@
  @json_to_xml: $@/@data-react-props
  $twid: $@/tweetId/text()
  <iframe>: $twwidget
  @set_attr(src, "https://twitter.com/i/status/", $twid)
}

@map($body//div[@data-react-class="InstagramEmbed"]) {
  $igwidget: $@
  @json_to_xml: $@/@data-react-props
  $igurl: $@/url/text()
  <iframe>: $igwidget
  @set_attr(src, $igurl)
}

@map($body//a/img) {
  $img: $@
  $parent: $img/parent::a
  $ownlink: $parent[contains(@href, "images.theconversation.com")]
  @if_not($ownlink) {
    @set_attr(href, $parent/@href): $img
  }
  @before_el($parent): $img
  @remove: $parent
}

@before_el(./..): $body//p/img

@unsupported: $body//div[@data-react-class]
