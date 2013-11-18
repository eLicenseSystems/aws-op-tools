require 'rspec'

require File.expand_path(File.dirname(__FILE__) + '/../lib/ec2_status')

describe Ec2Status do
  describe "#fetch_events" do

    context "存在しないregionをチェックすると、" do

      it "利用可能なregionの一覧が表示される" do
        expect { Ec2Status::fetch_events("ap-northeast-X") }.to raise_error(RuntimeError, /Requested region \'ap-northeast-X\' does not exist\.  Valid regions\:/)
      end
    end

    context "インスタンスがないregionをチェックすると、" do
      before :all do
        @list = Ec2Status::fetch_events("us-west-1")
      end

      it "空のHashを返す" do
        expect(@list).to be_empty
      end
    end

    context "インスタンスが存在するregionをチェックすると、" do
      context "イベントが存在しない場合、" do
        before :all do
          no_event_list = [
            {id: "XXXXXXX", status: "running", has_event: false, event_date: nil},
            {id: "YYYYYYY", status: "stopped", has_event: false, event_date: nil},
            {id: "ZZZZZZZ", status: "running", has_event: false, event_date: nil}
          ]

          Ec2Status.should_receive(:fetch_events).with("no_event_region").and_return(no_event_list)

          @list = Ec2Status::fetch_events("no_event_region")
        end

        it "インスタンスのリストは返ってくる。" do
          expect(@list).not_to be_empty
        end

        it "has_eventフラグはひとつも立っていない。" do
          has_event = false
          @list.each do |v|
            has_event ||= v[:has_event]
          end

          expect(has_event).to be_false
        end

        it "event_dateはすべて空欄。" do
          has_event_date = false
          @list.each do |v|
            has_event_date ||= ! v[:event_date].nil?
          end

          expect(has_event_date).to be_false
        end

      end

      context "イベントが存在する場合、" do
        before :all do
          has_event_list = [
            {id: "XXXXXXX", status: "running", has_event: false, event_date: nil},
            {id: "ZZZZZZZ", status: "running", has_event: true, event_date: "2013-10-31"},
            {id: "AAAAAAA", status: "stopped", has_event: false, event_date: nil},
            {id: "YYYYYYY", status: "stopped", has_event: false, event_date: nil}
          ]

          Ec2Status.should_receive(:fetch_events).with("has_event_region").and_return(has_event_list)

          @list = Ec2Status::fetch_events("has_event_region")
        end

        it "インスタンスのリストは返ってくる。" do
          expect(@list).not_to be_empty
        end

        it "has_eventフラグはひとつは立っている。" do
          has_event = false

          @list.each do |v|
            has_event ||= v[:has_event]
          end

          expect(has_event).to be_true
        end

        it "event_dateはどれかは入っている。" do
          has_event_date = false
          @list.each do |v|
            has_event_date ||= ! v[:event_date].nil?
          end

          expect(has_event_date).to be_true
        end
      end

    end

  end

end