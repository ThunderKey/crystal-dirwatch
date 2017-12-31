require "file_utils"

def create_test_dir(dir)
  remove_test_dir dir
  Dir.mkdir dir
end

def remove_test_dir(dir)
  FileUtils.rm_r dir if Dir.exists? dir
end
