# Corpus de novelas hispanoamericanas del siglo XIX (conha19)

This repository contains the corpus of novels accompanying the dissertation "Genre analysis and corpus design: 19th century Spanish American novels (1830-1910)" by Ulrike Henny-Krahmer. The corpus was prepared in the context of the junior research group ["Computational Literary Genres Stylistics" (CLiGS)](http://cligs.hypotheses.org), a project funded by the German Federal Ministry of Education and Research (BMBF).

The corpus contains 234 novels written by Argentine, Cuban, and Mexican authors or published in these countries. The novels were published for the first time between 1840 and 1910.

Some background information concerning the sources and preparation of the corpus is given in this README file. For further information see the reference publication indicated below.

## Schema ##
The TEI schemas for the basic and the linguistically annotated TEI files correspond to the general CLiGS schemas, which are available in the CLiGS [reference repository](https://github.com/cligs/reference).

The metadata keywords used in the text classification section of the TEI header are controlled by an external TEI keywords file and a schematron file, which are stored in the [schema](schema) folder of this repository.

## Related repositories
This repository is related to three other GitHub repositories:

* [Bib-ACMé: Bibliografía digital de novelas argentinas, cubanas y mexicanas (1830-1910)](https://github.com/cligs/bibacme)
* [scripts-nh](https://github.com/cligs/scripts-nh/)
* [data-nh](https://github.com/cligs/data-nh/)

__Bib-ACMé__ is a digital bibliography containing information about the novels published in Argentina, Cuba, and Mexico between 1830 and 1910. This bibliography constitutes the sampling frame for the corpus Conha19, so it aims to represent the whole population of 19th-century novels published in the three countries.

__scripts-nh__ contains XSLT- and Python scripts which were used for the creation, annotation, and documentation of the corpus and for the analysis of the novels in the corpus.

__data-nh__ holds research data that resulted from applying the scripts of scripts-nh to the corpus files.

## Rights and citation suggestions

The works contained in this public corpus are in the public domain. They are provided here with the [Public Domain Mark Declaration](https://creativecommons.org/publicdomain/mark/1.0/deed.de) and can be re-used without restrictions. The XML-TEI markup is also considered to be free of any copyright and is provided with the same declaration. If you use texts from this collection for your research or teaching, we kindly ask you to reference this repository using the citation suggestion below and/or cite the reference publication indicated below.

### Handling of works protected by copyright ###

According to the German copyright law, some of the works that are part of the full corpus accompanying the dissertation are still under general copyright because the authors died less than 70 years ago. Furthermore, some of the source editions used are protected by the ancillary copyright because they were published less than 25 years ago and copyright was claimed for them by the editors. The corpus files for these works will be added to the public corpus as soon as the copyright expires. This applies to 22 texts. A table summarizing information that is relevant for the copyright status of all the files in the corpus, including the ones that are not published in this repository yet, can be viewed [here](https://github.com/cligs/data-nh/blob/master/corpus/metadata_copyright.csv).

### Citation suggestion for the corpus ###

Corpus de novelas hispanoamericanas del siglo XIX (conha19), edited by Ulrike Henny-Krahmer. Version X.X.X, June 2020. Github.com. URL: https://github.com/cligs/conha19, DOI: XXX.

### Citation suggestion for the reference publication ###

Ulrike Henny-Krahmer (XXX). Genre analysis and corpus design: 19th century Spanish American novels (1830-1910). etc.


