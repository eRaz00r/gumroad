# frozen_string_literal: true

class ParaguayBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "PY"
  BANK_CODE_FORMAT_REGEX = /\A[0-9]{1,2}\z/
  ACCOUNT_NUMBER_FORMAT_REGEX = /\A[0-9]{1,16}\z/
  private_constant :BANK_CODE_FORMAT_REGEX, :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::PRY.alpha2
  end

  def currency
    Currency::PYG
  end
end
