# frozen_string_literal: true

class SouthAfricaBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "ZA"

  BANK_CODE_FORMAT_REGEX = /^([a-zA-Z]){4}([a-zA-Z]){2}([0-9a-zA-Z]){2}([0-9a-zA-Z]{3})?$/
  private_constant :BANK_CODE_FORMAT_REGEX

  ACCOUNT_NUMBER_FORMAT_REGEX = /\A[0-9a-zA-Z]{1,16}\z/
  private_constant :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::ZAF.alpha2
  end

  def currency
    Currency::ZAR
  end
end
