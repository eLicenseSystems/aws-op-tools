# 警報メール送信モジュール

require File.expand_path(File.dirname(__FILE__) + '/../config/load_config')
require 'action_mailer'

class MailNotifier
  class Mailer < ActionMailer::Base
    def sendMessage(toAddress, mySubject, myBody)
      smtp_settings = {
        address: CONFIG["mail_notifier"]["hostname"],
        port: CONFIG["mail_notifier"]["port"],
        domain: CONFIG["mail_notifier"]["domain"],
        user_name: CONFIG["mail_notifier"]["username"],
        password: CONFIG["mail_notifier"]["password"],
        enable_starttls_auto: false
      }

      raise_delivery_errors = true

      mail(
        from: CONFIG["mail_notifier"]["mail_from"],
        to: toAddress,
        subject: mySubject,
        body: myBody
      ).deliver

    end
  end

  def self.send_info_mail (subject = "", body)
    subject = "[info] " + subject
    Mailer.sendMessage(CONFIG["mail_notifier"]["info_mail_to"], subject, body)
  end

  def self.send_warn_mail (subject = "", body)
    subject = "[warn] " + subject
    Mailer.sendMessage(CONFIG["mail_notifier"]["warn_mail_to"], subject, body)
  end

  def self.send_error_mail (subject = "", body)
    subject = "[error] " + subject
    Mailer.sendMessage(CONFIG["mail_notifier"]["error_mail_to"], subject, body)
  end


end