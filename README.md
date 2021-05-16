# Corpus de novelas hispanoamericanas del siglo XIX (conha19)

This repository contains the corpus of novels accompanying the dissertation "Genre Analysis and Corpus Design: 19th Century Spanish American Novels (1830-1910)" by Ulrike Henny-Krahmer. The corpus was prepared in the context of the junior research group ["Computational Literary Genres Stylistics" (CLiGS)](http://cligs.hypotheses.org), a project funded by the German Federal Ministry of Education and Research (BMBF) and realized at the University of Würzburg between 2015 and 2020.

The whole corpus consists of 256 novels written by Argentine, Cuban, and Mexican authors or published in the respective countries between 1830 and 1910. Of these novels, 234 are published here, as they are in the public domain.

Some background information concerning the sources and preparation of the corpus is given in this README file. For further information see the reference publication indicated below.

* [Overview of the novels in the corpus](#overview-of-the-novels-in-the-corpus)
* [Structure and contents of the repository](#structure-and-contents-of-the-repository)
* [Related repositories](#related-repositories)
* [Related publications](#related-publications)
* [Rights and citation suggestions](#rights-and-citation-suggestions)
  * [Handling of works protected by copyright](#handling-of-works-protected-by-copyright)
  * [Citation suggestions](#citation-suggestions)
* [Contact](#contact)

## Overview of the novels in the corpus ##

The overviews given here apply to all 256 novels (including the ones which still are under copyright). In total, the texts amount to 18.3 million tokens. There are 108 Mexican, 99 Argentine, and 49 Cuban novels. The following two figures show the distribution of novels per decade and subgenre, first for thematic subgenres and then for literary currents.

![Novels by decade and subgenre](https://github.com/cligs/conha19/blob/main/plots/bar_subgenres-by-decade_subgenre-theme.png)

![Novels by decade and current](https://github.com/cligs/conha19/blob/main/plots/bar_subgenres-by-decade_subgenre-current.png)

The novels were written by 121 different authors. Authors who are represented with 5 or more works
are listed below:

|author name                   |country  |number of novels in the corpus|
|------------------------------|---------|------------------------------|
|de Cuéllar, José Tomás        |Mexico   |                             9|
|Gutiérrez, Eduardo            |Argentina|                             9|
|Gamboa, Federico              |Mexico   |                             8|
|Ocantos, Carlos María         |Argentina|                             8|
|Gómez de Avellaneda, Gertrudis|Cuba     |                             7|
|Calcagno, Francisco           |Cuba     |                             6|
|Paz, Ireneo                   |Mexico   |                             6|
|Altamirano, Ignacio Manuel    |Mexico   |                             5|
|Ancona, Eligio                |Mexico   |                             5|
|Holmberg, Eduardo Ladislao    |Argentina|                             5|
|Sicardi, Francisco            |Argentina|                             5|
|Villaverde, Cirilo            |Cuba     |                             5|


## Structure and contents of the repository ##

In the following, the kind of data which is contained in this repository is listed. Three __main formats__ of the novels are included: TEI, plain text, and linguistically annotated files:

* [tei](tei): the TEI master files of the novels
* [txt](txt): plain text files, extracted from the TEI master files
* [annotated](annotated): linguistically annotated files (in TEI)


There is __additional material__ accompanying the novels' files:

* [metadata.csv](metadata.csv): basic metadata about the novels in tabular format, including for example the CLiGS identifiers, shortcuts for authors and titles, publication years, and information about the subgenres of the texts
* [schema](schema): a folder containing an external TEI keywords file and a schematron file, which serve to control the metadata keywords used in the text classification section of the TEI header. The TEI schemas for the basic and the linguistically annotated TEI files in turn are not given here because correspond to the general CLiGS schemas, which are available in the CLiGS [reference repository](https://github.com/cligs/reference)
* [bib/biblibography.xml](bib/bibliography.xml): bibliography file (in TEI), holding full bibliographic references of literary historical works cited in the corpus files
* [spellcheck](spellcheck): lists with exception words and results of the spell check in CSV format, for the whole corpus and per novel
* [travelogues](travelogues): three TEI files with travelogues which were not considered as novels for the corpus, but compared to them in the selection process
* [scripts](plots): scripts used to check, clean, or summarize corpus data
* [plots](plots): plots with summaries of corpus metadata


Besides, there are __further formats__ that were derived from the three main formats for specific analyses:

* [tei_ns](tei_ns): "tei no speech", subset of 92 files without direct speech mark-up (in TEI)
* [tei_ds](tei_ds): "tei direct speech", subset of 92 files with direct speech annotation based on a regular expression approach
* [tei_tokenized_ds](tei_tokenized_ds): subset of 92 files as tokenized text with two stand-off direct speech annotations (DS_gold: semi-automatically created gold standard, DS_reg: automatically created RegExp-based annotation), in TEI
* [annotated_corr](annotated_corr): linguistically annotated files (in TEI) with corrected POS annotation for verb forms with enclitic pronouns
* [txt_annotated](txt_annotated): plain text files, extracted from the corrected linguistically annotated TEI files (annotated_corr); named entities are replaced with the token ENTITY
* [txt_annotated_corr](txt_annotated_corr): plain text files derived from txt_annotated; converted to lower case; blank spaces that precede punctuation marks (comma, full stop, etc.) are removed
* [txt_annotated_nouns](txt_annotated_nouns): plain text files derived from the corrected linguistically annotated TEI files (annotated_corr); only nouns are kept
* [txt_annotated_stop](txt_annotated_stop): plain text files derived from txt_annotated_corr; stop words are removed


## Related repositories
This repository is related to three other GitHub repositories:

* [Bib-ACMé: Bibliografía digital de novelas argentinas, cubanas y mexicanas (1830-1910)](https://github.com/cligs/bibacme)
* [scripts-nh](https://github.com/cligs/scripts-nh/)
* [data-nh](https://github.com/cligs/data-nh/)

__Bib-ACMé__ is a digital bibliography containing information about the novels published in Argentina, Cuba, and Mexico between 1830 and 1910. This bibliography constitutes the sampling frame for the corpus Conha19, so it aims to represent the whole population of 19th-century novels published in the three countries.

__scripts-nh__ contains XSLT- and Python scripts which were used for the creation, annotation, and documentation of the corpus and for the analysis of the novels in the corpus.

__data-nh__ holds research data that resulted from applying the scripts of scripts-nh to the corpus files.


## Related publications

This corpus or parts of it have been described or used for analyses in the following publications:

Reference publication:

* Henny-Krahmer, Ulrike (forthcoming). _Genre Analysis and Corpus Design: 19th Century Spanish American Novels (1830-1910)_ (Doctoral dissertation, University of Würzburg, Germany).

Other publications:

* Calvo Tello, José, Ulrike Henny-Krahmer, and Christof Schöch (2018): "Textbox: análisis del léxico mediante corpus literarios". In _Historia del léxico español y Humanidades digitales._ Edited by Dolores Corbella, Alejandro Fajardo, and Jutta Langenbacher. Berlin: Peter Lang, 225-253. https://dialnet.unirioja.es/servlet/articulo?codigo=7081640.
* Calvo Tello, José, Daniel Schlör, Ulrike Henny-Krahmer, and Christof Schöch (2017): "Neutralising the Authorial Signal in Delta by Penalization: Stylometric Clustering of Genre in Spanish Novels". In _Digital Humanities 2017. Conference Abstracts._ Montréal: McGill University & Université de Montréal, 181-184. https://dh2017.adho.org/abstracts/037/037.pdf.
* Henny-Krahmer, Ulrike (forthcoming): "Family Resemblance in Genre Stylistics: A Case Study with 19th Century Spanish American Novels." In _Digital Stylistics in Romance Studies and Beyond_ Edited by Robert Hesselbach, José Calvo Tello, Ulrike Henny-Krahmer, Daniel Schlör, and Christof Schöch. Heidelberg: heiUP.
* ___ (forthcoming): "Time for Genre. Temporal Expressions as Features for the Classification of Literary Subgenres." _EADH2021. Book of Abstracts._
* ___ (2018): "Exploration of Sentiments and Genre in Spanish American Novels." In _Digital Humanities 2018. Puentes–Bridges. Book of Abstracts._ Ciudad de México: Red de Humanidades Digitales, 399-403. https://dh2018.adho.org/exploration-of-sentiments-and-genre-in-spanish-american-novels/.
* Henny-Krahmer, Ulrike, Katrin Betz, Daniel Schlör, and Andreas Hotho (2018): "Alternative Gattungstheorien. Das Prototypenmodell am Beispiel hispanoamerikanischer Romane." In _DHd 2018. Kritik der digitalen Vernunft. Konferenzabstracts._ Köln: Universität zu Köln, 105-112. http://doi.org/10.5281/zenodo.4622413.
* Schöch, Christof, José Calvo Tello, Ulrike Henny-Krahmer, and Stefanie Popp (2019): "The CLiGS textbox: Building and Using Collections of Literary Texts in Romance Languages Encoded in XML-TEI." _Journal of the Text Encoding Initiative_. https://journals.openedition.org/jtei/2085.
* Schöch, Christof, Ulrike Henny, José Calvo Tello, Daniel Schlör, and Stefanie Popp (2016): "Topic, Genre, Text. Topics im Textverlauf von Untergattungen des spanischen und hispanoamerikanischen Romans (1880-1930)." In _DHd 2016. Modellierung, Vernetzung, Visualisierung. Die Digital Humanities als fächerübergreifendes Forschungsparadigma. Konferenzabstracts._ Leipzig: Universität Leipzig, 235-239. http://doi.org/10.5281/zenodo.4645381.
* Zehe, Albin, Daniel Schlör, Ulrike Henny-Krahmer, Martin Becker, and Andreas Hotho (2018): "A White-Box Model for Detecting Author Nationality by Linguistic Differences in Spanish Novels." In _Digital Humanities 2018. Puentes–Bridges. Book of Abstracts._ Ciudad de México: Red de Humanidades Digitales, 519-522. https://dh2018.adho.org/a-white-box-model-for-detecting-author-nationality-by-linguistic-differences-in-spanish-novels/.


## Rights and citation suggestions

The works contained in this public corpus are in the public domain. They are provided here with the [Public Domain Mark Declaration](https://creativecommons.org/publicdomain/mark/1.0/deed.de) and can be re-used without restrictions. The XML-TEI markup is also considered to be free of any copyright and is provided with the same declaration. If you use texts from this collection for your research or teaching, we kindly ask you to reference this repository using the citation suggestion below and/or cite the reference publication indicated below.


### Handling of works protected by copyright ###

According to the German copyright law, some of the works that are part of the full corpus accompanying the dissertation are still under general copyright because the authors died less than 70 years ago. Furthermore, some of the source editions used are protected by the ancillary copyright because they were published less than 25 years ago and copyright was claimed for them by the editors. This applies to 22 texts.

The corpus files for these works will be added to the public corpus as soon as the copyright expires. A table summarizing information that is relevant for the copyright status of all the files in the corpus, including the ones that are not published in this repository yet, can be viewed [here](https://github.com/cligs/data-nh/blob/master/corpus/metadata_copyright.csv). The entire corpus has been archived on Zenodo (see http://doi.org/10.5281/zenodo.4447468) with restricted access.


### Citation suggestions ###

If you use this corpus, I kindly ask you to cite it either directly or by indicating the reference publication, as suggested below.

Citation suggestion for the corpus:

Henny-Krahmer, Ulrike (ed.) (2021). _Corpus de novelas hispanoamericanas del siglo XIX (conha19)_. Version 1.0.0. Github.com. URL: https://github.com/cligs/conha19.

Citation suggestion for the reference publication:

Henny-Krahmer, Ulrike (forthcoming). _Genre Analysis and Corpus Design: 19th Century Spanish American Novels (1830-1910)_ (Doctoral dissertation, University of Würzburg, Germany).


## Contact ##
If you have any comments or suggestions on the corpus or would like to contribute to it, please leave an issue or contact:

Ulrike Henny-Krahmer, ulrike.henny@web.de

