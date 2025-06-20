# frozen_string_literal: true

class KuwaitBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "KW"

  BANK_CODE_FORMAT_REGEX = /^[a-zA-Z0-9]{8,11}$/
  private_constant :BANK_CODE_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::KWT.alpha2
  end

  def currency
    Currency::KWD
  end
end
