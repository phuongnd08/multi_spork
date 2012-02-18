module MultiSpork
  module TestResolver
    def self.resolve(paths, surfix)
      test_set = []
      paths.each do |path|
        if path.end_with? surfix
          test_set << File.expand_path(path)
        else
          path = path + "/" unless path.end_with?("/")
          Dir[path + "**/*" + surfix].each { |filename| test_set << filename }
        end
      end
      test_set.uniq
    end
  end
end
