module MultiSpork
  module ShellExecutor
    class << self
      def execute cmd
        f = open("|#{cmd}", 'r')
          output = fetch_output(f)
        f.close
        output
      end

      def fetch_output(process)
        all = ''
        buffer = ''
        timeout = 0.2
        flushed = Time.now.to_f

        while char = process.getc
          char = (char.is_a?(Fixnum) ? char.chr : char) # 1.8 <-> 1.9
          all << char

          # print in chunks so large blocks stay together
          now = Time.now.to_f
          buffer << char
          if flushed + timeout < now
            $stdout.print buffer
            $stdout.flush
            buffer = ''
            flushed = now
          end
        end

        # print the remainder
        $stdout.print buffer
        $stdout.flush

        all
      end
    end
  end
end
