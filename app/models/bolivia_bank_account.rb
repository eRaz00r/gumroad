# frozen_string_literal: true

class BoliviaBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "BO"
  BANK_CODE_FORMAT_REGEX = /^\d{1,3}$/
  ACCOUNT_NUMBER_FORMAT_REGEX = /^\d{10,15}$/
  private_constant :BANK_CODE_FORMAT_REGEX, :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::BOL.alpha2
  end

  def currency
    Currency::BOB
  end
end
