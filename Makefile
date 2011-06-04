# Makefile for debian-zh-faq for Debian.
#
# GNU GPL v2, Copyright (C) 2000, Anthony Fok <foka@debian.org>
#
# Software packages required for building the Postscript and HTML files:
#     cjk-latex, latex2html, gs, slice, zh-autoconvert,
#     tfm-arphic-bsmi00lp, tfm-arphic-gbsn00lp

SHELL = /bin/sh

title-zh_CN = Debian 中文常见问题解答
DCP-zh_CN   = Debian 中文计划
title-zh_TW = Debian いゅ盽ǎ拜肈秆氮
DCP-zh_TW   = Debian いゅ璸购
title-en    = Debian Chinese FAQ
DCP-en      = Debian Chinese Project

L2H_LANG-zh_CN = ZH.CN
L2H_LANG-zh_TW = ZH.TW
L2H_LANG-en = EN

locales = zh_CN zh_TW en
frames = frame noframe
comma = ,
dvitargets = $(foreach i,$(locales),debian-zh-faq.$(i).dvi)
pstargets = $(foreach i,$(locales),debian-zh-faq.$(i).ps.gz)
pdftargets = $(foreach i,$(locales),debian-zh-faq.$(i).pdf)
htmltargets = $(foreach i,$(locales),$(addprefix html-$(i)-,$(frames)))

# Primary targets

all: dvi ps pdf

dvi: $(dvitargets)

ps: $(pstargets) dvi

pdf: $(pdftargets)

html: $(htmltargets)

# Common rule

debian-zh-faq.zh_CN.tex debian-zh-faq.zh_TW.tex debian-zh-faq.en.tex \
debian-zh-faq-zh_CN-html.tex debian-zh-faq-zh_TW-html.tex \
debian-zh-faq-en-html.tex: \
	debian-zh-faq.zh.tex.in \
	tocn.pl totw.pl totw_zhe.pl tohtml.pl totw_zhe_html.pl

	slice	-o UNDEFuZH@uCN-EN:debian-zh-faq.zh_CN.tex.tmp \
		-o UNDEFuZH@uTW-EN:debian-zh-faq.zh_TW.tex.tmp \
		-o UNDEFuEN@uCN-ZH:debian-zh-faq.en.tex.tmp \
		debian-zh-faq.zh.tex.in

	# For LaTeX
	./tocn.pl < debian-zh-faq.zh_CN.tex.tmp \
		> debian-zh-faq.zh_CN.tex
	./tocn.pl < debian-zh-faq.en.tex.tmp \
		> debian-zh-faq.en.tex
	autob5 < debian-zh-faq.zh_TW.tex.tmp | ./totw.pl | ./totw_zhe.pl \
		> debian-zh-faq.zh_TW.tex

	# For LaTeX2HTML
	./tohtml.pl < debian-zh-faq.zh_CN.tex.tmp | ./tocn.pl \
		> debian-zh-faq-zh_CN-html.tex
	./tohtml.pl < debian-zh-faq.en.tex.tmp | ./tocn.pl \
		> debian-zh-faq-en-html.tex
	./tohtml.pl < debian-zh-faq.zh_TW.tex.tmp | autob5 | ./totw.pl \
		| ./totw_zhe_html.pl > debian-zh-faq-zh_TW-html.tex

	# Checking to ensure all <s<????>> and <t<????>> are translated...
	@if grep -q '<[st]<' *.tex; then \
		echo "Error!  Unsubstituted <s<????>> or <t<????>> found!" > /dev/stderr; \
		echo "Please double check $< and the Perl scripts." > /dev/stderr; \
		false; \
	fi

	# Good, it passes the test.

# Rules for building gzip'ed Postscript files.

%.zh_CN.dvi: %.zh_CN.tex
	latex $<
#	perl -pi -e 's/(\{mailto:[^@]+)@([^}]+\})/$$1"\@$$2/g;' $(basename $<).idx
	makeindex $(basename $<).idx
	latex $<
	latex $<

%.zh_TW.dvi: %.zh_TW.tex
	bg5latex $<
#	perl -pi -e 's/(\{mailto:[^@]+)@([^}]+\})/$$1"\@$$2/g;' $(basename $<).idx
	makeindex $(basename $<).idx
	bg5latex $<
	bg5latex $<

%.en.dvi: %.en.tex
	latex $<
	makeindex $(basename $<).idx
	latex $<
	latex $<

%.ps: %.dvi
	dvips -t a4 -D 600 -X 600 -Y 600 $< -o

%.ps.gz: %.ps
	gzip -9vf $<

%.pdf: %.dvi
	dvipdfmx $<

# Note: We are not using pdfTeX yet because I haven't figured out how
#       to preserve all the nice hyperlinks with pdfTeX.
#       Until then, let's stick with dvipdfm, or perhaps dvipdfm-cjk!  :-)

#%.zh_TW.cjk: %.zh_TW.tex
#	rm -f $(addprefix $(basename $<).,aux cjk idx ilg ind lof log lot toc)
#	bg5conv < $< > $@

#%.zh_TW.pdf: %.zh_TW.cjk pdftex.cfg
#	pdflatex $<
#	makeindex $(basename $<).idx
#	pdflatex $<
#	pdflatex $<

#%.zh_CN.pdf: %.zh_CN.tex pdftex.cfg
#	rm -f $(addprefix $(basename $<).,aux idx ilg ind lof log lot toc)
#	pdflatex $<
#	makeindex $(basename $<).idx
#	pdflatex $<
#	pdflatex $<

#%.en.pdf: %.en.tex pdftex.cfg
#	rm -f $(addprefix $(basename $<).,aux idx ilg ind lof log lot toc)
#	pdflatex $<
#	makeindex $(basename $<).idx
#	pdflatex $<
#	pdflatex $<

#%-zh_CN-html.aux: %-zh_CN-html.tex
#	latex $<
#	latex $<
#	rm -f $(<F:tex=dvi)

#%-zh_TW-html.aux: %-zh_TW-html.tex
#	bg5latex $<
#	bg5latex $<
#	rm -f $(<F:tex=dvi)

chineseb5.perl chinesegb.perl: chinese.perl.in
	slice	-o UNDEFuCN:chinesegb.perl.tmp \
		-o UNDEFuTW:chineseb5.perl \
		$<
	autogb < chinesegb.perl.tmp > chinesegb.perl
	rm -f chinesegb.perl.tmp

# Rules for building HTML pages.

$(htmltargets): locale = $(strip $(foreach i,$(locales),$(findstring $(i),$@)))
$(htmltargets): frame = $(patsubst html-$(locale)-%,%,$@)
$(htmltargets): frameopt = $(if $(filter-out noframe,$(frame)),$(comma)$(frame))
$(htmltargets): title = $(title-$(locale))
$(htmltargets): DCP = $(DCP-$(locale))
$(htmltargets): L2H_LANG = $(L2H_LANG-$(locale))
$(htmltargets): debian-zh-faq-zh_CN-html.tex debian-zh-faq-zh_TW-html.tex \
		debian-zh-faq-en-html.tex chineseb5.perl chinesegb.perl
	rm -rf $(locale)/html/$(frame)s
	-mkdir -p $(locale)/html/$(frame)s
	latex2html -html_version 4.0,table$(frameopt) -split 4 \
		-iso_language $(L2H_LANG) \
		-t '$(title)' \
		-toc_stars -local_icons -show_section_numbers \
		-address '$(DCP)' \
		-dir $(locale)/html/$(frame)s \
		debian-zh-faq-$(locale)-html.tex

# Cleaning up...

clean:
	rm -f *~ DEADJOE *.tex.tmp
	rm -f *.dvi *.ps *.ps.gz *.pdf

distclean: clean
	rm -rf zh_CN zh_TW en
	rm -f *.tex *.cjk *.aux *.idx *.ilg *.ind *.lof *.log *.lot *.toc *.out
	rm -f chineseb5.perl chinesegb.perl
	rm -f WARNINGS

.PHONY: all dvi ps html clean distclean $(htmltargets)
