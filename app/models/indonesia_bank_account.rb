# frozen_string_literal: true

class IndonesiaBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "ID"

  BANK_CODE_FORMAT_REGEX = /\A[0-9a-zA-Z]{3,4}\z/
  private_constant :BANK_CODE_FORMAT_REGEX

  ACCOUNT_NUMBER_FORMAT_REGEX = /\A[0-9]{1,35}\z/
  private_constant :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::IDN.alpha2
  end

  def currency
    Currency::IDR
  end
end
