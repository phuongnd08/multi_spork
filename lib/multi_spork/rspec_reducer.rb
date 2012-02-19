module MultiSpork
  module RSpecReducer
    class << self
      def reduce(outputs)
        results = outputs.map do |output|
          line = output.split("\n", -1)[-2]
          if line && !line.empty?
            line.scan(/(\d+) (\w+?)s?\b/)
          else
            []
          end
        end

        summary = results.inject({}) do |hash, result|
          result.inject(hash) do |hash, (count, term)|
            hash[term] ||= 0
            hash[term] += count.to_i
            hash
          end
        end

        summary.map { |term, count| "#{count} #{term}#{'s' if count != 1}" }.
          join(", ")
      end
    end
  end
end
