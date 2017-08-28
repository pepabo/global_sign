module CSRHelper
  def example_csr
    @valid_csr ||= File.read('spec/fixtures/csrs/valid.csr').strip
  end

  def invalid_csr
    @invalid_csr ||= File.read('spec/fixtures/csrs/invalid.csr').strip
  end
end
