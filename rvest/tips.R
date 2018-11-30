require(dplyr)
require(ggplot2)
require(rvest)
# require(xml2)     # `rvest`から読み込まれるので明示指定しなくても可
require(stringr)

# ページを読み込む(当日)
amedas <- xml2::read_html("http://www.jma.go.jp/jp/amedas_h/today-44132.html?areaCode=000&groupCode=30")

# amedas.session <- rvest::html_session("http://www.jma.go.jp/jp/amedas_h/today-44132.html?areaCode=000&groupCode=30")

# 前日
amedas.y <- xml2::read_html("http://www.jma.go.jp/jp/amedas_h/yesterday-44132.html?areaCode=000&groupCode=30")

# 文字セットを調べる
meta <- amedas %>% 
  rvest::html_nodes("head > meta:nth-child(1)") %>% 
  rvest::html_attrs()
start <- stringr::str_locate(meta, pattern = "charset=")[2]
end <- stringr::str_locate(meta, pattern = '\\)')[1]
encode <- stringr::str_sub(meta, start = start + 1, end = end - 2)

# タイトルを取得する(タイトルがある場所はブラウザのインスペクターを使って当該の
# 属性を調べておく必要がある)
# Firefoxの場合は「一意なセレクタをコピー」で属性を取得できる
title <- amedas %>% 
  rvest::html_nodes(css = ".td_title") %>% 
  rvest::html_text() %>% 
  iconv(from = encode, to = "shift-jis", sub = "")

# テーブルも同様で、取得結果はリスト形式になるので必要に応じてデータフレーム
# 形式等に変換する
table <- amedas %>% 
  rvest::html_nodes(css = "#tbl_list") %>% 
  rvest::html_table(header = TRUE, trim = TRUE, fill = TRUE) %>% 
  as.data.frame()

table.y <- amedas.y %>% 
  rvest::html_nodes(css = "#tbl_list") %>% 
  rvest::html_table(header = TRUE, trim = TRUE, fill = TRUE) %>% 
  as.data.frame()

# 項目名と単位(必ず2行目にある想定)を取得し、単位行を削除する
name <- colnames(table)
unit <- table[1, ]
g.name <- paste(name, " [", unit, "]", sep = "")
# table <- table[-1, ]                # 行番号は歯抜けになる
table <- dplyr::slice(table, -1)    # 行番号が1から振り直される
table.y <- dplyr::slice(table.y, -1)    # 行番号が1から振り直される

# 項目名を英語に変更(季節が変わると積雪深という項目が増える)
colnames(table) <- c("time", "temp", "rain", "wind.dir", "wind", "shine",
                     "snow", "humidity", "pressure")
colnames(table.y) <- c("time", "temp", "rain", "wind.dir", "wind", "shine",
                       "snow", "humidity", "pressure")

table <- dplyr::bind_rows(table.y, table)

# アメダスでは空に見える欄に「<U+00A0>」(No-Break Space)というコードが入って
# いるのでこれを「NA」(欠損値)に置換する
for (i in 1:ncol(table)) {
  table[, i] <- iconv(table[, i], from = encode, to = "shift-jis", sub = NA)
  if (i == 1){
    table[, i] <- as.integer(table[, i])
  } else if (i != 4) {
    table[, i] <- as.numeric(table[, i])
  }
}

# 時刻を相対時間に変換する
time.now <- as.integer(format(Sys.time(), "%H"))
table[, 1] <- seq(-(time.now + 23L), (24L - time.now))
# g.name[1] <- paste("相対", g.name[1], sep = "")
# X軸目盛のテキスト
# x.text <- as.character(rep(1:24, times = 2))
x.text <- as.character(rep(seq(from = 1, to = 24, by = 2), times = 2))
x.breaks <- seq(from = -(time.now + 23L), to = (24L - time.now), by = 2)

# 気圧(8列目)の折れ線グラフを描く
table %>%
  ggplot(aes(x = time, y = pressure)) +
  geom_line() +
  geom_point() +
  theme(text = element_text(family = "IPAPMincho"),
        axis.text.y = element_text(size = 12)) +
  scale_x_continuous(breaks = x.breaks, labels = x.text) +
  ggtitle(paste(title, " : ", time.now, "時現在", sep = "")) +
  xlab(g.name[1]) + ylab(g.name[8])

file <- paste("./plot/", format(Sys.time(), "%Y%m%d_%H%M"), ".jpg", sep = "")
ggplot2::ggsave(filename = file, width = 6.4, height = 4.8, units = "in")

# plot(as.numeric(table$pressure))
