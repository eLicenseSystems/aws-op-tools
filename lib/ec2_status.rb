# AWS用 EC2インスタンスのステータス取得モジュール

require File.expand_path(File.dirname(__FILE__) + '/../config/load_config')

module Ec2Status

  def self.fetch_events (target_region)
    ec2 = AWS::EC2.new

    # 対象リージョンの設定
    region = ec2.regions[target_region]

    #FIXME: 存在しないリージョンだと、region.exists? がexceptionを吐いてしまう。
    #       直ったら、普通のunless文に直す。
    begin
      region.exists?
    rescue
      err_message = "Requested region '#{region.name}' does not exist.  Valid regions:"
      err_message += "  " + ec2.regions.map(&:name).join("\n  ")
      raise err_message
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

end
