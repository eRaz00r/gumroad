# frozen_string_literal: true

class EcuadorBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "EC"
  BANK_CODE_FORMAT_REGEX = /^[a-zA-Z0-9]{8,11}\z/
  ACCOUNT_NUMBER_FORMAT_REGEX = /\A[0-9]{5,18}\z/
  private_constant :BANK_CODE_FORMAT_REGEX, :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::ECU.alpha2
  end

  def currency
    Currency::USD
  end
end
