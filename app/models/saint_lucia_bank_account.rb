# frozen_string_literal: true

class SaintLuciaBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "LC"
  BANK_CODE_FORMAT_REGEX = /^[a-zA-Z0-9]{8,11}$/
  ACCOUNT_NUMBER_FORMAT_REGEX = /^[a-zA-Z0-9]{1,32}$/
  private_constant :BANK_CODE_FORMAT_REGEX, :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::LCA.alpha2
  end

  def currency
    Currency::XCD
  end
end
