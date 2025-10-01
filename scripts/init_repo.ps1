Param([string]$Repo='.',[string]$Remote='')
Set-Location $Repo
git init
git add .
 git commit -m 'Init: Safe Mode Expanded v3.1'
 git branch -M main
if($Remote){ git remote add origin $Remote; git push -u origin main }
