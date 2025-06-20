# frozen_string_literal: true

class BahamasBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "BS"
  BANK_CODE_FORMAT_REGEX = /^[a-z0-9A-Z]{8,11}$/
  ACCOUNT_NUMBER_FORMAT_REGEX = /^\d{1,10}$/
  private_constant :BANK_CODE_FORMAT_REGEX, :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::BHS.alpha2
  end

  def currency
    Currency::BSD
  end
end
