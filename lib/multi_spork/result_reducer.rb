module MultiSpork
  class ResultReducer
    def reduce(results)
      results.inject({}) do |hash, result|
        result.inject(hash) do |hash, (count, term)|
          hash[term] ||= 0
        hash[term] += count.to_i
        hash
        end
      end
    end

    def pluralize(word, count)
      "#{count} #{word}#{'s' if count != 1}"
    end

    def format(reduced_result, auto_pluralize = true)
      reduced_result.map do |term, count|
        if auto_pluralize
          pluralize(term, count)
        else
          "#{count} #{term}"
        end
      end.join(", ")
    end

    def read_term_and_number(text)
      text.scan(/(\d+) (\w+?)s?\b/)
    end
  end
end
