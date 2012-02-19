module MultiSpork
  class RSpecReducer < ResultReducer
    def find_result(output)
      output.split("\n").detect { |line| line =~ /(\d+) example/ && line =~ /(\d+) failure/ }
    end
  end
end
