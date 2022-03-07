# /bin/bash

function get_next_version() {
   local x
   until [ "$x" != "" ]; do
     echo "Digite a próxima versão:"
     read x
   done
   export nextVersion="$x"
   echo "Proxíma versão: $nextVersion"
}

function main() {
   file=pubspec.yaml

   currVersion=`grep "version: " $file | sed "s/version: //1"`
   nextTag=`echo $currVersion | sed "s/-snapshot//1"`
   nextTag="$nextTag"

   echo "Versão corrente: $currVersion"
   echo "Tag a ser criada: $nextTag"

   get_next_version

   nextVersion=$nextVersion-snapshot
   echo "Próxima versão com sufixo: $nextVersion"

   sed -i "s/version: $currVersion/version: $nextTag/1" $file
   git add pubspec.yaml
   git commit -m "Commit da versão para a tag $nextTag"
   git push 
   git tag -a $nextTag -m 'Criação da tag $nextTag'
   git push origin $nextTag
   sed -i "s/version: $nextTag/version: $nextVersion/1" $file
   git add pubspec.yaml
   git commit -m "Segundo commit para a próxima versão $nextVersion"
   git push 
}

main
