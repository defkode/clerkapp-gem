require 'test_helper'

class ClerkTest < MiniTest::Unit::TestCase
  def setup
    @fields = {
      "first_name" => "Mateusz",
      "last_name"  => "Juraszek",
      "student"    => "Yes",
      "sex"        => "1",
      "age"        => "15 - 18",
      "hobby"      => "fishing",
      "comment"    => "Don't call after 11 PM"
    }
  end

  def test_sync_printout_returns_file_url
    VCR.use_cassette("printout_form_successfully") do
      result = Clerk::Form.print("aoa_pl", @fields)

      expected_results = "https://clerkapp-development.s3.amazonaws.com/uploads/printout/pdf/beb7fb2e-ae4f-4a53-8567-067208c90fe0/printout.pdf?AWSAccessKeyId=AKIAJDUOZ6WHBRHTZMQA\u0026Expires=1407094566\u0026Signature=rEmUYwVxrt1jtHo3My2spWSLs%2Bc%3D"
      assert_equal expected_results, result
    end
  end

  def test_sync_printout_with_block_returns_file_url
    VCR.use_cassette("printout_form_successfully") do
      Clerk::Form.print("aoa_pl", @fields) do |result, error|
        expected_results = "https://clerkapp-development.s3.amazonaws.com/uploads/printout/pdf/beb7fb2e-ae4f-4a53-8567-067208c90fe0/printout.pdf?AWSAccessKeyId=AKIAJDUOZ6WHBRHTZMQA\u0026Expires=1407094566\u0026Signature=rEmUYwVxrt1jtHo3My2spWSLs%2Bc%3D"

        assert_equal expected_results, result
        assert_nil   error
      end
    end
  end

  def test_sync_printout_returns_file
    VCR.use_cassette("printout_form_successfully_returns_file") do
      result = Clerk::Form.print("aoa_pl", @fields, file: true)

      assert_equal 288054, result.size
      assert_equal "application/pdf", result.content_type
      assert_equal "printout.pdf", result.original_filename
    end
  end

  def test_sync_printout_raises_invalid_request
    VCR.use_cassette("printout_authorization_failed") do
      assert_raises Clerk::InvalidToken do
        Clerk::Form.print("aoa_pl", @fields, file: true)
      end
    end
  end

  def test_sync_printout_returns_authorization_failed
    VCR.use_cassette("printout_maintenance_mode") do
      Clerk::Form.print("aoa_pl", @fields) do |result, error|
        assert_nil     result
        assert_kind_of Clerk::MaintenanceMode, error
      end
    end
  end
end
