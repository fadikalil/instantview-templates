~version: "2.0"
#?exists: //div[@itemtype="http://schema.org/Article"]
?exists: //div[@id="news_content"]
    $main: //div[@id="main_content"]
    title: $main//div[has-class("content_title")]
    subtitle: $main//div[has-class("content_subtitle")]
    @before_el(./..): $main//strong[not(text())]/img
    @before_el(./..): $main//em[not(text())]/img
    @before_el(./..): $main//p[not(text())]/img
    @before_el(./..): $main//p[not(text())]/iframe

    <figure>: $main//div[has-class("news_img") and ./img]
    <figcaption>: $$/div[has-class("mainpic") and ./div[has-class("mainpic_text")]]

    @map($@) {
        $cap: $@
        @clone: $cap
        $cite: $@
        @replace("圖：.+|圖 : .+", ""): $cap
        @match("圖：.+|圖 : .+"): $cite
        <cite>: $cite
        $cite: $@
        @append_to($cap): $cite
    }
    cover: $main//div[@itemprop="articleBody"]/prev-sibling::figure[has-class("news_img")]

    author: $main//*[@itemprop="author"]
    author: $main//div[has-class("content_reporter")]/a
    
    author_url: $$/@href

    body: $main//div[@itemprop="articleBody"]
    body: $main//div[@id="news_content"]
    
    @if ($body[not(./p)]) {
        <p>: $body/div
    }
    @if ($main//div[@itemprop="articleBody"]/prev-sibling::div[has-class("video-container")]) {
        @prepend_to($body): $@
    }
    @if ($main//div[@id="news_content"]/next-sibling::div[has-class("video-container")]) {
        @append_to($body): $@
    }

    $extendread: $body/div/p[contains(text(), "延伸閱讀")]/parent::div
    <h3>: $extendread/p[contains(text(), "延伸閱讀")]
    <related>: $extendread

    <h3>: $body/p[contains(text(), "延伸閱讀") and not(./a)]
    @wrap(<related>): $@
    $extendread: $@
    @append_to($extendread): $extendread/next-sibling::p

    <related>: $body/p[contains(text(), "延伸閱讀") and ./a]
    @prepend(<h3>): $@
    @append("延伸閱讀"): $@

    #<related>: $body/p[contains(text(), "參考資料") and ./a]
    #@prepend(<h3>): $@
    #@append("參考資料"): $@

    <related>: $body//span[contains(text(), "延伸閱讀")]
    @prepend(<h3>): $@
    @append("延伸閱讀"): $@

    <related>: $body//p[contains(text(), "相關連結：")]
    $related_links: $@
    @prepend(<h3>): $related_links
    @append("相關連結"): $@
    @append_to($related_links): $related_links/following-sibling::div[has-class("content_title")]

    <related>: $main//div[@id="related_news"]
    $related_news: $@
    <h3>: $related_news//span[has-class("m_title")]
    @remove: $related_news//div[has-class("news-img")]
    @append_to($body): $related_news

    published_date: //meta[@property="article:published_time"]/@content
    @datetime(8, "zh_CN", "發布 yyyy.MM.dd | HH:mm"): $main//div[has-class("content_date")]
    published_date: $@
