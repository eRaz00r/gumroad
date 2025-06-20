# frozen_string_literal: true

class KazakhstanBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "KZ"
  BANK_CODE_FORMAT_REGEX = /^[a-zA-Z0-9]{8,11}\z/
  private_constant :BANK_CODE_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::KAZ.alpha2
  end

  def currency
    Currency::KZT
  end
end
