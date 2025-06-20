# frozen_string_literal: true

class EgyptBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "EG"

  BANK_CODE_FORMAT_REGEX = /^([a-zA-Z]){4}([a-zA-Z]){2}([0-9a-zA-Z]){2}([0-9a-zA-Z]{3})?$/
  private_constant :BANK_CODE_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::EGY.alpha2
  end

  def currency
    Currency::EGP
  end
end
