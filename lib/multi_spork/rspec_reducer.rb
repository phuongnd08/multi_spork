module MultiSpork
  class RSpecReducer < ResultReducer
    def summarize(outputs)
      results = outputs.map do |output|
        read_result(output)
      end

      summary = format reduce(results)
    end

    def read_result(output)
      result_line = output.split("\n").detect { |line| line =~ /(\d+) example/ && line =~ /(\d+) failure/ }
      if result_line
        read_term_and_number(result_line)
      else
        []
      end
    end
  end
end
