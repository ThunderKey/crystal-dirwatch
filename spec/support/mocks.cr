require "spec2-mocks"

Mocks.create_struct_mock Dirwatch::Setting do
  mock self.from_yaml(content)
end
