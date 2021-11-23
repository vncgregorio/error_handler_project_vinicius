module ErrorHandler
  # Example:
  # class MyClass
  #   include ErrorHandler
  #
  #   def perform
  #
  #     expected_errors = Proc.new { |e| e.class == ZeroDivisionError || e.class == NoMethodError }
  #
  #     # or
  #
  #     expected_errors = Proc.new { |e| e.message.include?('divided by 0') || e.message.include?("undefined method") }
  #
  #     handle_errors(expected_errors) do
  #       result = 1 / 0
  #     end
  #   end
  # end
  def handle_errors(conditions_proc, &block)
    begin
      block.call
    rescue exceptions_matching(conditions_proc) => e
      # maybe use a logger for this ...
      puts "error_handler#handle_errors: catch an expected error! message: #{e.message}"
      return false
    end
  end

  def exceptions_matching(conditions_proc)
    Class.new do
      # overwrite the triple-equals for the class
      # inheritance chain comparison (similar to a #is_a?)
      # and .tap to set instance variables related
      # to the conditions_proc
      def self.===(exception)
        @conditions_proc.call(exception)
      end
    end.tap do |class_object|
      class_object.instance_variable_set(:@conditions_proc, conditions_proc)
    end
  end

end
