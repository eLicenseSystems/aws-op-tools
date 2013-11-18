# AWS用 EC2インスタンス メンテ予定状況確認ツール
#
# config.ymlで指定したアカウントのインスタンス一覧を確認し、
# メンテ予定の有無を出力するツール

require File.expand_path(File.dirname(__FILE__) + '/config/load_config')
require File.expand_path(File.dirname(__FILE__) + '/lib/mail_notifier')
require File.expand_path(File.dirname(__FILE__) + '/lib/ec2_status')

target_region = ARGV.first
target_region ||= "ap-northeast-1"

status_list = Ec2Status::fetch_events(target_region)

result = ""
need_check = false

status_list.each { |v|
  result += "[id] #{v.id} [status] #{v.status} [event date] #{v.event_date}\n"
  need_check = true if v.has_event
}

if need_check
  MailNotifier::send_warn_mail("EC2 event check : NEED CHECK", result)
else
  MailNotifier::send_info_mail("EC2 event check : OK", result)
end
