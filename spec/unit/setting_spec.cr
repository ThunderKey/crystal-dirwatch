require "../spec_helper"

Spec2.describe Dirwatch::Setting do
  context "#from_file" do
    let(:dir) { "./tmp" }
    let(:file) { "#{dir}/tmp.yml" }
    before { create_test_dir dir }
    after { remove_test_dir dir }

    it "reads the file correctly and passes it to from_yaml" do
      expect(described_class).to receive(self.from_yaml("My\nLong File\nContent")).and_return [] of Dirwatch::Setting

      File.write file, <<-EOT
My
Long File
Content
EOT

      expect(described_class.from_file file).to eq [] of Dirwatch::Setting
    end
  end
end
