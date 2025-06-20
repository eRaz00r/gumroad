# frozen_string_literal: true

class NamibiaBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "NA"
  BANK_CODE_FORMAT_REGEX = /^[a-zA-Z0-9]{8,11}$/
  ACCOUNT_NUMBER_FORMAT_REGEX = /^[a-zA-Z0-9]{8,13}$/
  private_constant :BANK_CODE_FORMAT_REGEX, :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::NAM.alpha2
  end

  def currency
    Currency::NAD
  end
end
