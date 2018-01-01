class ImprovedDocReporter < Spec2::Reporters::Doc
  def report
    output.puts

    @errors.each do |e|
      example = e.example.not_nil!
      output.puts
      output.puts :failure, "In example: #{example.description}"
      print_exception e, "Failure"
      print_exception e.cause.as(Exception), "Cause" unless e.cause.nil?
    end

    output.puts
    status = @errors.size > 0 ? :failure : :success
    output.puts "Finished in #{::Spec2::ElapsedTime.new.to_s}"
    output.puts status, "Examples: #{@count}, failures: #{@errors.size}, pending: #{@pending}"
  end

  private def print_exception(e : Exception, key)
    output.puts :failure, "\t#{key}: #{e}"

    if trace = e.backtrace?
      output.puts :failure, trace.map { |line| "\t\t#{line}" }.join("\n")
    end
  end
end
