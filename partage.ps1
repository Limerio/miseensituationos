New-Item -Name LOL -ItemType Directory -Path C:\ 
New-Item -Name file.txt -ItemType file -Path C:\LOL -Value "hello world"
New-SmbShare -Name shared -Path C:\LOL -ReadAccess "Direction"
