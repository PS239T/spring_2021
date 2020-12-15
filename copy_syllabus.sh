#!/bin/sh

# Run R markdown file
Rscript -e "rmarkdown::render('_logistics/A_Syllabus.Rmd')"

echo "Compiled the R markdown file"

# Move the outptus to the project directory
cp _logistics/A_Syllabus.pdf .
cp _logistics/A_Syllabus.html .

echo "Copied syllabus"
