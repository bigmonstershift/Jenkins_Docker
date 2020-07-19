# 要件定義
試験環境などで開発を行い一段落した成果物をGitHubにプッシュする際、Jenkinsが連動して自動で別のホストにデプロイが走る。  
俗に言うCI環境を自動構築するDockerfile。  

![flow](https://user-images.githubusercontent.com/53789788/87002293-401c5100-c1f4-11ea-9a35-16128e97c7f1.png)

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

秘密鍵格納
docker cp 【ローカルの秘密鍵】 【コンテナID】:/var/lib/jenkins/.ssh/private.pem
```
jenkins初期ログイン
```
http://【IP】:8080
```
![jenkins](https://user-images.githubusercontent.com/53789788/87879709-7b562580-ca27-11ea-972b-f6d66ed5a8d4.png)

# Jenkins設定
### APIトークン
「 Jenkinsの管理>ユーザーの管理>設定>APIトークン」でトークン作成。  
※トークン名とトークンIDを控えておく。
### CSRF無効化
「Jenkinsの管理>グローバルセキュリティの設定>CSRF Protection」でCSRF対策を無効化にする。
### GitHub連携用プラグイン
「Jenkinsの管理>プラグインの管理」で「Conditional BuildStep」をインストールする。
### ジョブ作成
#### General
|  項目  |  内容  |
| ---- | ---- |
|  ビルドのパラメータ化  |  タイプ　　　：文字列<br>名前　　　　：payload<br>デフォルト値：none  |
|  古いビルドの破棄  |  適当  |
#### ソースコード管理
なし
#### ビルド・トリガ
|  項目  |  内容  |
| ---- | ---- |
|  リモートからビルド  |  上で作成したトークン名  |
#### ビルド
|  項目  |  内容  |
| ---- | ---- |
|  ビルド手順の追加  |  Conditional step (single)  |
|  Run?  |  Regular expression match  |
|  Expression  |  .\*"ref":"refs\/heads\/master".\*  |
|  Label  |  ${ENV,var="payload"}  |
|  Builder  |  シェルの実行  |
#### シェルの内容
```
コンフィグシェルスクリプトの実行結果をコピペ
/bin/bash config.sh
cat jenkins-script
```
# GitHub設定
#### ペイロードURL
「Settings>Webhooks」で次のように設定する。
```
http://【jenkinsユーザ名】:【apiトークン】@【jenkinsホスト名】/job/【ジョブ名】/buildWithParameters?token=【apiトークン名】
```
