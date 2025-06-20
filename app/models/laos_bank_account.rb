# frozen_string_literal: true

class LaosBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "LA"
  BANK_CODE_FORMAT_REGEX = /^([0-9a-zA-Z]){8,11}$/
  ACCOUNT_NUMBER_FORMAT_REGEX = /^([0-9a-zA-Z]){1,18}$/
  private_constant :BANK_CODE_FORMAT_REGEX, :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::LAO.alpha2
  end

  def currency
    Currency::LAK
  end
end
