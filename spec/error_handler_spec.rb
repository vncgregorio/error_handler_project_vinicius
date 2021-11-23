require "error_handler"

describe ErrorHandler do
  let(:dummy_class) { Class.new { include ErrorHandler }}

  it "is an object" do
    expect(ErrorHandler).to be_a(Object)
  end

  context "when catching expected errors" do
    let(:expected_errors) { Proc.new { |e| e.class == ZeroDivisionError } }
    let(:try_code) { Proc.new { 1 / 0 }  }

    it "returns false" do
      expect( dummy_class.new.handle_errors(expected_errors, &try_code) ).to be_falsey
    end

    it "outputs the error message" do
      expect do
        dummy_class.new.handle_errors(expected_errors, &try_code)
      end.to output("error_handler#handle_errors: catch an expected error! message: divided by 0\n").to_stdout
    end
  end

  context "when working unexpected errors" do
    let(:expected_errors) { Proc.new { |e| e.class == ZeroDivisionError } }
    let(:try_code) { Proc.new { 1.no_method("undefined method") }  }

    it "it raises the error" do
      expect{ dummy_class.new.handle_errors(expected_errors, &try_code) }.to raise_error(NoMethodError)
    end
  end

end
