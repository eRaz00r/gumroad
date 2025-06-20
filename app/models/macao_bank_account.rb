# frozen_string_literal: true

class MacaoBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "MO"

  BANK_CODE_FORMAT_REGEX = /^[A-Za-z0-9]{8,11}$/
  private_constant :BANK_CODE_FORMAT_REGEX

  ACCOUNT_NUMBER_FORMAT_REGEX = /^\d{1,19}$/
  private_constant :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::MAC.alpha2
  end

  def currency
    Currency::MOP
  end
end
