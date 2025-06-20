# frozen_string_literal: true

class AlgeriaBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "DZ"
  BANK_CODE_FORMAT_REGEX = /^([0-9a-zA-Z]){8,11}$/
  ACCOUNT_NUMBER_FORMAT_REGEX = /^\d{20}$/
  private_constant :BANK_CODE_FORMAT_REGEX, :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::DZA.alpha2
  end

  def currency
    Currency::DZD
  end
end
