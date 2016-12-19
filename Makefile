XSLTPROC = xsltproc
XHTML5_XSL = /usr/share/xml/docbook/stylesheet/docbook-xsl-ns/xhtml5/docbook.xsl
DBLATEX = dblatex
XMLSRC = debian-zh-faq.xml
XMLSTARLET = xmlstarlet

all: debian-zh-faq.xhtml debian-zh-faq.pdf

debian-zh-faq.xhtml: $(XMLSRC)
	$(XSLTPROC) --output debian-zh-faq.xhtml $(XHTML5_XSL) $(XMLSRC)

debian-zh-faq.pdf: $(XMLSRC)
	$(DBLATEX) -b xetex $(XMLSRC)

validation: $(XMLSRC)
	$(XMLSTARLET) val --err --xsd /usr/share/xml/docbook/schema/xsd/5.0/docbook.xsd $(XMLSRC)

.PHONY: all validation
