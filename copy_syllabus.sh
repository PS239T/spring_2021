#!/bin/sh

# Run R markdown file
sudo Rscript -e "rmarkdown::render('_logistics/A_Syllabus.Rmd', output_format = 'html_document')"

echo "Compiled the R markdown file in HTML format"

sudo Rscript -e "rmarkdown::render('_logistics/A_Syllabus.Rmd', output_format = 'pdf_document')"

echo "Compiled the R markdown file in PDF format"

# Move the outptus to the project directory
cp _logistics/A_Syllabus.pdf .

echo "Copied the PDF version of the syllabus"

cp _logistics/A_Syllabus.html .

echo "Copied the HTML version of the syllabus"
