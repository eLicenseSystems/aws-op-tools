aws-op-tools
============

aws-op-tools are tiny tools to manage AWS services.

aws-op-toolsは、AWSの各サービスを管理するために使うツール群です。


## インストール (Installation)

1. Download zip file from following url.
    - https://github.com/eLicenseSystems/aws-op-tools
1. Fire ```bundle install```.

<!-- dummy comment to break list -->

1. 以下のページからzipファイルをダウンロードします。
    - https://github.com/eLicenseSystems/aws-op-tools
1. ```bundle install```でインストール。


## 利用方法 (How to use)

### 基本 (General)

First of all, copy ```config/config.yml-sample``` and create your own ```config/config.yml```.

利用の前に、```config/config.yml-sample```をコピーした設定ファイルを```config/config.yml```として作成します。


### EC2インスタンスのメンテナンス予定を確認する(Check maintenance schedule of EC2 instances)

```
# ruby check_ec2_events.rb [target_region]
```

A list of maintenance schedules for each EC2 instances in target_region will be sent to you by email specifed in ```config/config.yml```.
If no target_region specified, this tool will check for "ap-northeast-1".

引数に指定したリージョン(target_region)内の各EC2インスタンスのメンテナンス予定が、```config/config.ymk```で指定したメールアドレス宛に送信されます。
なお、リージョンが指定されていない場合は、"ap-northeast-1"をチェックします。


##### メールサンプル (an example of email)
```
Subject: [info] EC2 event check : NEED CHECK
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

[id] i-90846c94 [status] running [event date] 2013-11-30
[id] i-e0927ae4 [status] running [event date]
[id] i-223dc026 [status] running [event date]
```

### 制限事項 (Known issues)
* Completed event may contained in the list for a while (Because of AWS API's spec).
* Only one event will be listed even if a instance planned for 2 or more events.

<!-- dummy comment to break list -->

* 完了済みのイベントもしばらくは拾ってしまう(AWSのAPIが返してくるため)。
* 複数のイベントが予定されてる場合も、ひとつしか取得できない。
