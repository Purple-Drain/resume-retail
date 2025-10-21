latexmk -pdf -halt-on-error -interaction=nonstopmode $MainTex, $JBTex, $RtlTex
if ($Docx) { pandoc -s $MainTex -o ($MainTex -replace '.tex$', '.docx'); pandoc -s $JBTex -o ($JBTex -replace '.tex$', '.docx'); pandoc -s $RtlTex -o ($RtlTex -replace '.tex$', '.docx') }
Write-Host 'Done. PDFs built. DOCX built: ' $Docx
