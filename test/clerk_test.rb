require 'test_helper'

class ClerkTest < MiniTest::Unit::TestCase
  # list
  def test_returns_empty_list
    VCR.use_cassette("list_empty") do
      result = Clerk::Form.list

      assert_equal [], result
    end
  end

  def test_returns_list_of_forms
    VCR.use_cassette("list_2_forms") do
      result = Clerk::Form.list

      expected_result = [
        {
          "id"         => "41c36a6c-3c7d-4028-8f15-5bee22ea0952",
          "user_id"    => "f893913f-e763-42e7-816b-d9b9d5b07de3",
          "created_at" => "2014-03-09T08:02:57.112Z",
          "updated_at" => "2014-03-09T08:02:57.112Z",
          "pdf"        => {"url"=>"/uploads/form/pdf/41c36a6c-3c7d-4028-8f15-5bee22ea0952/form.pdf"},
          "identifier" => "VAT7-1",
          "fields"     => {
            "first_name"  => "string",
            "last_name"   => "string",
            "test_period" => "boolean",
            "skills"      => "array"
          }
        },
        {
          "id"         => "8afc8eeb-ff47-4342-8bfb-813cce372ce2",
          "user_id"    => "f893913f-e763-42e7-816b-d9b9d5b07de3",
          "created_at" => "2014-03-09T07:54:22.992Z",
          "updated_at" => "2014-03-09T07:54:22.992Z",
          "pdf"        => {"url"=>"/uploads/form/pdf/8afc8eeb-ff47-4342-8bfb-813cce372ce2/form.pdf"},
          "identifier" => "VAT7-2",
          "fields"     => {
            "first_name"  =>"string",
            "last_name"   =>"string",
            "test_period" =>"boolean",
            "skills"      =>"array"
          }
        }
      ]
      assert_equal expected_result, result
    end
  end

  def test_sync_printouts_successfully
    VCR.use_cassette("printout_form_successfully") do
      fields = {
        "first_name" => "Mateusz",
        "last_name"  => "Juraszek",
        "student"    => "Yes",
        "sex"        => "1",
        "age"        => "15 - 18",
        "hobby"      => "fishing",
        "comment"    => "What the f***?"
      }
      fileless = Clerk::Form.print("aoa_pl", fields)
      assert_equal 83733, fileless.size
      assert_equal 'aoa_pl.pdf', fileless.original_filename
      assert_equal 'application/pdf', fileless.content_type
    end
  end
end
