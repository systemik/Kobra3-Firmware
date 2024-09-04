
rmdir /S /Q update_swu update
tar -cvzf setup.tar.gz update.sh openssh
mkdir update_swu
move setup.tar.gz update_swu
zip -P U2FsdGVkX19deTfqpXHZnB5GeyQ/dtlbHjkUnwgCi+w= -r update.swu update_swu
mkdir update
move update.swu update
