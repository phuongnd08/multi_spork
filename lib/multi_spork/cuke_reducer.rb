module MultiSpork
  class CukeReducer < ResultReducer
    def summarize(outputs)
      results = outputs.map do |output|
        read_result(output)
      end

      scenario_reduced = reduce(results.map { |result| result["scenario"][:details] })
      total_scenario = results.reduce(0) { |total, result| total + result["scenario"][:total] }
      step_reduced = reduce(results.map { |result| result["step"][:details] })
      total_step = results.reduce(0) { |total, result| total + result["step"][:total] }
      [
        pluralize("scenario", total_scenario) + ' (' + format(scenario_reduced, false) + ')',
        pluralize("step", total_step) + ' (' + format(step_reduced, false) + ')'
      ].join("\n")
    end

    def read_result(output)
      ["scenario", "step"].inject({}) do |hash, kind|
        hash[kind] = {}
        result_line = output.split("\n").detect { |line| line =~ /(\d+) #{kind}/ }
        if result_line
          result_line.match(/(\d+) #{kind}s? \((.+?)\)/).tap do |match|
            hash[kind] = {
              :total => match[1].to_i,
              :details => read_term_and_number(match[2])
            }
          end
        else
          hash[kind] = {
            :total => 0,
            :details => []
          }
        end
        hash
      end
    end
  end
end

