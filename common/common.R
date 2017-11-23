# データフレームの表示方法を出力に応じて自動的に選択する関数
df_print <- function(x, caption = NULL, n = NULL, scroller = FASEL,
                     scrollY = 250, ...){
  out_format <- knitr::opts_knit$get("rmarkdown.pandoc.to") 
  if (!is.null(out_format)) {
    if (out_format %in% c("html", "revealjs")) {  # ioslids, reveal.js, shower
      DT::datatable(extensions = c('Scroller', 'FixedColumns'),
                    options = list(deferRender = TRUE, dom = 't',
                                   scroller = scroller, scrollY = scrollY, 
                                   fixedColumns = TRUE, scrollX = TRUE))
    } else {
      print(x)    # slidy
    }
  } else {        # console
    print(x)      
  }
}

# 階級幅を計算する関数（スタージェスの公式）
breaks <- function(x) {
  pretty(range(x), n = nclass.Sturges(x))
}

# 標本平均を求めて任意の有効数字に丸める関数
s_mean <- function(x, r = 2){
  round(mean(x), r)
}

# 標本分散を求める関数（Rでは不偏分散を求める関数しかない）
s_var <- function(x, r = 2){
  n <- length(x)
  round(((n - 1)/n)*var(x), r)
}

# 標本の標準偏差を求める関数
s_sd <- function(x, r = 2){
  round(sqrt(s_var(x)), r)
}

# ページサムネイルを表示する関数(http://rmarkdown.rstudio.com/rmarkdown_websites.html#html_generation)
require(htmltools)
thumbnail <- function(title, img, href, caption = TRUE) {
  div(class = "col-sm-4",
      a(class = "thumbnail", title = title, href = href, img(src = img),
        div(class = ifelse(caption, "caption", ""), ifelse (caption, title, "")
        )
      )
  )
}