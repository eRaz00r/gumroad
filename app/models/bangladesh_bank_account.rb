# frozen_string_literal: true

class BangladeshBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "BD"
  BANK_CODE_FORMAT_REGEX = /^([0-9a-zA-Z]){9}$/
  ACCOUNT_NUMBER_FORMAT_REGEX = /^([0-9a-zA-Z]){13,17}$/
  private_constant :BANK_CODE_FORMAT_REGEX, :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::BGD.alpha2
  end

  def currency
    Currency::BDT
  end
end
