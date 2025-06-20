# frozen_string_literal: true

class QatarBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "QA"
  BANK_CODE_FORMAT_REGEX = /^[a-zA-Z0-9]{11}$/
  ACCOUNT_NUMBER_FORMAT_REGEX = /^[a-zA-Z0-9]{29}$/
  private_constant :BANK_CODE_FORMAT_REGEX, :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::QAT.alpha2
  end

  def currency
    Currency::QAR
  end
end
