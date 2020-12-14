<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
    
    <sch:title>Schema controlling metadata and keywords for the corpus "Corpus de novelas hispanoamericanas
        del siglo XIX (conha19)"</sch:title>
    
    <sch:p>Author: Ulrike Henny-Krahmer</sch:p>
    
    <!-- How to validate the corpus against this schematron file (compiled as XSLT) from the command line:
    java -jar /home/ulrike/Programme/saxon/saxon9he.jar -s:/home/ulrike/Git/conha19/tei/ -o:/home/ulrike/Git/conha19/tei-checked/ -xsl:/home/ulrike/Git/conha19/schema/keywords-compiled.xsl 2> /home/ulrike/Git/conha19/schema/log-schematron.txt
    -->
    
    <sch:ns uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>
    <sch:ns uri="https://cligs.hypotheses.org/ns/cligs" prefix="cligs"/>
    
    <sch:let name="cligs-idno" value=".//tei:idno[@type='cligs']"/>
    <sch:let name="bibacme-work-id" value=".//tei:title[@type='idno']/tei:idno[@type='bibacme']"/>
    <sch:let name="bibliography" value="doc('../bib/bibliography.xml')"/>
    <sch:let name="keywords-file" value="document('keywords.xml')"/>
    <sch:let name="bibacme-authors" value="document('https://raw.githubusercontent.com/cligs/bibacme/master/app/data/authors.xml')"/>
    <sch:let name="bibacme-editions" value="document('https://raw.githubusercontent.com/cligs/bibacme/master/app/data/editions.xml')"/>
    
    <sch:pattern>
        <!-- General TEI header checks -->
        <sch:rule context="tei:titleStmt">
            <sch:assert test="tei:title[@type = 'main'][. != '']"><sch:value-of select="$cligs-idno"/>: TEI header error: Main title is missing.</sch:assert>
            <sch:assert test="tei:title[@type = 'sub'][. != '']"><sch:value-of select="$cligs-idno"/>: TEI header error: Subtitle is missing.</sch:assert>
            <sch:assert test="tei:title[@type = 'short'][. != '']"><sch:value-of select="$cligs-idno"/>: TEI header error: Short title is missing.</sch:assert>
            <sch:assert test="tei:title[@type = 'idno']/tei:idno[@type = 'viaf'][. != '']"><sch:value-of select="$cligs-idno"/>: TEI header error: title VIAF-ID is missing.</sch:assert>
            <sch:assert test="tei:title[@type = 'idno']/tei:idno[@type = 'bibacme'][. != '']"><sch:value-of select="$cligs-idno"/>: TEI header error: Bib-ACMé work ID is missing.</sch:assert>
            <sch:assert test="tei:title[@type = ('series','main','sub','short','idno')]"><sch:value-of select="$cligs-idno"/>: TEI header error: a title type "<sch:value-of select="@type"/>" is not supported.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:titleStmt/tei:author">
            <sch:assert test="tei:name[@type = 'full'][. != '']"><sch:value-of select="$cligs-idno"/>: TEI header error: full author name is missing.</sch:assert>
            <sch:assert test="tei:name[@type = 'short'][. != '']"><sch:value-of select="$cligs-idno"/>: TEI header error: short author name is missing.</sch:assert>
            <sch:assert test="tei:idno[@type = 'viaf'][. != '']"><sch:value-of select="$cligs-idno"/>: TEI header error: author VIAF ID is missing.</sch:assert>
            <sch:let name="author-id-bibacme" value="tei:idno[@type = 'bibacme']"/>
            <sch:assert test="$author-id-bibacme[. != '']"><sch:value-of select="$cligs-idno"/>: TEI header error: author Bib-ACMé work ID is missing.</sch:assert>
            <sch:let name="author-surname" value="tei:name[@type='full']/substring-before(.,',')"/>
            <sch:assert test="$bibacme-authors//tei:person[@xml:id=$author-id-bibacme]//tei:surname[.=$author-surname]"><sch:value-of select="$cligs-idno"/>: TEI header error: the author surname does not correspond to the one in Bib-ACMé.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:titleStmt/tei:principal">
            <sch:assert test="@xml:id[. = 'uhk']"><sch:value-of select="$cligs-idno"/>: TEI header error: principal ID should be 'uhk'.</sch:assert>
            <sch:assert test=". = 'Ulrike Henny-Krahmer'"><sch:value-of select="$cligs-idno"/>: TEI header error: principal should be 'Ulrike Henny-Krahmer'.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:extent/tei:measure[@unit = 'words']">
            <sch:assert test=". != ''"><sch:value-of select="$cligs-idno"/>: TEI header error: word count is missing.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:publicationStmt">
            <sch:assert test="tei:publisher/tei:ref[. = 'CLiGS']"><sch:value-of select="$cligs-idno"/>: TEI header error: publisher is missing.</sch:assert>
            <sch:assert test="tei:publisher/tei:ref[@target = 'http://cligs.hypotheses.org/']"><sch:value-of select="$cligs-idno"/>: TEI header error: link to publisher is missing.</sch:assert>
            <sch:assert test="tei:availability[@status]"><sch:value-of select="$cligs-idno"/>: TEI header error: availability status is missing.</sch:assert>
            <sch:assert test="tei:date[. = '2020']"><sch:value-of select="$cligs-idno"/>: TEI header error: publication date is wrong.</sch:assert>
            <sch:assert test="tei:idno[@type = 'cligs'][. != '']"><sch:value-of select="$cligs-idno"/>: TEI header error: CLiGS ID is missing.</sch:assert>
            <sch:assert test="tei:idno[@type = 'url']"><sch:value-of select="$cligs-idno"/>: TEI header error: URL ID is missing.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:sourceDesc">
            <sch:assert test="tei:bibl[@type = 'digital-source'][. != '']"><sch:value-of select="$cligs-idno"/>: TEI header error: digital source is missing.</sch:assert>
            <sch:assert test="tei:bibl[@type = 'print-source'][. != '']"><sch:value-of select="$cligs-idno"/>: TEI header error: print source is missing.</sch:assert>
            <sch:assert test="tei:bibl[@type = 'edition-first'][. != '']"><sch:value-of select="$cligs-idno"/>: TEI header error: first edition is missing.</sch:assert>
            <sch:let name="work-editions" value="$bibacme-editions//tei:biblStruct[substring-after(@corresp,'#')=$bibacme-work-id]"/>
            <sch:let name="edition-years" value="$work-editions[.//tei:date/(@when|@to)]//tei:date/substring(@when|@to,1,4)"/>
            <sch:let name="year-edition-first-bibacme" value="min(for $i in $edition-years return xs:integer($i))"/>
            <sch:let name="year-edition-first-conha19" value="tei:bibl[@type = 'edition-first']/tei:date/xs:integer(@when)"/>
            <sch:assert test="$year-edition-first-conha19 = $year-edition-first-bibacme"><sch:value-of select="$cligs-idno"/>: TEI header error: the year of the first edition in Conha19 (<sch:value-of select="$year-edition-first-conha19"/>) does not correspond to the year in Bib-ACMé (<sch:value-of select="$year-edition-first-bibacme"/>).</sch:assert>
        </sch:rule>
        <sch:rule context="tei:encodingDesc">
            <sch:assert test="tei:p[. != '']"><sch:value-of select="$cligs-idno"/>: TEI header error: encoding description is missing.</sch:assert>
        </sch:rule>
        <sch:rule context="tei:abstract">
            <sch:assert test="@source[. != '']"><sch:value-of select="$cligs-idno"/>: TEI header error: abstract source is missing.</sch:assert>
        </sch:rule>
    </sch:pattern>
        
    <!-- Keyword checks -->
    <sch:pattern>
        <sch:rule context="tei:term">
            <!-- check keyword types -->
            <!-- types of keywords that are allowed -->
            <sch:let name="keyword-types-allowed" value="('author.continent','author.country','author.country.birth','author.country.death','author.country.nationality','author.gender',
                'text.source.medium','text.source.filetype','text.source.institution','text.source.edition',
                'text.publication.first.country','text.publication.first.medium','text.publication.first.type','text.publication.type.independent',
                'text.language','text.form','text.genre.supergenre','text.genre','text.title',
                'text.genre.subgenre.title.explicit','text.genre.subgenre.title.implicit',
                'text.genre.subgenre.paratext.explicit','text.genre.subgenre.paratext.implicit',
                'text.genre.subgenre.opening.implicit', 'text.genre.subgenre.contemp.explicit',
                'text.genre.subgenre.historical.explicit','text.genre.subgenre.historical.explicit.norm','text.genre.subgenre.historical.implicit',
                'text.genre.subgenre.litHist','text.genre.subgenre.litHist.interp',
                'text.genre.subgenre.summary.signal.explicit','text.genre.subgenre.summary.signal.implicit',
                'text.genre.subgenre.summary.theme.explicit','text.genre.subgenre.summary.theme.implicit','text.genre.subgenre.summary.theme.litHist',
                'text.genre.subgenre.summary.identity.explicit','text.genre.subgenre.summary.identity.implicit','text.genre.subgenre.summary.identity.litHist',
                'text.genre.subgenre.summary.current.explicit','text.genre.subgenre.summary.current.implicit','text.genre.subgenre.summary.current.litHist',
                'text.genre.subgenre.summary.mode.attitude.explicit','text.genre.subgenre.summary.mode.attitude.implicit','text.genre.subgenre.summary.mode.attitude.litHist',
                'text.genre.subgenre.summary.mode.intention.explicit','text.genre.subgenre.summary.mode.intention.implicit','text.genre.subgenre.summary.mode.intention.litHist',
                'text.genre.subgenre.summary.mode.reality.explicit','text.genre.subgenre.summary.mode.reality.implicit','text.genre.subgenre.summary.mode.reality.litHist',
                'text.genre.subgenre.summary.mode.medium.explicit','text.genre.subgenre.summary.mode.medium.implicit','text.genre.subgenre.summary.mode.medium.litHist',
                'text.genre.subgenre.summary.mode.representation.explicit','text.genre.subgenre.summary.mode.representation.implicit','text.genre.subgenre.summary.mode.representation.litHist',
                'text.narration.narrator', 'text.narration.narrator.person','text.speech.sign','text.speech.sign.type','text.setting.continent','text.setting.country',
                'text.time.period','text.time.period.author','text.time.period.publication','text.prestige')"/>
            <!-- keyword types that should occur only once -->
            <sch:let name="keyword-types-once" value="('author.continent','author.country','author.country.birth','author.country.death','author.country.nationality','author.gender',
                'text.source.medium','text.source.filetype','text.source.edition',
                'text.publication.first.country','text.publication.first.medium','text.publication.first.type','text.publication.type.independent',
                'text.language','text.form','text.genre.supergenre','text.genre',
                'text.narration.narrator', 'text.narration.narrator.person','text.speech.sign','text.speech.sign.type','text.setting.continent','text.setting.country',
                'text.time.period','text.time.period.author','text.time.period.publication','text.prestige')"/>
            
            <sch:assert test="@type = $keyword-types-allowed"><sch:value-of select="$cligs-idno"/>: Keyword error: the keyword type <sch:value-of select="@type"/> is not supported.</sch:assert>
            <sch:let name="kw-type" value="@type"/>
            <sch:report test="@type = $keyword-types-once and preceding-sibling::tei:term[@type=$kw-type]"><sch:value-of select="$cligs-idno"/>: Keyword error: the keyword <sch:value-of select="@type"/> should only occur once but does several times.</sch:report>
        </sch:rule>
        
        <sch:rule context="tei:keywords">
            <!-- check if obligatory keywords are present -->
            <!-- author -->
            <sch:assert test="tei:term[@type='author.continent'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: author.continent is missing.</sch:assert>
            <sch:assert test="tei:term[@type='author.country'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: author.country is missing.</sch:assert>
            <sch:assert test="tei:term[@type='author.country.birth'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: author.country.birth is missing.</sch:assert>
            <sch:assert test="tei:term[@type='author.country.death'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: author.country.death is missing.</sch:assert>
            <sch:assert test="tei:term[@type='author.country.nationality'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: author.country.nationality is missing.</sch:assert>
            <sch:assert test="tei:term[@type='author.gender'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: author.gender is missing.</sch:assert>
            <!-- text, source -->
            <sch:assert test="tei:term[@type='text.source.medium'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.source.medium is missing.</sch:assert>
            <sch:assert test="tei:term[@type='text.source.filetype'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.source.filetype is missing.</sch:assert>
            <sch:assert test="tei:term[@type='text.source.institution'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.source.institution is missing.</sch:assert>
            <sch:assert test="tei:term[@type='text.source.edition'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.source.edition is missing.</sch:assert>
            <!-- text, publication -->
            <sch:assert test="tei:term[@type='text.publication.first.country'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.publication.first.country is missing.</sch:assert>
            <sch:assert test="tei:term[@type='text.publication.first.medium'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.publication.first.medium is missing.</sch:assert>
            <sch:assert test="tei:term[@type='text.publication.first.type'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.publication.first.type is missing.</sch:assert>
            <sch:assert test="tei:term[@type='text.publication.type.independent'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.publication.type.independent is missing.</sch:assert>
            <!-- text, language -->
            <sch:assert test="tei:term[@type='text.language'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.language is missing.</sch:assert>
            <!-- text, form -->
            <sch:assert test="tei:term[@type='text.form'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.form is missing.</sch:assert>
            <!-- genre -->
            <sch:assert test="tei:term[@type='text.genre.supergenre'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.genre.supergenre is missing.</sch:assert>
            <sch:assert test="tei:term[@type='text.genre'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.genre is missing.</sch:assert>
            <!-- text title -->
            <sch:assert test="tei:term[@type='text.title'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.title is missing.</sch:assert>
            <!-- subgenre -->
            <sch:assert test="tei:term[@type='text.genre.subgenre.title.explicit'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.genre.subgenre.title.explicit is missing.</sch:assert>
            <sch:assert test="tei:term[@type='text.genre.subgenre.title.implicit'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.genre.subgenre.title.implicit is missing.</sch:assert>
            <sch:assert test="tei:term[@type='text.genre.subgenre.paratext.explicit'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.genre.subgenre.paratext.explicit is missing.</sch:assert>
            <sch:assert test="tei:term[@type='text.genre.subgenre.paratext.implicit'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.genre.subgenre.paratext.implicit is missing.</sch:assert>
            <sch:assert test="tei:term[@type='text.genre.subgenre.historical.explicit'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.genre.subgenre.historical.explicit is missing.</sch:assert>
            <sch:assert test="tei:term[@type='text.genre.subgenre.historical.explicit.norm'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.genre.subgenre.historical.explicit.norm is missing.</sch:assert>
            <sch:assert test="tei:term[@type='text.genre.subgenre.historical.implicit'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.genre.subgenre.historical.implicit is missing.</sch:assert>
            <!-- narrator -->
            <sch:assert test="tei:term[@type='text.narration.narrator'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.narration.narrator is missing.</sch:assert>
            <sch:assert test="tei:term[@type='text.narration.narrator.person'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.narration.narrator.person is missing.</sch:assert>
            <!-- speech sign -->
            <sch:assert test="tei:term[@type='text.speech.sign'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.speech.sign is missing.</sch:assert>
            <sch:assert test="tei:term[@type='text.speech.sign.type'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.speech.sign.type is missing.</sch:assert>
            <!-- setting -->
            <sch:assert test="tei:term[@type='text.setting.continent'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.setting.continent is missing.</sch:assert>
            <sch:assert test="tei:term[@type='text.setting.country'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.setting.country is missing.</sch:assert>
            <!-- time -->
            <sch:assert test="tei:term[@type='text.time.period'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.time.period is missing.</sch:assert>
            <sch:assert test="tei:term[@type='text.time.period.author'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.time.period.author is missing.</sch:assert>
            <sch:assert test="tei:term[@type='text.time.period.publication'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.time.period.publication is missing.</sch:assert>
            <!-- prestige -->
            <sch:assert test="tei:term[@type='text.prestige'][. != '']"><sch:value-of select="$cligs-idno"/>: Metadata error: text.prestige is missing.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- check keyword values and attributes -->
    <sch:pattern>
        <!-- author -->
        <sch:let name="cat-author" value="$keywords-file//tei:category[@xml:id = 'author']"/>
        <sch:rule context="tei:term[@type='author.continent']">
            <sch:assert test=". = $cat-author/tei:category[@xml:id = 'author.continent']/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: author.continent</sch:assert>
        </sch:rule>
        <sch:rule context="tei:term[@type='author.country']">
            <sch:assert test=". = $cat-author/tei:category[@xml:id = 'author.country']/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: author.country</sch:assert>
        </sch:rule>
        <sch:rule context="tei:term[@type='author.country.birth']">
            <sch:assert test=". = $cat-author//tei:category[@xml:id = 'author.country.birth']/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: author.country.birth</sch:assert>
        </sch:rule>
        <sch:rule context="tei:term[@type='author.country.death']">
            <sch:assert test=". = $cat-author//tei:category[@xml:id = 'author.country.death']/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: author.country.death</sch:assert>
        </sch:rule>
        <sch:rule context="tei:term[@type='author.country.nationality']">
            <sch:assert test=". = $cat-author//tei:category[@xml:id = 'author.country.nationality']/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: author.country.nationality</sch:assert>
        </sch:rule>
        <sch:rule context="tei:term[@type='author.gender']">
            <sch:assert test=". = $cat-author/tei:category[@xml:id = 'author.gender']/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: author.gender</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <!-- text, source -->
        <sch:let name="cat-source" value="$keywords-file//tei:category[@xml:id = 'text.source']"/>
        <sch:rule context="tei:term[@type='text.source.medium']">
            <sch:assert test="normalize-space(.) = $cat-source/tei:category[@xml:id = 'text.source.medium']/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: text.source.medium</sch:assert>
        </sch:rule>
        <sch:rule context="tei:term[@type='text.source.filetype']">
            <sch:assert test="normalize-space(.) = $cat-source/tei:category[@xml:id = 'text.source.filetype']/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: text.source.filetype</sch:assert>
        </sch:rule>
        <sch:rule context="tei:term[@type='text.source.institution']">
            <!-- institution may occur several times -->
            <sch:assert test="normalize-space(.) = $cat-source/tei:category[@xml:id = 'text.source.institution']/tei:category/tei:catDesc/normalize-space(.)"><sch:value-of select="$cligs-idno"/>: Metadata error: text.source.institution</sch:assert>
            <sch:assert test="if (preceding-sibling::tei:term[@type='text.source.institution']) then parent::tei:keywords/tei:term[@type='text.source.institution'][@cligs:importance='2'] else true()"><sch:value-of select="$cligs-idno"/>: Metadata error: if text.source.institution occurs several times, @cligs:importance is needed to prioritize</sch:assert>
        </sch:rule>
        <sch:rule context="tei:term[@type='text.source.edition']">
            <sch:assert test="normalize-space(.) = $cat-source/tei:category[@xml:id = 'text.source.edition']/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: text.source.edition</sch:assert>
        </sch:rule>
     </sch:pattern>
    
    
     <sch:pattern>
         <!-- text, publication -->
         <sch:let name="cat-publication" value="$keywords-file//tei:category[@xml:id = 'text.publication']"/>
         <sch:rule context="tei:term[@type='text.publication.first.country']">
             <sch:assert test="normalize-space(.) = $cat-publication//tei:category[@xml:id = 'text.publication.first.country']/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: text.publication.first.country</sch:assert>
         </sch:rule>
         <sch:rule context="tei:term[@type='text.publication.first.medium']">
             <sch:assert test="normalize-space(.) = $cat-publication//tei:category[@xml:id = 'text.publication.first.medium']/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: text.publication.first.medium</sch:assert>
         </sch:rule>
         <sch:rule context="tei:term[@type='text.publication.first.type']">
             <sch:assert test="normalize-space(.) = $cat-publication//tei:category[@xml:id = 'text.publication.first.type']/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: text.publication.first.type</sch:assert>
         </sch:rule>
         <sch:rule context="tei:term[@type='text.publication.type.independent']">
             <sch:assert test="normalize-space(.) = $cat-publication//tei:category[@xml:id = 'text.publication.type.independent']/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: text.publication.type.independent</sch:assert>
         </sch:rule>
     </sch:pattern>
            
     <sch:pattern>
         <!-- text, language -->
         <sch:let name="cat-language" value="$keywords-file//tei:category[@xml:id = 'text.language']"/>
         <sch:rule context="tei:term[@type='text.language']">
             <sch:assert test=". = $cat-language/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: text.language</sch:assert>
         </sch:rule>
         <!-- text, form -->
         <sch:let name="cat-form" value="$keywords-file//tei:category[@xml:id = 'text.form']"/>
         <sch:rule context="tei:term[@type='text.form']">
             <sch:assert test=". = $cat-form/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: text.form</sch:assert>
         </sch:rule>
         <!-- genre -->
         <sch:let name="cat-genre" value="$keywords-file//tei:category[@xml:id = 'text.genre']"/>
         <sch:rule context="tei:term[@type='text.genre.supergenre']">
             <sch:assert test=". = $cat-genre/tei:category[@xml:id = 'text.genre.supergenre']/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: text.supergenre</sch:assert>
         </sch:rule>
         <sch:rule context="tei:term[@type='text.genre']">
             <sch:assert test=". = $cat-genre/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: text.genre</sch:assert>
         </sch:rule>
     </sch:pattern>     
             
     <sch:pattern>
         <!-- subgenre -->
         <sch:let name="cat-subgenre" value="$keywords-file//tei:category[@xml:id = 'text.genre.subgenre']"/>
         <sch:rule context="tei:term[@type='text.genre.subgenre.historical.explicit.norm']">
             <!-- a list of values occuring in historical.explicit.norm is curated in keywords.xml -->
             <sch:assert test="normalize-space(.) = $cat-subgenre//tei:category[@xml:id = 'text.genre.subgenre.historical.explicit.norm']/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: the value "<sch:value-of select="normalize-space(.)"/>" is not documented for text.genre.subgenre.historical.explicit.norm in the keywords file yet.</sch:assert>
         </sch:rule>
         <sch:rule context="tei:term[@type='text.genre.subgenre.historical.implicit']">
             <!-- a list of values occuring in historical.implicit is curated in keywords.xml -->
             <sch:assert test="normalize-space(.) = $cat-subgenre//tei:category[@xml:id = 'text.genre.subgenre.historical.implicit']/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: the value "<sch:value-of select="normalize-space(.)"/>" is not documented for text.genre.subgenre.historical.implicit in the keywords file yet.</sch:assert>
         </sch:rule>
         <!-- text.genre.litHist and text.genre.litHist.interp are optional, but if they occur, 
                the sources indicated in litHist@resp should be part of the bibliography file
                and the values in listHist.interp should comply with the list curated in keywords.xml -->
         <sch:rule context="tei:term[@type='text.genre.subgenre.litHist']">
             <sch:assert test="@resp[substring-after(.,'#') = $bibliography//tei:bibl/@xml:id]"><sch:value-of select="$cligs-idno"/>: Metadata error: "<sch:value-of select="@resp"/>" is missing in the bibliography.</sch:assert>
         </sch:rule>
         <sch:rule context="tei:term[@type='text.genre.subgenre.litHist.interp']">
             <sch:assert test="normalize-space(.) = $cat-subgenre//tei:category[@xml:id = 'text.genre.subgenre.litHist.interp']/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: the value "<sch:value-of select="normalize-space(.)"/>" is not documented for text.genre.subgenre.litHist.interp in the keywords file yet.</sch:assert>
         </sch:rule>
     </sch:pattern>
            
     <sch:pattern>
         <!-- narration -->
         <sch:let name="cat-narration" value="$keywords-file//tei:category[@xml:id = 'text.narration']"/>
         <sch:rule context="tei:term[@type='text.narration.narrator']">
             <sch:assert test="normalize-space(.) = $cat-narration/tei:category[@xml:id = 'text.narration.narrator']/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: text.narration.narrator</sch:assert>
         </sch:rule>
         <sch:rule context="tei:term[@type='text.narration.narrator.person']">
             <sch:assert test="normalize-space(.) = $cat-narration//tei:category[@xml:id = 'text.narration.narrator.person']/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: text.narration.narrator.person</sch:assert>
         </sch:rule>
     </sch:pattern>
    
     <sch:pattern>
         <!-- speech -->
         <sch:let name="cat-speech" value="$keywords-file//tei:category[@xml:id = 'text.speech']"/>
         <sch:rule context="tei:term[@type='text.speech.sign']">
             <sch:assert test="normalize-space(.) = $cat-speech/tei:category[@xml:id = 'text.speech.sign']/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: text.speech.sign</sch:assert>
         </sch:rule>
         <sch:rule context="tei:term[@type='text.speech.sign.type']">
             <sch:assert test="normalize-space(.) = $cat-speech//tei:category[@xml:id = 'text.speech.sign.type']/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: text.speech.sign.type</sch:assert>
         </sch:rule>
     </sch:pattern>
            
     <sch:pattern>
         <!-- setting -->
         <sch:let name="cat-setting" value="$keywords-file//tei:category[@xml:id = 'text.setting']"/>
         <sch:rule context="tei:term[@type='text.setting.continent']">
             <sch:assert test="normalize-space(.) = $cat-setting/tei:category[@xml:id = 'text.setting.continent']/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: text.setting.continent</sch:assert>
         </sch:rule>
         <sch:rule context="tei:term[@type='text.setting.country']">
             <sch:assert test="normalize-space(.) = $cat-setting/tei:category[@xml:id = 'text.setting.country']/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: text.setting.country</sch:assert>
         </sch:rule>
     </sch:pattern>       
     
     <sch:pattern>
         <!-- time -->
         <sch:let name="cat-time" value="$keywords-file//tei:category[@xml:id = 'text.time']"/>
         <sch:rule context="tei:term[@type='text.time.period.author']">
             <sch:assert test="normalize-space(.) = $cat-time//tei:category[@xml:id = 'text.time.period.author']/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: text.time.period.author</sch:assert>
         </sch:rule>
         <sch:rule context="tei:term[@typee='text.time.period.publication']">
             <sch:assert test="normalize-space(.) = $cat-time//tei:category[@xml:id = 'text.time.period.publication']/tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: text.time.period.publication</sch:assert>
         </sch:rule>
     </sch:pattern>   
     
    <sch:pattern>
        <!-- prestige -->
        <sch:let name="cat-prestige" value="$keywords-file//tei:category[@xml:id = 'text.prestige']"/>
        <sch:rule context="tei:term[@type='text.prestige']">
            <sch:assert test="normalize-space(.) = $cat-prestige//tei:category/tei:catDesc"><sch:value-of select="$cligs-idno"/>: Metadata error: text.prestige</sch:assert>
        </sch:rule>
    </sch:pattern>
            
</sch:schema>
