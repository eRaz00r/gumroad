# frozen_string_literal: true

class UruguayBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "UY"

  BANK_CODE_FORMAT_REGEX = /^\d{3}$/
  ACCOUNT_NUMBER_FORMAT_REGEX = /^\d{1,12}$/
  private_constant :BANK_CODE_FORMAT_REGEX, :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::URY.alpha2
  end

  def currency
    Currency::UYU
  end
end
