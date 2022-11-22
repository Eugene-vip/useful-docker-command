#Сделаем бэкап базы в контейнере докера и перенесем на хост

#Бэкап базы в контейнере
docker exec -it postgres pg_basebackup -U postgres --pgdata=/home/backup;

#Создаем папку под архив бекапов
mkdir -p /home/backup_archive/

#Заархивируем предыдущий бекап на хосте
tar cf /home/backup_archive/pg_backup_$( date '+%Y-%m-%d_%H-%M-%S' ).tar -P /home/backup/

#Скопируем бэкап с контейнера на хост
sudo docker cp postgres:/home/backup /home/backup

#Скопируем файлы бекапа в папку, который будет монтироваться в контейнере postgres
mkdir -p /home/pg_data/
sudo docker cp -rf /home/backup/* /home/p_data/
