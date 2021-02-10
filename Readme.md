## イメージの作成

```terminal
docker build -t ft_server .
```

## コンテナの起動

```terminal
docker run --name ft_server -p 80:80 -p 443:443 ft_server
```

## autoindex offで起動

```terminal
docker run --name ft_server -p 80:80 -p 443:443 -e AUTOINDEX=off ft_server
```

## コンテナの中に入る

```terminal
docker exec -it ft_server bash
```

## buildからrumまで一括で

```terminal
docker build -t ft_server . && docker run --name ft_server -p 80:80 -p 443:443 ft_server
```

## 全部消してリセット

```terminal
docker stop ft_server && docker rm ft_server && docker rmi ft_server
```
