# frozen_string_literal: true

class OmanBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "OM"
  BANK_CODE_FORMAT_REGEX = /^[A-Z]{4}OM[A-Z0-9]{2,5}\z/
  ACCOUNT_NUMBER_FORMAT_REGEX = /^[0-9]{6,16}$/
  private_constant :BANK_CODE_FORMAT_REGEX, :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::OMN.alpha2
  end

  def currency
    Currency::OMR
  end
end
