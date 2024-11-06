@echo off
echo "Clean previous version" >&2 
rmdir /S /Q update_swu aGVscF9zb3Nf
echo "Ensure scriptws are in unix format"
dos2unix.exe .\cfw\scripts\*
dos2unix.exe update.sh
echo "Create tar.gz and password zip it" >&2 
tar -cvzf setup.tar.gz update.sh cfw
mkdir update_swu
move setup.tar.gz update_swu
zip -P U2FsdGVkX19deTfqpXHZnB5GeyQ/dtlbHjkUnwgCi+w= -r update.swu update_swu
echo "Create destination folder and move firmware update file in it" >&2 
mkdir aGVscF9zb3Nf
move update.swu aGVscF9zb3Nf
echo "New file ready in directory aGVscF9zb3Nf" >&2 
echo "Use at your own risks" >&2 
