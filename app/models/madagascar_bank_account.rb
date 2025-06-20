# frozen_string_literal: true

class MadagascarBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "MG"
  BANK_CODE_FORMAT_REGEX = /^([a-zA-Z]){4}([a-zA-Z]){2}([0-9a-zA-Z]){2}([0-9a-zA-Z]{3})?$/
  ACCOUNT_NUMBER_FORMAT_REGEX = /^MG([0-9]){25}$/
  private_constant :BANK_CODE_FORMAT_REGEX, :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::MDG.alpha2
  end

  def currency
    Currency::MGA
  end
end
