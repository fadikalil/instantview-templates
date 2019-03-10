~version: "2.0"

?exists: //article[has-class("p-article")]

    $article: //article[has-class("p-article")]

    title: $article//h1[has-class("p-article__title")]
    subtitle: $article//p[has-class("p-article__lead")]

    #description: $article//p[@itemprop="description"]

    published_date: $article//time[@itemprop="datePublished"]/@datetime[not(.="")]
    @datetime(8): $article//time[@itemprop="datePublished"]
    published_date: $@

    cover: $article//figure[has-class("p-article__cover")]

    author: $article//div[@itemprop="author"]//span[@itemprop="name"]

    <cite>: $article//figcaption/span[has-class("credit")]
    <cite>: $article//figcaption/span[contains(text(), "攝：")]
    <cite>: $article//figcaption/span[contains(text(), "圖：")]
    <cite>: $article//blockquote/footer[has-class("source")]

    <slideshow>: $article//section[has-class("album")]

    <div>: $article//figure[has-class("widget-voice")]

    <aside>: $article//figure[has-class("widget-number")]
    $numberwidget: $@
    @wrap(<b>): $numberwidget/span[has-class("number")]
    <cite>: $numberwidget/figcaption

    <div>: $article//figure[has-class("widget-wiki")]

    @remove: $article//img[contains(@alt, "分享給更多人吧")]
    @remove: $article//section[has-class("c-ad")]
    @remove: $article//section[has-class("c-tag-list")]
    @remove: $article//a[contains(@href, "theinitium.com/subscription/offers/")]/parent::strong/parent::p

    @unsupported: //section[has-class("c-wall")]

    @map(//a/img) {
        $img: $@
        $parent: $img/parent::a
        $ownlink: $parent[contains(@href, "/wp-content/uploads/")]
        @if_not($ownlink) {
            @set_attr(href, $parent/@href): $img
        }
        @before_el($parent): $img
        @remove: $parent
    }

    body!: $article//div[@itemprop="articleBody"]

    <related>: //main/section[has-class("c-related-articles")]
    @append_to($body): $@

?path: /project/.+

    site_name: "端傳媒 Initium Media"
    title: //div[@id="header-container"]/h1
    author: //div[@id="header-container"]/p[has-class("author-name")]
    description: //div[@id="prologue"]
    description: //div[has-class("intro__description")]
