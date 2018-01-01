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

  context "#from_yaml" do
    it "handles empty files" do
      yaml = ""
      expect(described_class.from_yaml yaml).to eq [] of Dirwatch::Setting
    end

    it "creates correct settings without a defaults section" do
      yaml = <<-EOT
my-test-task:
  interval: 15
  script: test cmd
  directory: ./test1
  file_match: "*.txt"

another-task:
  file_match: "*.csv"
  interval: 6
  script:
    - test cmd1
    - test cmd2
  directory: /test3
EOT
      expect(described_class.from_yaml yaml).to eq [
        described_class.new(key: "my-test-task", directory: "./test1", file_match: "*.txt", interval: 15.0, scripts: ["test cmd"]),
        described_class.new(key: "another-task", directory: "/test3", file_match: "*.csv", interval: 6.0, scripts: ["test cmd1", "test cmd2"]),
      ]
    end

    it "creates correct settings with a full defaults section" do
      yaml = <<-EOT
defaults:
  interval: 2
  script: test base cmd
  directory: ./base/dir
  file_match: "*.sh"

task1: {}

task2:
  file_match: "*.something.else"

task3:
  file_match: "*.csv"
  interval: 6
  script:
    - test cmd1
    - test cmd2
  directory: /test3
EOT
      expect(described_class.from_yaml yaml).to eq [
        described_class.new(key: "task1", directory: "./base/dir", file_match: "*.sh", interval: 2.0, scripts: ["test base cmd"]),
        described_class.new(key: "task2", directory: "./base/dir", file_match: "*.something.else", interval: 2.0, scripts: ["test base cmd"]),
        described_class.new(key: "task3", directory: "/test3", file_match: "*.csv", interval: 6.0, scripts: ["test cmd1", "test cmd2"]),
      ]
    end

    it "creates correct settings with a small defaults section" do
      yaml = <<-EOT
defaults:
  interval: 2

task1:
  script: test cmd
  directory: ./test1
  file_match: "*.txt"

task2:
  file_match: "*.csv"
  interval: 6
  script:
    - test cmd1
    - test cmd2
  directory: /test3
EOT
      expect(described_class.from_yaml yaml).to eq [
        described_class.new(key: "task1", directory: "./test1", file_match: "*.txt", interval: 2.0, scripts: ["test cmd"]),
        described_class.new(key: "task2", directory: "/test3", file_match: "*.csv", interval: 6.0, scripts: ["test cmd1", "test cmd2"]),
      ]
    end

    it "uses the global defaults" do
      yaml = <<-EOT
task:
  script: test cmd
  file_match: "*.txt"
EOT
      expect(described_class.from_yaml yaml).to eq [
        described_class.new(key: "task", directory: ".", file_match: "*.txt", interval: 1.0, scripts: ["test cmd"]),
      ]
    end
  end
end
