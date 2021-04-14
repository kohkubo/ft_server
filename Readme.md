## イメージの作成

```terminal
docker build -t ft_server .
```

## コンテナの起動

```terminal
docker run --name ft_server -p 8080:80 -p 443:443 ft_server
```

## autoindex offで起動

```terminal
docker run --name ft_server -p 8080:80 -p 443:443 -e AUTOINDEX=off ft_server
```

## コンテナの中に入る

```terminal
docker exec -it ft_server bash
```

## コンテナの中でどのServiceが起動しているか調べる

```terminal
service --status-all
```

## phpmyaddminのパスワード

```terminal
user@localhost
password
```

## ログを表示する

```terminal
docker logs -f ft_server
```

## ポートの仕様状況をを調べる

```terminal
netstat -antu
```

## 停止しているコンテナを一括消去

```terminal
docker container prune
```

## ローカルのnginxをstopする

```terminal
service nginx stop
```

## buildからrunまで一括で

```terminal
docker build -t ft_server . && docker run --name ft_server -p 80:80 -p 443:443 ft_server
```

## 全部消してリセット

```terminal
docker stop ft_server && docker rm ft_server && docker rmi ft_server
```

## VMでレビュー前にまずやってほしいこと

```terminal
# ローカルのnginxを落とす
service nginx stop

ストップしてから一括消去コマンド
docker container prune

停止したコンテナと未使用のすべてのイメージを削除
docker system prune -a
```

[Dockerのイメージ、コンテナおよびボリュームを削除する方法 | DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes-ja)

## その他 Tips

```
# requestヘッダでホスト情報を書き換えて送信する
$ curl -H 'Host:example.com.' http://localhost:8080
```
