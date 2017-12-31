require "../spec_helper"

describe Dirwatch::UserFriendlyException do
  context "without internal message" do
    it "uses the readable message without a cause" do
      e = Dirwatch::UserFriendlyException.new "my readable message"
      e.readable_message.should be "my readable message"
      e.message.should be "my readable message"
      e.cause.should be_nil
    end

    it "uses the readable message with a cause" do
      cause = Exception.new "another one"
      e = Dirwatch::UserFriendlyException.new "my readable message", cause
      e.readable_message.should be "my readable message"
      e.message.should be "my readable message"
      e.cause.should be cause
    end
  end

  context "with internal message" do
    it "ignores the readable message without a cause" do
      e = Dirwatch::UserFriendlyException.new "my readable message", "my internal message"
      e.readable_message.should be "my readable message"
      e.message.should be "my internal message"
      e.cause.should be_nil
    end

    it "ignores the readable message with a cause" do
      cause = Exception.new "another one"
      e = Dirwatch::UserFriendlyException.new "my readable message", "my internal message", cause
      e.readable_message.should be "my readable message"
      e.message.should be "my internal message"
      e.cause.should be cause
    end
  end
end
