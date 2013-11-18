require 'rspec'

require File.expand_path(File.dirname(__FILE__) + '/../lib/mail_notifier')
require 'email-spec'

RSpec.configure do |config|
  config.include(EmailSpec::Helpers)
  config.include(EmailSpec::Matchers)
end

describe MailNotifier do
  describe "#send_info_mail" do
    before :each do
      @subject = "件名"
      @body = "本文テスト"
      @mail = MailNotifier.send_info_mail(@subject, @body)
    end

    it "正しい宛先に送信される" do
      expect(@mail).to deliver_to(CONFIG["mail_notifier"]["info_mail_to"])
    end

    it "正しい送信元が設定される" do
      expect(@mail).to deliver_from(CONFIG["mail_notifier"]["mail_from"])
    end

    it "件名は[info]で始まる" do
      expect(@mail).to have_subject("[info] " + @subject)
    end

    it "本文が指定した文面となる" do
      expect(@mail).to have_body_text(@body)
    end
  end

  describe "#send_warn_mail" do
    before :each do
      @subject = "件名"
      @body = "本文テスト"
      @mail = MailNotifier.send_warn_mail(@subject, @body)
    end

    it "正しい宛先に送信される" do
      expect(@mail).to deliver_to(CONFIG["mail_notifier"]["info_mail_to"])
    end

    it "正しい送信元が設定される" do
      expect(@mail).to deliver_from(CONFIG["mail_notifier"]["mail_from"])
    end

    it "件名は[warn]で始まる" do
      expect(@mail).to have_subject("[warn] " + @subject)
    end

    it "本文が指定した文面となる" do
      expect(@mail).to have_body_text(@body)
    end
  end

  describe "#send_error_mail" do
    before :each do
      @subject = "件名"
      @body = "本文テスト"
      @mail = MailNotifier.send_error_mail(@subject, @body)
    end

    it "正しい宛先に送信される" do
      expect(@mail).to deliver_to(CONFIG["mail_notifier"]["info_mail_to"])
    end

    it "正しい送信元が設定される" do
      expect(@mail).to deliver_from(CONFIG["mail_notifier"]["mail_from"])
    end

    it "件名は[error]で始まる" do
      expect(@mail).to have_subject("[error] " + @subject)
    end

    it "本文が指定した文面となる" do
      expect(@mail).to have_body_text(@body)
    end
  end
end