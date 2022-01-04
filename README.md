# Добавление нового сайта

Необходимо описать контейнер с примерной структурой

```yml
nginx:
  image: nginx:latest
  restart: always
  container_name: ${CONTAINER_NAME}.nginx
  environment:
    - VIRTUAL_HOST=${DOMAIN}
    - LETSENCRYPT_HOST=${DOMAIN}
    - LETSENCRYPT_EMAIL=${EMAIL_SSL}
  ...
```

Где:

- CONTAINER_NAME - уникальное имя проекта, можно использовать имя домена, например: ryzen.gg
- DOMAIN - имя домена, можно указывать несколько, например: www.ryzen.gg,ryzen.gg
- EMAIL_SSL - email для выпуска SSL.

При этом обазательно должны быть указаны environment:

- VIRTUAL_HOST
- LETSENCRYPT_HOST
- LETSENCRYPT_EMAIL


Для каждого нового VIRTUAL_HOST, nginx-proxy автоматически создает конфиг.
Если указан LETSENCRYPT_HOST, nginx-proxy-letsencrypt автоматически выпустит SSL сертификат.

Все новые проекты должны находится в одной сети network,
для этого указываем следующее:

```yml
networks:
  default:
    external:
      name: network
```

# Backup

В корне находится bash скрипт, который необходимо добавить в cron на удобное расписание.

Скрипт простой и смотрит в директории проекта, ищет Makefile и задачу backup в нем, если находит:
- выполняет: make backup
- копирует полученный архив в папку /backups

## Пример Makefile:

```Makefile
backup:
	docker-compose exec -T web python manage.py dumpdata > db.json
	tar -czf "site.$(shell date '+%Y-%m-%d').tar.gz" db.json ./media/*
  rm db.json
```


## @todo
- добавить проверку на tar.gz расширение
- добавить хранение указанного кол-ва копий архивов