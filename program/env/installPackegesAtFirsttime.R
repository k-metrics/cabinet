# データ分析勉強会参加メンバー向け推奨パッケージのインストールスクリプト
# （フルインストール版）

# Choose nearest CRAN mirror site
chooseCRANmirror(graphics = TRUE)

# データサイエンスワークフローの各プロセスに基づいて必要と思われるパッケージを
# インストールするようにしています。追加したい場合は当該のプロセスに追加して
# ください
#   https://github.com/rstudio/RStartHere
pkg_univers <- c("tidyverse")

# `tidyverse v1.1.1` imports follows
#   broom, dplyr, forcats, ggplot2, haven, httr, hms,
#   jsonlite, lubridate, magrittr, modelr, purrr, readr, readxl,
#   stringr, tibble, rvest, tidyr, xml2

pkg_import <- c("DBI")
pkg_tidy <- c(NULL)
pkg_tranform <- c("data.table", "dtplyr")
pkg_model <- c("forecast", "ineq", "multcomp", "ppcor", "psych", "simpleboot",
               "TTR")
pkg_visualize <- c("DT", "extrafont", "GGally", "ggThemeAssist", "gridExtra",
                   "listviewer", "plotly", "RColorBrewer")
pkg_infer <- c(NULL)
pkg_communicate <- c("bookdown", "knitr", "learnr", "listviewer", "rmarkdown",
                     "tufte", "xtable")
pkg_automate <- c("shiny")

# データサイエンスワークフローのプロセスでは分類できないパッケージ
pkg_program <- c("devtools", "packrat", "Rcmdr")

# `dplyr`の学習に最適なデータパッケージ
pkg_data <- c("nycflights13")

# OS依存のパッケージ
if (Sys.info()["sysname"] == "Windows") {
  pkg_osd <- c("installr")
} else {
  pkg_osd <- c(NULL)
}

# 必要なパッケージのリスト化
pkg_lst <- c(pkg_univers, pkg_import, pkg_tidy, pkg_tranform, pkg_model,
             pkg_visualize, pkg_infer, pkg_communicate, pkg_automate,
             pkg_program, pkg_data, pkg_osd)

# 必要なパッケージのインストール
install.packages(pkgs = pkg_lst)

# パッケージの更新
# 新規インストール時には更新の必要なないはずですが心配ならアップデートチェックを
# update.packages(ask = "graphics")

# CRAN以外からのインストール
# CRAN以外からインストールして利用しているパッケージがあれば`devtools`等を使って
# インストールします

# Rcmdrを最初にインストールした時は必ず起動して不足しているパッケージを追加
# インストールします
# require(Rcmdr)