require "../spec_helper"

Spec2.describe Dirwatch::UserFriendlyException do
  context "without internal message" do
    it "uses the readable message without a cause" do
      e = described_class.new "my readable message"
      expect(e.readable_message).to be "my readable message"
      expect(e.message).to be "my readable message"
      expect(e.cause).to be_nil
    end

    it "uses the readable message with a cause" do
      cause = Exception.new "another one"
      e = described_class.new "my readable message", cause
      expect(e.readable_message).to be "my readable message"
      expect(e.message).to be "my readable message"
      expect(e.cause).to be cause
    end
  end

  context "with internal message" do
    it "ignores the readable message without a cause" do
      e = described_class.new "my readable message", "my internal message"
      expect(e.readable_message).to be "my readable message"
      expect(e.message).to be "my internal message"
      expect(e.cause).to be_nil
    end

    it "ignores the readable message with a cause" do
      cause = Exception.new "another one"
      e = described_class.new "my readable message", "my internal message", cause
      expect(e.readable_message).to be "my readable message"
      expect(e.message).to be "my internal message"
      expect(e.cause).to be cause
    end
  end
end
