# frozen_string_literal: true

class GabonBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "GA"
  BANK_CODE_FORMAT_REGEX = /^[0-9A-Za-z]{8,11}$/
  ACCOUNT_NUMBER_FORMAT_REGEX = /^[0-9]{23}$/
  private_constant :BANK_CODE_FORMAT_REGEX, :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::GAB.alpha2
  end

  def currency
    Currency::XAF
  end
end
