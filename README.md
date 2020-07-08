# 要件定義
試験環境などで開発を行い一段落した成果物をGitHubにプッシュする際、Jenkinsが連動して自動で別のホストにデプロイが走る。  
俗に言うCI環境を自動構築するDockerfile。  

![イメージ図](https://github.com/bigmonstershift/Jenkins_Docker/blob/master/flow.png)

# 手順
Dockerをインストール
```
yum -y install docker
systemctl start docker
```
コンテナ作成
```
docker build -t jenkins .
docker run -d --privileged -p 8080:8080 --name jenkins jenkins /sbin/init
docker exec -it jenkins cat /var/lib/jenkins/secrets/initialAdminPassword
```
jenkins初期ログイン
```
http://【IP】:8080
```

# Jenkins設定

# GitHub設定

