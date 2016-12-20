XSLTPROC = xsltproc
XHTML5_XSL = /usr/share/xml/docbook/stylesheet/docbook-xsl-ns/xhtml5/docbook.xsl
DBLATEX = dblatex
XMLSRC = debian-zh-faq.xml
XMLSRC_S = debian-zh-faq-s.xml
XMLSTARLET = xmlstarlet

all: html pdf

pdf: debian-zh-faq.pdf debian-zh-faq-s.pdf

html: debian-zh-faq.xhtml debian-zh-faq-s.xhtml

debian-zh-faq.xhtml: $(XMLSRC)
	$(XSLTPROC) --output debian-zh-faq.xhtml $(XHTML5_XSL) $(XMLSRC)

debian-zh-faq-s.xhtml: $(XMLSRC_S)
	$(XSLTPROC) --output debian-zh-faq-s.xhtml $(XHTML5_XSL) $(XMLSRC_S)

debian-zh-faq.pdf: $(XMLSRC)
	$(DBLATEX) -b xetex $(XMLSRC)

debian-zh-faq-s.pdf: $(XMLSRC_S)
	$(DBLATEX) -T native -b xetex -s ./dblatex-s.sty $(XMLSRC_S)

validation: $(XMLSRC)
	$(XMLSTARLET) val --err --xsd /usr/share/xml/docbook/schema/xsd/5.0/docbook.xsd $(XMLSRC)

.PHONY: all validation pdf html
