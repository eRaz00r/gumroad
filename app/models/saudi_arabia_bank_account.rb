# frozen_string_literal: true

class SaudiArabiaBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "SA"
  BANK_CODE_FORMAT_REGEX = /^([a-zA-Z]){4}([a-zA-Z]){2}([0-9a-zA-Z]){2}([0-9a-zA-Z]{3})?$/
  private_constant :BANK_CODE_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::SAU.alpha2
  end

  def currency
    Currency::SAR
  end
end
