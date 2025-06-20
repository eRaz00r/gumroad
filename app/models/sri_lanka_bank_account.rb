# frozen_string_literal: true

class SriLankaBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "LK"

  BANK_CODE_FORMAT_REGEX = /^[a-z0-9A-Z]{11}$/
  BRANCH_CODE_FORMAT_REGEX = /^\d{7}$/
  ACCOUNT_NUMBER_FORMAT_REGEX = /^\d{10,18}$/
  private_constant :BANK_CODE_FORMAT_REGEX, :BRANCH_CODE_FORMAT_REGEX, :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::LKA.alpha2
  end

  def currency
    Currency::LKR
  end
end
