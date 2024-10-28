# pymongo-api

## Схема архитектуры

Откройте в браузере: https://drive.google.com/file/d/1o3jy3-Go6fGkW14osD-MzV7hfNUW_Jzx/view?usp=share_link

## Как запустить

Запускаем mongodb (2 шарда по 3 реплики), кеш с редисом и приложение

```shell
docker compose up -d
```

Настраиваем шардирование, репликацию и наполняем БД данными:

```shell
chmod +x ./scripts/setup.sh
chmod +x ./scripts/count.sh
./scripts/setup.sh
```

## Как проверить

### Если вы запускаете проект на локальной машине

Откройте в браузере http://localhost:8080

### Проверьте число документов в базе данных

```shell
./scripts/count.sh
```

Узнать белый ip виртуальной машины

```shell
curl --silent http://ifconfig.me
```

Откройте в браузере http://localhost:8080

## Доступные эндпоинты

Список доступных эндпоинтов, swagger http://localhost:8080/docs

Остановить все запущенные контейнеры:

```shell
docker compose down
```