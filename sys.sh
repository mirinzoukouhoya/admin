#!/bin/bash

function pause(){
 echo "appuyez su une touche pour continuer"
 read
}

function liste_users(){
 ### on détermine d'abord la liste des différents utilisateurs enregistrés sachant qu'ils ont un dossier personnel à leur nom dans /home/
 cat /etc/passwd | cut -d ":" -f1 > users.txt
 cat users.txt | while read ligne
 do
  ls /home/ | grep $ligne > users.txt
 done
 echo "la liste des utilisateurs est : "
 while read ligne
 do
  echo "- $ligne"
 done < users.txt
 ##### ici il doit être question de filtrer les utilisateurs des 03 derniers jours
 pause
}

function infoRessouurces(){
 vmstat
 pause
}

function addXamp(){
 sudo /opt/lampp/lampp start 2> errtest ;
 if [ $? -ne 0 ]; then
  wget https://www.apachefriends.org/xampp-files/7.0.18/xampp-osx-7.0.18-0-installer.dmg;
  sudo chmod 755 xampp-linux-*-installer.run;
  sudo ./xampp-linux-*-installer.run;
  sudo /opt/lampp/lampp start 2> errtest;
 fi
 pause
}

function sauvegarde(){
 read -p "entrer le chemin du périphérique externe : " path
 user=$(cat /etc/group | grep sudo | cut -d ":" -f4)
 sudo find /home/$user/* -ctime 2 > fichiers.txt #on stocke tout les fichiers modifiés il y a deux jours dans le fichier fichiers.txt
 mkdir archive
 cat fichiers.txt | while read ligne
 do
  mv $ligne archive
 done
 tar -cvs archive.tar archive/
 gzip archive.tar	
 cp archive.tar.gz $path
 ##cat fichiers.txt | while read ligne
 ##do
 ## cp $ligne $path
 ##done
 ##if [ $? -eq 0 ]; then
 ## echo " success lors de la copie"
 ##fi
 ##if [ $? -ne 0 ]; then
 ##echo " erreur lors de la copie"
 ##fi
 pause
}

rep=1

while [ "$rep" -eq 1 ];
do
 clear
 echo "______________________________________________________________________________________________"
 echo "/                                                                                            /"
 echo "/                              BIENVENU DANS MON PROJET SYS                                  /"
 echo "/____________________________________________________________________________________________/"
 echo "/                                                                                            /"
 echo "/ a- Informations des utilisateurs enregistré il y'a trois (03) jours                        /"
 echo "/ b- Aquisition, Installation et Lancement de l'environnement XAMPP                          /"
 echo "/ c- Archivage des éléments du repertoire personnel qui ont été modifier par l'utilisateur   /" 
 echo "/    sudoer il y'a deux jours dans le peripherique externe                                   /"
 echo "/ d- Information sur l'utilisation du disque, de la mémoire, du processeur et du swap        /"
 echo "/ q- Quitter !!!                                                                             /"
 echo "/____________________________________________________________________________________________/"
 echo "/                                                                                            /"
 echo "/                     FAIT PAR MIRINZOUKOUHOYA NAASSON 16B765FS                              /"
 echo "/____________________________________________________________________________________________/"
 
 read -p "votre choix : " reponse
 
 case "$reponse" in 
  a) liste_users;; 
            
  b) addXamp;;

  c) sauvegarde;;
		
  d) infoRessouurces;;

  q) rep=0;;
 
 esac

done

exit
