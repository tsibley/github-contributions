SHELL := bash -euo pipefail
.DELETE_ON_ERROR:

years := $(shell seq 2009 $(shell date +%Y))
years_html := $(years:=.html)

all: all.html all.tsv

$(years_html): %.html:
	curl -fsS "https://github.com/users/tsibley/contributions?from=$(@:.html=)-01-01&to=$(@:.html=)-12-31" > $@

all.html: styles.html $(years_html)
	cat $^ > $@

styles.html: styles.css

all.tsv: extract-data $(years_html)
	./$^ > $@
