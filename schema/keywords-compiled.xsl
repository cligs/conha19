<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:oxy="http://www.oxygenxml.com/schematron/validation"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:cligs="https://cligs.hypotheses.org/ns/cligs"
                version="2.0"
                xml:base="file:/home/ulrike/Git/conha19/schema/keywords.sch_xslt_cascade"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
   <xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>
   <!--PHASES-->
   <!--PROLOG-->
   <xsl:output xmlns:iso="http://purl.oclc.org/dsdl/schematron" method="xml"/>
   <!--XSD TYPES FOR XSLT2-->
   <!--KEYS AND FUNCTIONS-->
   <!--DEFAULT RULES-->
   <!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-get-full-path">
      <xsl:variable name="sameUri">
         <xsl:value-of select="saxon:system-id() = parent::node()/saxon:system-id()"
                       use-when="function-available('saxon:system-id')"/>
         <xsl:value-of select="oxy:system-id(.) = oxy:system-id(parent::node())"
                       use-when="not(function-available('saxon:system-id')) and function-available('oxy:system-id')"/>
         <xsl:value-of select="true()"
                       use-when="not(function-available('saxon:system-id')) and not(function-available('oxy:system-id'))"/>
      </xsl:variable>
      <xsl:if test="$sameUri = 'true'">
         <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      </xsl:if>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*:</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>[namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="$sameUri = 'true'">
         <xsl:variable name="preceding"
                       select="count(preceding-sibling::*[local-name()=local-name(current())       and namespace-uri() = namespace-uri(current())])"/>
         <xsl:text>[</xsl:text>
         <xsl:value-of select="1+ $preceding"/>
         <xsl:text>]</xsl:text>
      </xsl:if>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="text()" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:text>text()</xsl:text>
      <xsl:variable name="preceding" select="count(preceding-sibling::text())"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="comment()" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:text>comment()</xsl:text>
      <xsl:variable name="preceding" select="count(preceding-sibling::comment())"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:text>processing-instruction()</xsl:text>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::processing-instruction())"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-2-->
   <!--This mode can be used to generate prefixed XPath for humans-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
   <!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: GENERATE-ID-FROM-PATH -->
   <xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>
   <!--MODE: GENERATE-ID-2 -->
   <xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters-->
   <xsl:template match="text()" priority="-1"/>
   <!--SCHEMA SETUP-->
   <xsl:template match="/">
      <xsl:apply-templates select="/" mode="M10"/>
      <xsl:apply-templates select="/" mode="M11"/>
      <xsl:apply-templates select="/" mode="M12"/>
      <xsl:apply-templates select="/" mode="M13"/>
      <xsl:apply-templates select="/" mode="M14"/>
      <xsl:apply-templates select="/" mode="M15"/>
      <xsl:apply-templates select="/" mode="M16"/>
      <xsl:apply-templates select="/" mode="M17"/>
      <xsl:apply-templates select="/" mode="M18"/>
      <xsl:apply-templates select="/" mode="M19"/>
      <xsl:apply-templates select="/" mode="M20"/>
      <xsl:apply-templates select="/" mode="M21"/>
   </xsl:template>
   <!--SCHEMATRON PATTERNS-->
   <xsl:param name="cligs-idno" select=".//tei:idno[@type='cligs']"/>
   <xsl:param name="bibacme-work-id"
              select=".//tei:title[@type='idno']/tei:idno[@type='bibacme']"/>
   <xsl:param name="bibliography" select="doc('../bib/bibliography.xml')"/>
   <xsl:param name="keywords-file" select="document('keywords.xml')"/>
   <xsl:param name="bibacme-authors"
              select="document('https://raw.githubusercontent.com/cligs/bibacme/master/app/data/authors.xml')"/>
   <xsl:param name="bibacme-editions"
              select="document('https://raw.githubusercontent.com/cligs/bibacme/master/app/data/editions.xml')"/>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="tei:titleStmt" priority="1007" mode="M10">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:title[@type = 'main'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: TEI header error: Main title is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:title[@type = 'sub'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: TEI header error: Subtitle is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:title[@type = 'short'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: TEI header error: Short title is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:title[@type = 'idno']/tei:idno[@type = 'viaf'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: TEI header error: title VIAF-ID is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:title[@type = 'idno']/tei:idno[@type = 'bibacme'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: TEI header error: Bib-ACMé work ID is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:title[@type = ('series','main','sub','short','idno')]"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: TEI header error: a title type "</xsl:text>
               <xsl:text/>
               <xsl:value-of select="@type"/>
               <xsl:text/>
               <xsl:text>" is not supported.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:titleStmt/tei:author" priority="1006" mode="M10">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:name[@type = 'full'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: TEI header error: full author name is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:name[@type = 'short'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: TEI header error: short author name is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:idno[@type = 'viaf'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: TEI header error: author VIAF ID is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="author-id-bibacme" select="tei:idno[@type = 'bibacme']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$author-id-bibacme[. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: TEI header error: author Bib-ACMé work ID is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="author-surname"
                    select="tei:name[@type='full']/substring-before(.,',')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$bibacme-authors//tei:person[@xml:id=$author-id-bibacme]//tei:surname[.=$author-surname]"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: TEI header error: the author surname does not correspond to the one in Bib-ACMé.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:titleStmt/tei:principal" priority="1005" mode="M10">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@xml:id[. = 'uhk']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: TEI header error: principal ID should be 'uhk'.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test=". = 'Ulrike Henny-Krahmer'"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: TEI header error: principal should be 'Ulrike Henny-Krahmer'.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:extent/tei:measure[@unit = 'words']"
                 priority="1004"
                 mode="M10">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test=". != ''"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: TEI header error: word count is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:publicationStmt" priority="1003" mode="M10">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:publisher/tei:ref[. = 'CLiGS']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: TEI header error: publisher is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:publisher/tei:ref[@target = 'http://cligs.hypotheses.org/']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: TEI header error: link to publisher is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:availability[@status]"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: TEI header error: availability status is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:date[. = '2020']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: TEI header error: publication date is wrong.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:idno[@type = 'cligs'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: TEI header error: CLiGS ID is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:idno[@type = 'url']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: TEI header error: URL ID is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:sourceDesc" priority="1002" mode="M10">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:bibl[@type = 'digital-source'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: TEI header error: digital source is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:bibl[@type = 'print-source'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: TEI header error: print source is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:bibl[@type = 'edition-first'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: TEI header error: first edition is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="work-editions"
                    select="$bibacme-editions//tei:biblStruct[substring-after(@corresp,'#')=$bibacme-work-id]"/>
      <xsl:variable name="edition-years"
                    select="$work-editions[.//tei:date/(@when|@to)]//tei:date/substring(@when|@to,1,4)"/>
      <xsl:variable name="year-edition-first-bibacme"
                    select="min(for $i in $edition-years return xs:integer($i))"/>
      <xsl:variable name="year-edition-first-conha19"
                    select="tei:bibl[@type = 'edition-first']/tei:date/xs:integer(@when)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$year-edition-first-conha19 = $year-edition-first-bibacme"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: TEI header error: the year of the first edition in Conha19 (</xsl:text>
               <xsl:text/>
               <xsl:value-of select="$year-edition-first-conha19"/>
               <xsl:text/>
               <xsl:text>) does not correspond to the year in Bib-ACMé (</xsl:text>
               <xsl:text/>
               <xsl:value-of select="$year-edition-first-bibacme"/>
               <xsl:text/>
               <xsl:text>).</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:encodingDesc" priority="1001" mode="M10">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:p[. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: TEI header error: encoding description is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:abstract" priority="1000" mode="M10">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@source[. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: TEI header error: abstract source is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="@*|*" mode="M10"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="tei:term" priority="1001" mode="M11">
      <xsl:variable name="keyword-types-allowed"
                    select="('author.continent','author.country','author.country.birth','author.country.death','author.country.nationality','author.gender',                 'text.source.medium','text.source.filetype','text.source.institution','text.source.edition',                 'text.publication.first.country','text.publication.first.medium','text.publication.first.type','text.publication.type.independent',                 'text.language','text.form','text.genre.supergenre','text.genre','text.title',                 'text.genre.subgenre.title.explicit','text.genre.subgenre.title.implicit',                 'text.genre.subgenre.paratext.explicit','text.genre.subgenre.paratext.implicit',                 'text.genre.subgenre.opening.implicit', 'text.genre.subgenre.contemp.explicit',                 'text.genre.subgenre.historical.explicit','text.genre.subgenre.historical.explicit.norm','text.genre.subgenre.historical.implicit',                 'text.genre.subgenre.litHist','text.genre.subgenre.litHist.interp',                 'text.genre.subgenre.summary.signal.explicit','text.genre.subgenre.summary.signal.implicit',                 'text.genre.subgenre.summary.theme.explicit','text.genre.subgenre.summary.theme.implicit','text.genre.subgenre.summary.theme.litHist',                 'text.genre.subgenre.summary.identity.explicit','text.genre.subgenre.summary.identity.implicit','text.genre.subgenre.summary.identity.litHist',                 'text.genre.subgenre.summary.current.explicit','text.genre.subgenre.summary.current.implicit','text.genre.subgenre.summary.current.litHist',                 'text.genre.subgenre.summary.mode.attitude.explicit','text.genre.subgenre.summary.mode.attitude.implicit','text.genre.subgenre.summary.mode.attitude.litHist',                 'text.genre.subgenre.summary.mode.intention.explicit','text.genre.subgenre.summary.mode.intention.implicit','text.genre.subgenre.summary.mode.intention.litHist',                 'text.genre.subgenre.summary.mode.reality.explicit','text.genre.subgenre.summary.mode.reality.implicit','text.genre.subgenre.summary.mode.reality.litHist',                 'text.genre.subgenre.summary.mode.medium.explicit','text.genre.subgenre.summary.mode.medium.implicit','text.genre.subgenre.summary.mode.medium.litHist',                 'text.genre.subgenre.summary.mode.representation.explicit','text.genre.subgenre.summary.mode.representation.implicit','text.genre.subgenre.summary.mode.representation.litHist',                 'text.narration.narrator', 'text.narration.narrator.person','text.speech.sign','text.speech.sign.type','text.setting.continent','text.setting.country',                 'text.time.period','text.time.period.author','text.time.period.publication','text.prestige')"/>
      <xsl:variable name="keyword-types-once"
                    select="('author.continent','author.country','author.country.birth','author.country.death','author.country.nationality','author.gender',                 'text.source.medium','text.source.filetype','text.source.edition',                 'text.publication.first.country','text.publication.first.medium','text.publication.first.type','text.publication.type.independent',                 'text.language','text.form','text.genre.supergenre','text.genre',                 'text.narration.narrator', 'text.narration.narrator.person','text.speech.sign','text.speech.sign.type','text.setting.continent','text.setting.country',                 'text.time.period','text.time.period.author','text.time.period.publication','text.prestige')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@type = $keyword-types-allowed"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Keyword error: the keyword type </xsl:text>
               <xsl:text/>
               <xsl:value-of select="@type"/>
               <xsl:text/>
               <xsl:text> is not supported.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="kw-type" select="@type"/>
      <!--REPORT -->
      <xsl:if test="@type = $keyword-types-once and preceding-sibling::tei:term[@type=$kw-type]">
         <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
            <xsl:text> </xsl:text>
            <xsl:text/>
            <xsl:value-of select="$cligs-idno"/>
            <xsl:text/>
            <xsl:text>: Keyword error: the keyword </xsl:text>
            <xsl:text/>
            <xsl:value-of select="@type"/>
            <xsl:text/>
            <xsl:text> should only occur once but does several times.</xsl:text>
         </xsl:message>
      </xsl:if>
      <xsl:apply-templates select="@*|*" mode="M11"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:keywords" priority="1000" mode="M11">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='author.continent'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: author.continent is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='author.country'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: author.country is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='author.country.birth'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: author.country.birth is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='author.country.death'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: author.country.death is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='author.country.nationality'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: author.country.nationality is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='author.gender'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: author.gender is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.source.medium'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.source.medium is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.source.filetype'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.source.filetype is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.source.institution'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.source.institution is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.source.edition'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.source.edition is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.publication.first.country'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.publication.first.country is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.publication.first.medium'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.publication.first.medium is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.publication.first.type'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.publication.first.type is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.publication.type.independent'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.publication.type.independent is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.language'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.language is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.form'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.form is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.genre.supergenre'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.genre.supergenre is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.genre'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.genre is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.title'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.title is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.genre.subgenre.title.explicit'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.genre.subgenre.title.explicit is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.genre.subgenre.title.implicit'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.genre.subgenre.title.implicit is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.genre.subgenre.paratext.explicit'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.genre.subgenre.paratext.explicit is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.genre.subgenre.paratext.implicit'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.genre.subgenre.paratext.implicit is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.genre.subgenre.historical.explicit'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.genre.subgenre.historical.explicit is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.genre.subgenre.historical.explicit.norm'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.genre.subgenre.historical.explicit.norm is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.genre.subgenre.historical.implicit'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.genre.subgenre.historical.implicit is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.narration.narrator'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.narration.narrator is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.narration.narrator.person'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.narration.narrator.person is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.speech.sign'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.speech.sign is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.speech.sign.type'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.speech.sign.type is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.setting.continent'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.setting.continent is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.setting.country'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.setting.country is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.time.period'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.time.period is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.time.period.author'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.time.period.author is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.time.period.publication'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.time.period.publication is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="tei:term[@type='text.prestige'][. != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.prestige is missing.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="@*|*" mode="M11"/>
   </xsl:template>
   <!--PATTERN -->
   <xsl:variable name="cat-author"
                 select="$keywords-file//tei:category[@xml:id = 'author']"/>
   <!--RULE -->
   <xsl:template match="tei:term[@type='author.continent']"
                 priority="1005"
                 mode="M12">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test=". = $cat-author/tei:category[@xml:id = 'author.continent']/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: author.continent</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M12"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:term[@type='author.country']" priority="1004" mode="M12">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test=". = $cat-author/tei:category[@xml:id = 'author.country']/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: author.country</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M12"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:term[@type='author.country.birth']"
                 priority="1003"
                 mode="M12">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test=". = $cat-author//tei:category[@xml:id = 'author.country.birth']/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: author.country.birth</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M12"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:term[@type='author.country.death']"
                 priority="1002"
                 mode="M12">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test=". = $cat-author//tei:category[@xml:id = 'author.country.death']/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: author.country.death</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M12"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:term[@type='author.country.nationality']"
                 priority="1001"
                 mode="M12">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test=". = $cat-author//tei:category[@xml:id = 'author.country.nationality']/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: author.country.nationality</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M12"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:term[@type='author.gender']" priority="1000" mode="M12">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test=". = $cat-author/tei:category[@xml:id = 'author.gender']/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: author.gender</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="@*|*" mode="M12"/>
   </xsl:template>
   <!--PATTERN -->
   <xsl:variable name="cat-source"
                 select="$keywords-file//tei:category[@xml:id = 'text.source']"/>
   <!--RULE -->
   <xsl:template match="tei:term[@type='text.source.medium']"
                 priority="1003"
                 mode="M13">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = $cat-source/tei:category[@xml:id = 'text.source.medium']/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.source.medium</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M13"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:term[@type='text.source.filetype']"
                 priority="1002"
                 mode="M13">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = $cat-source/tei:category[@xml:id = 'text.source.filetype']/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.source.filetype</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M13"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:term[@type='text.source.institution']"
                 priority="1001"
                 mode="M13">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = $cat-source/tei:category[@xml:id = 'text.source.institution']/tei:category/tei:catDesc/normalize-space(.)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.source.institution</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (preceding-sibling::tei:term[@type='text.source.institution']) then parent::tei:keywords/tei:term[@type='text.source.institution'][@cligs:importance='2'] else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: if text.source.institution occurs several times, @cligs:importance is needed to prioritize</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M13"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:term[@type='text.source.edition']"
                 priority="1000"
                 mode="M13">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = $cat-source/tei:category[@xml:id = 'text.source.edition']/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.source.edition</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="@*|*" mode="M13"/>
   </xsl:template>
   <!--PATTERN -->
   <xsl:variable name="cat-publication"
                 select="$keywords-file//tei:category[@xml:id = 'text.publication']"/>
   <!--RULE -->
   <xsl:template match="tei:term[@type='text.publication.first.country']"
                 priority="1003"
                 mode="M14">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = $cat-publication//tei:category[@xml:id = 'text.publication.first.country']/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.publication.first.country</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M14"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:term[@type='text.publication.first.medium']"
                 priority="1002"
                 mode="M14">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = $cat-publication//tei:category[@xml:id = 'text.publication.first.medium']/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.publication.first.medium</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M14"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:term[@type='text.publication.first.type']"
                 priority="1001"
                 mode="M14">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = $cat-publication//tei:category[@xml:id = 'text.publication.first.type']/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.publication.first.type</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M14"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:term[@type='text.publication.type.independent']"
                 priority="1000"
                 mode="M14">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = $cat-publication//tei:category[@xml:id = 'text.publication.type.independent']/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.publication.type.independent</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="@*|*" mode="M14"/>
   </xsl:template>
   <!--PATTERN -->
   <xsl:variable name="cat-language"
                 select="$keywords-file//tei:category[@xml:id = 'text.language']"/>
   <!--RULE -->
   <xsl:template match="tei:term[@type='text.language']" priority="1005" mode="M15">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test=". = $cat-language/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.language</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M15"/>
   </xsl:template>
   <xsl:variable name="cat-form"
                 select="$keywords-file//tei:category[@xml:id = 'text.form']"/>
   <!--RULE -->
   <xsl:template match="tei:term[@type='text.form']" priority="1003" mode="M15">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test=". = $cat-form/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.form</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M15"/>
   </xsl:template>
   <xsl:variable name="cat-genre"
                 select="$keywords-file//tei:category[@xml:id = 'text.genre']"/>
   <!--RULE -->
   <xsl:template match="tei:term[@type='text.genre.supergenre']"
                 priority="1001"
                 mode="M15">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test=". = $cat-genre/tei:category[@xml:id = 'text.genre.supergenre']/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.supergenre</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M15"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:term[@type='text.genre']" priority="1000" mode="M15">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test=". = $cat-genre/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.genre</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M15"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="@*|*" mode="M15"/>
   </xsl:template>
   <!--PATTERN -->
   <xsl:variable name="cat-subgenre"
                 select="$keywords-file//tei:category[@xml:id = 'text.genre.subgenre']"/>
   <!--RULE -->
   <xsl:template match="tei:term[@type='text.genre.subgenre.historical.explicit.norm']"
                 priority="1003"
                 mode="M16">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = $cat-subgenre//tei:category[@xml:id = 'text.genre.subgenre.historical.explicit.norm']/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: the value "</xsl:text>
               <xsl:text/>
               <xsl:value-of select="normalize-space(.)"/>
               <xsl:text/>
               <xsl:text>" is not documented for text.genre.subgenre.historical.explicit.norm in the keywords file yet.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M16"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:term[@type='text.genre.subgenre.historical.implicit']"
                 priority="1002"
                 mode="M16">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = $cat-subgenre//tei:category[@xml:id = 'text.genre.subgenre.historical.implicit']/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: the value "</xsl:text>
               <xsl:text/>
               <xsl:value-of select="normalize-space(.)"/>
               <xsl:text/>
               <xsl:text>" is not documented for text.genre.subgenre.historical.implicit in the keywords file yet.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M16"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:term[@type='text.genre.subgenre.litHist']"
                 priority="1001"
                 mode="M16">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@resp[substring-after(.,'#') = $bibliography//tei:bibl/@xml:id]"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: "</xsl:text>
               <xsl:text/>
               <xsl:value-of select="@resp"/>
               <xsl:text/>
               <xsl:text>" is missing in the bibliography.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M16"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:term[@type='text.genre.subgenre.litHist.interp']"
                 priority="1000"
                 mode="M16">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = $cat-subgenre//tei:category[@xml:id = 'text.genre.subgenre.litHist.interp']/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: the value "</xsl:text>
               <xsl:text/>
               <xsl:value-of select="normalize-space(.)"/>
               <xsl:text/>
               <xsl:text>" is not documented for text.genre.subgenre.litHist.interp in the keywords file yet.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M16"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M16"/>
   <xsl:template match="@*|node()" priority="-2" mode="M16">
      <xsl:apply-templates select="@*|*" mode="M16"/>
   </xsl:template>
   <!--PATTERN -->
   <xsl:variable name="cat-narration"
                 select="$keywords-file//tei:category[@xml:id = 'text.narration']"/>
   <!--RULE -->
   <xsl:template match="tei:term[@type='text.narration.narrator']"
                 priority="1001"
                 mode="M17">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = $cat-narration/tei:category[@xml:id = 'text.narration.narrator']/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.narration.narrator</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M17"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:term[@type='text.narration.narrator.person']"
                 priority="1000"
                 mode="M17">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = $cat-narration//tei:category[@xml:id = 'text.narration.narrator.person']/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.narration.narrator.person</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M17"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M17"/>
   <xsl:template match="@*|node()" priority="-2" mode="M17">
      <xsl:apply-templates select="@*|*" mode="M17"/>
   </xsl:template>
   <!--PATTERN -->
   <xsl:variable name="cat-speech"
                 select="$keywords-file//tei:category[@xml:id = 'text.speech']"/>
   <!--RULE -->
   <xsl:template match="tei:term[@type='text.speech.sign']"
                 priority="1001"
                 mode="M18">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = $cat-speech/tei:category[@xml:id = 'text.speech.sign']/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.speech.sign</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M18"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:term[@type='text.speech.sign.type']"
                 priority="1000"
                 mode="M18">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = $cat-speech//tei:category[@xml:id = 'text.speech.sign.type']/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.speech.sign.type</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M18"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M18"/>
   <xsl:template match="@*|node()" priority="-2" mode="M18">
      <xsl:apply-templates select="@*|*" mode="M18"/>
   </xsl:template>
   <!--PATTERN -->
   <xsl:variable name="cat-setting"
                 select="$keywords-file//tei:category[@xml:id = 'text.setting']"/>
   <!--RULE -->
   <xsl:template match="tei:term[@type='text.setting.continent']"
                 priority="1001"
                 mode="M19">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = $cat-setting/tei:category[@xml:id = 'text.setting.continent']/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.setting.continent</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M19"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:term[@type='text.setting.country']"
                 priority="1000"
                 mode="M19">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = $cat-setting/tei:category[@xml:id = 'text.setting.country']/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.setting.country</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M19"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M19"/>
   <xsl:template match="@*|node()" priority="-2" mode="M19">
      <xsl:apply-templates select="@*|*" mode="M19"/>
   </xsl:template>
   <!--PATTERN -->
   <xsl:variable name="cat-time"
                 select="$keywords-file//tei:category[@xml:id = 'text.time']"/>
   <!--RULE -->
   <xsl:template match="tei:term[@type='text.time.period.author']"
                 priority="1001"
                 mode="M20">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = $cat-time//tei:category[@xml:id = 'text.time.period.author']/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.time.period.author</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M20"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="tei:term[@typee='text.time.period.publication']"
                 priority="1000"
                 mode="M20">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = $cat-time//tei:category[@xml:id = 'text.time.period.publication']/tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.time.period.publication</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M20"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="@*|node()" priority="-2" mode="M20">
      <xsl:apply-templates select="@*|*" mode="M20"/>
   </xsl:template>
   <!--PATTERN -->
   <xsl:variable name="cat-prestige"
                 select="$keywords-file//tei:category[@xml:id = 'text.prestige']"/>
   <!--RULE -->
   <xsl:template match="tei:term[@type='text.prestige']" priority="1000" mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.) = $cat-prestige//tei:category/tei:catDesc"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$cligs-idno"/>
               <xsl:text/>
               <xsl:text>: Metadata error: text.prestige</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|*" mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:apply-templates select="@*|*" mode="M21"/>
   </xsl:template>
</xsl:stylesheet>
