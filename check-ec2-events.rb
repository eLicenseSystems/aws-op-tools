# AWS用 EC2インスタンス メンテ予定状況確認ツール(プロト)
#
# config.ymlで指定したアカウントのインスタンス一覧を確認し、
# メンテ予定の有無を出力するツール
#
# ■使い方
#  $ ruby check-ec2.rb [target_region]
#    [target_region] チェック対象のリージョン。未指定の場合"ap-northeast-1"を参照する。
#
# ■制限事項
# ・cronに組み込めるよう、レポートをメールする機能の追加。
# ・そもそもまだMacでしか動作確認していません。Linux+1.8.7で動作確認。
# ・完了済みのイベントもしばらくは拾ってしまう。
# ・複数のイベントが予定されてる場合も、ひとつしか取得できない。

require File.expand_path(File.dirname(__FILE__) + '/config/load_config')

def check_ec2_status (target_region)
  ec2 = AWS::EC2.new

  # 対象リージョンの設定
  region = target_region
  region ||= "ap-northeast-1"
  region = ec2.regions[region]

  #FIXME: 存在しないリージョンだと、region.exists? がexceptionを吐いてしまう。。。
  #       直ったら、普通のunless文に直す。
  begin
    region.exists?
  rescue
    puts "Requested region '#{region.name}' does not exist.  Valid regions:"
    puts "  " + ec2.regions.map(&:name).join("\n  ")
    exit -1
  end

  # a region acts like the main EC2 interface
  ec2 = region

  list = ec2.client.describe_instance_status(:include_all_instances => true).instance_status_set.map { |v|
    [:id => v.instance_id,
      :status => v.instance_state.name,
      :has_event => !v.events_set.empty?,
      :event_date => v.events_set.empty? ? nil : v.events_set[0].not_before
    ]
  }

end

status_list = check_ec2_status(ARGV.first)

status_list.each { |v|
  puts "[id] #{v.id} [status] #{v.status} [event date] #{v.event_date}"
}

