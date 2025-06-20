# frozen_string_literal: true

class NorthMacedoniaBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "MK"
  BANK_CODE_FORMAT_REGEX = /\A[a-zA-Z0-9]{8,11}\z/
  ACCOUNT_NUMBER_FORMAT_REGEX = /\A[a-zA-Z0-9]{19}\z/
  private_constant :BANK_CODE_FORMAT_REGEX, :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::MKD.alpha2
  end

  def currency
    Currency::MKD
  end
end
