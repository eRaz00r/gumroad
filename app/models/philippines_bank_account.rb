# frozen_string_literal: true

class PhilippinesBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "PH"

  BANK_CODE_FORMAT_REGEX = /\A[A-Za-z0-9]{8,11}\z/
  private_constant :BANK_CODE_FORMAT_REGEX

  ACCOUNT_NUMBER_FORMAT_REGEX = /\A[0-9]{1,17}\z/
  private_constant :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::PHL.alpha2
  end

  def currency
    Currency::PHP
  end
end
