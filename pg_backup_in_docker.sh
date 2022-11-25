#!/bin/bash
#Сделаем бэкап базы в контейнере докера и перенесем на хост

#Проверим наличие контейнера и его статус
output=$( docker inspect --format="{{.State.Running}}" postgres )
if [ $output == "true" ];
then
  #Очистим предыдущий бекап
  docker exec -it postgres rm -rf /home/backup

  #Бэкап базы в контейнере
  docker exec -it postgres pg_basebackup -U postgres --pgdata=/home/backup;
fi

#Создаем папку под архив бекапов
mkdir -p /home/backup_archive/

#Заархивируем предыдущий бекап на хосте
tar cf /home/backup_archive/pg_backup_$( date '+%Y-%m-%d_%H-%M-%S' ).tar -P /home/backup/

if [ $output == "true" ];
then
  #Скопируем бэкап с контейнера на хост
  docker cp postgres:/home/backup /home/backup
fi

#поменяем владельца
chown -R root:root /home/backup

#На всякий случай удлаим backup_label
rm -rf /home/backup/backup_label

#Создадим папку для монтирования базы
mkdir -p /home/pg_data/

#Скопируем файлы бекапа в папку, который будет монтироваться в контейнере postgres
cp -rf /home/backup/* /home/p_data/
