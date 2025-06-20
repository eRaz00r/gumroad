# frozen_string_literal: true

class ThailandBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "TH"

  BANK_CODE_FORMAT_REGEX = /\A[0-9]{3}\z/
  private_constant :BANK_CODE_FORMAT_REGEX

  ACCOUNT_NUMBER_FORMAT_REGEX = /\A[0-9]{6,15}\z/
  private_constant :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::THA.alpha2
  end

  def currency
    Currency::THB
  end
end
