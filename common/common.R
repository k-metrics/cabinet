# データフレームの表示方法を行数と出力先で変える関数
df_print <- function(x, ...){
  if (nrow(x) <= 10) {
    knitr::kable(x, ...)
  } else {
    DT::datatable(x, class = c("display compact"),
                  style = ifelse(interactive(), c("default"), c("bootstrap")),
                  ...)
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