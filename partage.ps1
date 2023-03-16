New-Item -Name LOL -ItemType Directory -Path C:\Users\Administrateur\Documents 
New-Item -Name file.txt -ItemType file -Path C:\Users\Administrateur\Documents\LOL -Value "hello world"
New-SmbShare -Name shared -Path C:\Users\Administrateur\Documents\LOL -ReadAccess "Direction"

