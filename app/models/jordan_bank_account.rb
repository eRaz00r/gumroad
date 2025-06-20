# frozen_string_literal: true

class JordanBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "JO"

  BANK_CODE_FORMAT_REGEX = /^([0-9a-zA-Z]){8,11}$/
  private_constant :BANK_CODE_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::JOR.alpha2
  end

  def currency
    Currency::JOD
  end
end
