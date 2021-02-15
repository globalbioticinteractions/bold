#!/bin/bash
#
#

curl "http://bins.boldsystems.org/index.php/TaxBrowser_Home"\
| grep -o -E "taxid=[0-9]+"\
| cut -d '=' -f2\
> bold-taxids.tsv

cat bold-taxids.tsv\
| parallel curl "http://bins.boldsystems.org/index.php/API_Tax/TaxonData?taxId={1}\&dataTypes=basic"\
| tee taxa.json\
| jq --raw-output .taxon\
> bold-taxa.tsv

cat bold-taxa.tsv\
| awk '{ print "curl \"http://boldsystems.org/index.php/API_Public/specimen?format=tsv&taxon=" $1 "\" | gzip > bold-" $1 ".tsv.gz" }'\
> bold-requests.sh






