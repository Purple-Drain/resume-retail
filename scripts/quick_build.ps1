Param([switch]$NoDocx)
function Test-Command($n){try{Get-Command $n -ErrorAction Stop|Out-Null;$true}catch{$false}}
$HaveLatexmk=Test-Command 'latexmk';$HavePdfLaTeX=Test-Command 'pdflatex';$HavePandoc=Test-Command 'pandoc'
Write-Host '==> Building PDFs...'
foreach($f in $tex){ if($HaveLatexmk){latexmk -pdf -halt-on-error -interaction=nonstopmode $f} elseif($HavePdfLaTeX){pdflatex -interaction=nonstopmode -halt-on-error $f; pdflatex -interaction=nonstopmode -halt-on-error $f} else{Write-Error 'Missing latexmk/pdflatex'; exit 1}}
if(-not $NoDocx){ if($HavePandoc){ foreach($f in $tex){ pandoc -s $f -o ($f -replace '.tex$', '.docx') } } else{ Write-Warning 'Pandoc not found; skipping DOCX' } }
Write-Host '==> Done.'; Invoke-Item (Get-Location).Path
