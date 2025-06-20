# frozen_string_literal: true

class PakistanBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "PK"

  BANK_CODE_FORMAT_REGEX = /^([a-zA-Z]){4}([a-zA-Z]){2}([0-9a-zA-Z]){2}([0-9a-zA-Z]{3})?$/
  private_constant :BANK_CODE_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::PAK.alpha2
  end

  def currency
    Currency::PKR
  end
end
